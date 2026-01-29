-- collector.lua
-- Public API data collector for OTClient (safe, opt-in)

CTOmodule = CTOmodule or {}
CTOmodule.collector = CTOmodule.collector or {}

local M = CTOmodule.collector

M.config = M.config or {
  enabled = true,
  intervalMs = 1000,
  outputPath = 'config/collector_output.lua',
  maxFileSize = 256 * 1024,
  retention = 3,
  privacyMode = true,
  dryRun = false,
  dedupe = true,
}

M.state = M.state or {
  running = false,
  event = nil,
  lastHash = nil,
  lastWriteAt = 0,
}

local function log(msg)
  if CTOmodule and CTOmodule.log then
    CTOmodule.log('[collector] ' .. tostring(msg))
  else
    print('[collector] ' .. tostring(msg))
  end
end

local function safeCall(fn, ...)
  if type(fn) ~= 'function' then return false, nil end
  local ok, res = pcall(fn, ...)
  if ok then return true, res end
  return false, nil
end

local function getRootWidgetSafeLocal()
  if g_ui and type(g_ui.getRootWidget) == 'function' then
    local ok, w = safeCall(g_ui.getRootWidget, g_ui)
    if ok and w then return w end
    ok, w = safeCall(g_ui.getRootWidget)
    if ok and w then return w end
  end
  if type(getRootWidgetSafe) == 'function' then
    local ok, w = safeCall(getRootWidgetSafe)
    if ok and w then return w end
  end
  return rootWidget
end

local function schedule(fn, delay)
  if type(scheduleEvent) == 'function' then
    return scheduleEvent(fn, delay)
  end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == 'function' then
    return g_dispatcher:scheduleEvent(fn, delay)
  end
  if type(addEvent) == 'function' then
    return addEvent(fn, delay)
  end
  return nil
end

local function cancelEvent(ev)
  if not ev then return end
  if type(removeEvent) == 'function' then
    pcall(removeEvent, ev)
    return
  end
  if g_dispatcher and type(g_dispatcher.cancelEvent) == 'function' then
    pcall(function() g_dispatcher:cancelEvent(ev) end)
  end
end

local function readFileSafe(path)
  if g_resources and type(g_resources.readFileContents) == 'function' then
    local ok, data = safeCall(g_resources.readFileContents, path)
    if ok then return data end
  end
  local f = io.open(path, 'rb')
  if not f then return nil end
  local data = f:read('*a')
  f:close()
  return data
end

local function writeFileSafe(path, content)
  if g_resources and type(g_resources.writeFileContents) == 'function' then
    local ok = safeCall(g_resources.writeFileContents, path, content)
    return ok
  end
  local f = io.open(path, 'wb')
  if not f then return false end
  f:write(content)
  f:close()
  return true
end

local function fileSizeSafe(path)
  local f = io.open(path, 'rb')
  if not f then return 0 end
  local size = f:seek('end') or 0
  f:close()
  return size
end

local function rotateFiles(path, retention)
  retention = tonumber(retention or 0) or 0
  if retention <= 0 then return end
  for i = retention - 1, 1, -1 do
    local src = path .. '.' .. tostring(i)
    local dst = path .. '.' .. tostring(i + 1)
    pcall(os.rename, src, dst)
  end
  pcall(os.rename, path, path .. '.1')
end

local function checksum32(s)
  local h = 0
  for i = 1, #s do
    h = (h * 31 + s:byte(i)) % 4294967296
  end
  return h
end

local function serializeLua(value, indent)
  indent = indent or 0
  local t = type(value)
  if t == 'nil' then return 'nil' end
  if t == 'number' or t == 'boolean' then return tostring(value) end
  if t == 'string' then return string.format('%q', value) end
  if t ~= 'table' then return string.format('%q', tostring(value)) end

  local pad = string.rep('  ', indent)
  local out = { '{' }

  local keys = {}
  for k, _ in pairs(value) do keys[#keys + 1] = k end
  table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

  for _, k in ipairs(keys) do
    local v = value[k]
    local key
    if type(k) == 'string' and k:match('^[_%a][_%w]*$') then
      key = k .. ' = '
    else
      key = '[' .. serializeLua(k) .. '] = '
    end
    out[#out + 1] = pad .. '  ' .. key .. serializeLua(v, indent + 1) .. ','
  end

  out[#out + 1] = pad .. '}'
  return table.concat(out, '\n')
end

local function widgetChildren(widget)
  local ok, children = safeCall(widget.getChildren, widget)
  if ok and type(children) == 'table' then return children end

  local out = {}
  local okCount, count = safeCall(widget.getChildCount, widget)
  if okCount and type(count) == 'number' then
    for i = 1, count do
      local okChild, child = safeCall(widget.getChildByIndex, widget, i)
      if okChild and child then out[#out + 1] = child end
    end
  end
  return out
end

local function widgetInfo(widget, depth, privacy)
  local info = { depth = depth }

  local _, id = safeCall(widget.getId, widget)
  local _, cls = safeCall(widget.getClassName, widget)
  local _, style = safeCall(widget.getStyleName, widget)
  local _, vis = safeCall(widget.isVisible, widget)
  local _, enabled = safeCall(widget.isEnabled, widget)
  local _, text = safeCall(widget.getText, widget)

  local _, size = safeCall(widget.getSize, widget)
  local _, pos = safeCall(widget.getPosition, widget)
  local _, width = safeCall(widget.getWidth, widget)
  local _, height = safeCall(widget.getHeight, widget)

  info.id = id
  info.className = cls
  info.styleName = style
  info.visible = vis
  info.enabled = enabled

  if size and type(size) == 'table' then
    info.size = { w = size.width or size.w, h = size.height or size.h }
  else
    info.size = { w = width, h = height }
  end

  if pos and type(pos) == 'table' then
    info.position = { x = pos.x, y = pos.y }
  end

  if not privacy then
    info.text = text
  end

  local _, anchors = safeCall(widget.getAnchors, widget)
  if anchors ~= nil then
    info.anchors = tostring(anchors)
  end

  return info
end

local function collectWidgetTree(root, privacy)
  if not root then return {} end
  local out = {}
  local queue = { { w = root, d = 0 } }

  while #queue > 0 do
    local node = table.remove(queue, 1)
    local w = node.w
    local d = node.d

    out[#out + 1] = widgetInfo(w, d, privacy)

    local children = widgetChildren(w)
    for i = 1, #children do
      queue[#queue + 1] = { w = children[i], d = d + 1 }
    end
  end

  return out
end

local function collectWindowList(root, privacy)
  local out = {}
  if not root then return out end
  local children = widgetChildren(root)
  for i = 1, #children do
    local w = children[i]
    local _, cls = safeCall(w.getClassName, w)
    local _, text = safeCall(w.getText, w)
    if cls and tostring(cls):lower():find('window', 1, true) then
      out[#out + 1] = {
        id = safeCall(w.getId, w) and select(2, safeCall(w.getId, w)) or nil,
        className = cls,
        text = privacy and nil or text,
      }
    end
  end
  return out
end

local function collectHotkeys()
  local out = {}
  if CTOmodule and CTOmodule._actionHotkeys and CTOmodule._actionHotkeys.map then
    for k, rec in pairs(CTOmodule._actionHotkeys.map) do
      if rec and rec.action then
        out[#out + 1] = { key = tostring(k), action = tostring(rec.action) }
      end
    end
  end
  table.sort(out, function(a, b) return a.key < b.key end)
  return out
end

local function collectConnectionState()
  local out = {}
  if g_game then
    local _, online = safeCall(g_game.isOnline, g_game)
    local _, ping = safeCall(g_game.getPing, g_game)
    out.online = online
    out.ping = ping
  end
  return out
end

local function collectPlayerState(privacy)
  if privacy then return {} end
  local out = {}
  if g_game and type(g_game.getLocalPlayer) == 'function' then
    local ok, player = safeCall(g_game.getLocalPlayer, g_game)
    if ok and player then
      local _, name = safeCall(player.getName, player)
      out.name = name
    end
  end
  return out
end

function M.scan()
  local privacy = M.config.privacyMode
  local root = getRootWidgetSafeLocal()
  local data = {
    version = 1,
    timestampUtc = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    privacyMode = privacy and true or false,
    ui = {
      widgets = collectWidgetTree(root, privacy),
      windows = collectWindowList(root, privacy),
    },
    hotkeys = collectHotkeys(),
    connection = collectConnectionState(),
    player = collectPlayerState(privacy),
  }
  return data
end

function M.write(data)
  if M.config.dryRun then
    log('dry-run enabled, skipping write')
    return true
  end

  local serialized = 'return ' .. serializeLua(data, 0) .. '\n'
  local hash = checksum32(serialized)

  if M.config.dedupe and M.state.lastHash == hash then
    return true
  end

  local path = M.config.outputPath
  local maxSize = tonumber(M.config.maxFileSize or 0) or 0
  if maxSize > 0 and fileSizeSafe(path) > maxSize then
    rotateFiles(path, M.config.retention)
  end

  local ok = writeFileSafe(path, serialized)
  if ok then
    M.state.lastHash = hash
    M.state.lastWriteAt = os.time()
  end
  return ok
end

function M.tick()
  if not M.state.running then return end
  local data = M.scan()
  M.write(data)
  M.state.event = schedule(M.tick, tonumber(M.config.intervalMs) or 1000)
end

function M.start(opts)
  if M.state.running then return true end
  if type(opts) == 'table' then
    for k, v in pairs(opts) do M.config[k] = v end
  end
  if not M.config.enabled then
    log('collector disabled (config.enabled=false)')
    return false
  end
  M.state.running = true
  log('started')
  M.state.event = schedule(M.tick, 0)
  return true
end

function M.stop()
  if not M.state.running then return end
  M.state.running = false
  cancelEvent(M.state.event)
  M.state.event = nil
  log('stopped')
end

function M.selfTest()
  local data = M.scan()
  if type(data) ~= 'table' then return false end
  local ok = M.write(data)
  return ok and true or false
end

log('collector loaded')
