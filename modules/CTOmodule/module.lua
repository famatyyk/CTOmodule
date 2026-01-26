-- modules/CTOmodule/module.lua
CTOmodule = CTOmodule or {}

local MODULE_NAME = 'CTOmodule'

-- NOTE: Some injected blocks compile `safe()` as a global (lexical ordering).
-- Provide a global fallback so calls like safe(fn, ...) never crash.
if type(safe) ~= 'function' then
  function safe(fn, ...)
    local ok, a, b, c, d, e = pcall(fn, ...)
    if ok then
      return true, a, b, c, d, e
    end
    return false, a
  end
end

-- Global fallback for getRootWidgetSafe (lexical ordering / upvalue resolution can differ across blocks).
if type(getRootWidgetSafe) ~= 'function' then
  function getRootWidgetSafe()
    if g_ui then
      local fn = g_ui.getRootWidget
      if type(fn) == 'function' then
        local ok, w = pcall(fn, g_ui)
        if ok and w then return w end
        ok, w = pcall(fn)
        if ok and w then return w end
      end
    end
    return rootWidget
  end
end

-- Global fallbacks for settings helpers in case some blocks resolve them as globals.
-- Also supports both function-call and method-call styles (dot vs colon).
if type(settingsSet) ~= 'function' then
  function settingsSet(key, value)
    if not g_settings then return end

    local function trySet(fnName)
      local fn = g_settings[fnName]
      if type(fn) ~= 'function' then return false end
      -- try dot-call
      local ok = pcall(fn, key, value)
      if ok then return true end
      -- try colon-call
      ok = pcall(function() return g_settings[fnName](g_settings, key, value) end)
      return ok and true or false
    end

    if trySet('set') then return end
    if trySet('setValue') then return end
    if trySet('setString') then return end
    if trySet('setNumber') then return end
    if trySet('setBoolean') then return end
  end
end

if type(settingsGetBool) ~= 'function' then
  function settingsGetBool(key, default)
    if not g_settings then return default end

    local function tryGet(fnName)
      local fn = g_settings[fnName]
      if type(fn) ~= 'function' then return nil end
      local ok, v = pcall(fn, key)
      if ok then return v end
      ok, v = pcall(function() return g_settings[fnName](g_settings, key) end)
      if ok then return v end
      return nil
    end

    local v = tryGet('getBoolean')
    if type(v) == 'boolean' then return v end

    v = tryGet('get')
    if v ~= nil then
      if type(v) == 'boolean' then return v end
      if v == 'true' or v == '1' or v == 1 then return true end
      if v == 'false' or v == '0' or v == 0 then return false end
    end

    return default
  end
end

if type(settingsGetNumber) ~= 'function' then
  function settingsGetNumber(key, default)
    if not g_settings then return default end

    local function tryGet(fnName)
      local fn = g_settings[fnName]
      if type(fn) ~= 'function' then return nil end
      local ok, v = pcall(fn, key)
      if ok then return v end
      ok, v = pcall(function() return g_settings[fnName](g_settings, key) end)
      if ok then return v end
      return nil
    end

    local v = tryGet('getNumber')
    if type(v) == 'number' then return v end

    v = tryGet('get')
    if v ~= nil then
      local n = tonumber(v)
      if n ~= nil then return n end
    end

    return default
  end
end

if type(settingsGetString) ~= 'function' then
  function settingsGetString(key, default)
    if not g_settings then return default end

    local function tryGet(fnName)
      local fn = g_settings[fnName]
      if type(fn) ~= 'function' then return nil end
      local ok, v = pcall(fn, key)
      if ok then return v end
      ok, v = pcall(function() return g_settings[fnName](g_settings, key) end)
      if ok then return v end
      return nil
    end

    local v = tryGet('getString')
    if v ~= nil then return tostring(v) end

    v = tryGet('get')
    if v ~= nil then return tostring(v) end

    return default
  end
end

    
local HOTKEY = 'Ctrl+Shift+C'
local TICK_HOTKEY = 'Ctrl+Shift+T'
local RESET_HOTKEY = 'Ctrl+Shift+O'

local rootWidget = nil
local window = nil
local hotkeyFn = nil
local tickHotkeyFn = nil
local resetHotkeyFn = nil

-- keep log across reloads
CTOmodule._log = CTOmodule._log or { buf = {}, max = 200 }
CTOmodule.config = CTOmodule.config or {}

CTOmodule.actions = CTOmodule.actions or { map = {}, order = {} }

local function actionsEnsureOrder(name)
  local order = CTOmodule.actions.order
  for i = 1, #order do
    if order[i] == name then return end
  end
  order[#order + 1] = name
end

function CTOmodule.actions.register(name, fn, opts)
  name = tostring(name or ''):gsub('%s+', '_')
  if name == '' then return false, 'empty name' end
  if type(fn) ~= 'function' then return false, 'fn must be function' end

  opts = opts or {}
  if CTOmodule.actions.map[name] ~= nil and not opts.override then
    return false, 'already registered'
  end

  CTOmodule.actions.map[name] = { fn = fn, opts = opts }
  actionsEnsureOrder(name)
  return true
end

function CTOmodule.actions.list()
  local out = {}
  for i = 1, #CTOmodule.actions.order do
    out[#out + 1] = CTOmodule.actions.order[i]
  end
  return out
end

function CTOmodule.actions.run(name, ctx)
  name = tostring(name or ''):gsub('%s+', '_')
  local a = CTOmodule.actions.map[name]
  if not a then
    CTOmodule.log('action not found: ' .. name)
    return false
  end

  local ok, err = pcall(a.fn, ctx or {})
  if not ok then
    CTOmodule.log('action error: ' .. name .. ' -> ' .. tostring(err))
    return false
  end
  return true
end

local function saveActionHotkeys()
  local lines = {}
  for k, rec in pairs(CTOmodule._actionHotkeys.map) do
    if rec and rec.action then
      lines[#lines + 1] = tostring(k) .. '=' .. tostring(rec.action)
    end
  end
  table.sort(lines)
  settingsSet(MODULE_NAME .. '.actionHotkeys', table.concat(lines, '\n'))
end

local function unbindActionHotkeyInternal(key, silent, dontSave)
  if not normalizeKeyCombo then
    -- defensive fallback (should not happen)
    normalizeKeyCombo = function(k) return tostring(k or ''):gsub('%s+', '') end
  end
  key = normalizeKeyCombo(key)
  if key == '' then return false end
  local rec = CTOmodule._actionHotkeys.map[key]
  if not rec then return false end

  local rw = rec.widget or getRootWidgetSafe()
  if g_keyboard then
    if type(g_keyboard.unbindKeyDown) == 'function' then
      safe(g_keyboard.unbindKeyDown, key, rec.fn, rw)
    elseif type(g_keyboard.unbindKeyPress) == 'function' then
      safe(g_keyboard.unbindKeyPress, key, rec.fn, rw)
    end
  end

  CTOmodule._actionHotkeys.map[key] = nil

  if not dontSave then
    saveActionHotkeys()
  end
  if not silent then
    CTOmodule.log('unbound action hotkey: ' .. key)
  end
  return true
end

local function bindActionHotkeyInternal(key, actionName, silent, dontSave)
  if not normalizeKeyCombo then
    -- defensive fallback (should not happen)
    normalizeKeyCombo = function(k) return tostring(k or ''):gsub('%s+', '') end
  end
  key = normalizeKeyCombo(key)
  actionName = tostring(actionName or ''):gsub('%s+', '_')
  if key == '' or actionName == '' then return false, 'empty key/action' end

  -- replace existing
  unbindActionHotkeyInternal(key, true, true)

  local fn = function()
    CTOmodule.actions.run(actionName)
  end

  local rw = getRootWidgetSafe()
  CTOmodule._actionHotkeys.map[key] = { action = actionName, fn = fn, widget = rw }

  if g_keyboard then
    if type(g_keyboard.bindKeyDown) == 'function' then
      safe(g_keyboard.bindKeyDown, key, fn, rw)
    elseif type(g_keyboard.bindKeyPress) == 'function' then
      safe(g_keyboard.bindKeyPress, key, fn, rw)
    end
  end

  if not dontSave then
    saveActionHotkeys()
  end
  if not silent then
    CTOmodule.log('bound action hotkey: ' .. key .. ' -> ' .. actionName)
  end
  return true
end

local function loadActionHotkeys()
  -- expects rootWidget and g_keyboard to be ready
  local raw = settingsGetString(MODULE_NAME .. '.actionHotkeys', '')
  for line in raw:gmatch('[^\r\n]+') do
    local k, a = line:match('^([^=]+)=(.+)$')
    if k and a then
      bindActionHotkeyInternal(k, a, true, true)
    end
  end

  -- canonicalize stored format
  saveActionHotkeys()
end

function CTOmodule.bindActionHotkey(keyCombo, actionName)
  return bindActionHotkeyInternal(keyCombo, actionName, false, false)
end

function CTOmodule.unbindActionHotkey(keyCombo)
  return unbindActionHotkeyInternal(keyCombo, false, false)
end

function CTOmodule.listActionHotkeys()
  local lines = {}
  for k, rec in pairs(CTOmodule._actionHotkeys.map) do
    if rec and rec.action then
      lines[#lines + 1] = tostring(k) .. ' -> ' .. tostring(rec.action)
    end
  end
  table.sort(lines)
  return lines
end

function CTOmodule.unbindAllActionHotkeys(dontSave)
  local keys = {}
  for k, _ in pairs(CTOmodule._actionHotkeys.map) do keys[#keys + 1] = k end
  table.sort(keys)
  for i = 1, #keys do
    -- runtime-only unbind; do NOT overwrite persisted settings on reload
    unbindActionHotkeyInternal(keys[i], true, true)
  end
  if not dontSave then
    saveActionHotkeys()
  end
end


CTOmodule._tick = CTOmodule._tick or { running = false, intervalMs = 500, event = nil, tickCount = 0 }

CTOmodule._actionHotkeys = CTOmodule._actionHotkeys or { map = {} }
CTOmodule._actionsUi = CTOmodule._actionsUi or { filter = '', idx = 1, list = {} }


local function safe(tfn, ...)
  local ok, res = pcall(tfn, ...)
  if ok then return true, res end
  return false, res
end

local function settingsGetBool(key, default)
  if not g_settings then return default end

  if type(g_settings.getBoolean) == 'function' then
    local ok, v = safe(g_settings.getBoolean, key)
    if ok and type(v) == 'boolean' then return v end
  end

  if type(g_settings.get) == 'function' then
    local ok, v = safe(g_settings.get, key)
    if ok then
      if v == nil then return default end
      if type(v) == 'boolean' then return v end
      local s = tostring(v):lower()
      if s == 'true' or s == '1' or s == 'yes' then return true end
      if s == 'false' or s == '0' or s == 'no' then return false end
    end
  end

  return default
end

local function settingsGetNumber(key, default)
  if not g_settings then return default end

  if type(g_settings.getNumber) == 'function' then
    local ok, v = safe(g_settings.getNumber, key)
    if ok and type(v) == 'number' then return v end
  end

  if type(g_settings.get) == 'function' then
    local ok, v = safe(g_settings.get, key)
    if ok then
      local n = tonumber(v)
      if n ~= nil then return n end
    end
  end

  return default
end

local function settingsSet(key, value)
  if not g_settings then return end
  if type(g_settings.set) == 'function' then safe(g_settings.set, key, value); return end
  if type(g_settings.setBoolean) == 'function' then safe(g_settings.setBoolean, key, value); return end
end

local function getChild(id)
  if not window then return nil end
  if type(window.recursiveGetChildById) == 'function' then
    return window:recursiveGetChildById(id)
  end
  return window:getChildById(id)
end

local function uiSetText(widget, text)
  if not widget then return end
  if type(widget.setText) == 'function' then widget:setText(text); return end
end

local function getWidgetText(w)
  if not w then return '' end
  if w.getText then
    local ok, v = safe(function() return w:getText() end)
    if ok and v ~= nil then return tostring(v) end
  end
  if w.getPlainText then
    local ok, v = safe(function() return w:getPlainText() end)
    if ok and v ~= nil then return tostring(v) end
  end
  if w.getDisplayedText then
    local ok, v = safe(function() return w:getDisplayedText() end)
    if ok and v ~= nil then return tostring(v) end
  end
  return ''
end

local function saveWindowState()
  if not window then return end
  -- visible
  local vis = false
  if window.isVisible then
    local ok, v = safe(function() return window:isVisible() end)
    if ok then vis = v and true or false end
  end
  settingsSet(MODULE_NAME .. '.win.visible', vis)

  -- position
  if window.getPosition then
    local ok, p = safe(function() return window:getPosition() end)
    if ok and type(p) == 'table' then
      local x = tonumber(p.x or p[1])
      local y = tonumber(p.y or p[2])
      if x then settingsSet(MODULE_NAME .. '.win.x', x) end
      if y then settingsSet(MODULE_NAME .. '.win.y', y) end
    end
  end

  -- size
  if window.getSize then
    local ok, s = safe(function() return window:getSize() end)
    if ok and type(s) == 'table' then
      local w = tonumber(s.width or s.w or s[1])
      local h = tonumber(s.height or s.h or s[2])
      if w then settingsSet(MODULE_NAME .. '.win.w', w) end
      if h then settingsSet(MODULE_NAME .. '.win.h', h) end
    end
  end
end

local function applyWindowDefaults()
  -- Conservative defaults that should be on-screen in most setups.
  local x, y, w, h = 80, 80, 520, 330
  settingsSet(MODULE_NAME .. '.win.x', x)
  settingsSet(MODULE_NAME .. '.win.y', y)
  settingsSet(MODULE_NAME .. '.win.w', w)
  settingsSet(MODULE_NAME .. '.win.h', h)
  settingsSet(MODULE_NAME .. '.win.visible', true)

  if window then
    if window.setPosition then
      safe(function() window:setPosition({x = x, y = y}) end)
    else
      if window.setX then safe(function() window:setX(x) end) end
      if window.setY then safe(function() window:setY(y) end) end
    end

    if window.setSize then
      safe(function() window:setSize({width = w, height = h}) end)
    elseif window.resize then
      safe(function() window:resize({width = w, height = h}) end)
    end

    if window.show then safe(function() window:show() end) end
    if window.raise then safe(function() window:raise() end) end
    if window.focus then safe(function() window:focus() end) end
  end
end

local function restoreWindowState()
  if not window then return end

  -- If the stored geometry is garbage/off-screen, ignore it.
  local x = settingsGetNumber(MODULE_NAME .. '.win.x', nil)
  local y = settingsGetNumber(MODULE_NAME .. '.win.y', nil)
  local w = settingsGetNumber(MODULE_NAME .. '.win.w', nil)
  local h = settingsGetNumber(MODULE_NAME .. '.win.h', nil)

  local function sane(n, minv, maxv)
    if n == nil then return false end
    if type(n) ~= 'number' then n = tonumber(n) end
    if n == nil then return false end
    if n < minv or n > maxv then return false end
    return true
  end

  local hasPos = sane(x, -2000, 20000) and sane(y, -2000, 20000)
  local hasSize = sane(w, 200, 6000) and sane(h, 200, 6000)

  if hasPos then
    if window.setPosition then
      safe(function() window:setPosition({x = x, y = y}) end)
    else
      if window.setX then safe(function() window:setX(x) end) end
      if window.setY then safe(function() window:setY(y) end) end
    end
  end

  if hasSize then
    if window.setSize then
      safe(function() window:setSize({width = w, height = h}) end)
    elseif window.resize then
      safe(function() window:resize({width = w, height = h}) end)
    end
  end

  local vis = settingsGetBool(MODULE_NAME .. '.win.visible', false)
  if vis then
    if window.show then safe(function() window:show() end) end
    if window.raise then safe(function() window:raise() end) end
    if window.focus then safe(function() window:focus() end) end
  else
    if window.hide then safe(function() window:hide() end) end
  end

  -- If we had stored values but they were insane, force defaults so the user can see the window.
  if (x ~= nil or y ~= nil or w ~= nil or h ~= nil) and (not hasPos or not hasSize) then
    applyWindowDefaults()
    CTOmodule.log('window state was invalid; reset to defaults')
  end
end

local function parseInt(s, fallback)
  local n = tonumber(tostring(s or ''):match('%d+'))
  n = math.floor(tonumber(n) or (fallback or 0))
  return n
end

local function normalizeKeyCombo(key)
  key = tostring(key or '')
  key = key:gsub('%s+', '')
  return key
end

local function getRootWidgetSafe()
  if g_ui then
    if type(g_ui.getRootWidget) == 'function' then
      local ok, w = pcall(g_ui.getRootWidget, g_ui)
      if ok and w then return w end
      ok, w = pcall(g_ui.getRootWidget)
      if ok and w then return w end
    end
  end
  return rootWidget
end

local function logRender()
  local buf = CTOmodule._log.buf
  return table.concat(buf, "\n")
end

function CTOmodule.log(msg)
  msg = tostring(msg or '')
  -- always print (dev visibility)
  print('[' .. MODULE_NAME .. '] ' .. msg)

  local buf = CTOmodule._log.buf
  buf[#buf + 1] = msg
  local max = CTOmodule._log.max or 200
  while #buf > max do
    table.remove(buf, 1)
  end

  -- update UI if present
  local logBox = getChild('logBox')
  if logBox then
    uiSetText(logBox, logRender())
    if type(logBox.moveCursorToEnd) == 'function' then
      logBox:moveCursorToEnd()
    end
  end
end

local function updateStatus()
  local statusLabel = getChild('statusLabel')
  if not statusLabel then return end
  local t = CTOmodule._tick
  local state = t.running and 'RUNNING' or 'STOPPED'
  local msg = state .. ' | interval=' .. tostring(t.intervalMs) .. 'ms | tick=' .. tostring(t.tickCount)
  uiSetText(statusLabel, msg)
end

local function restoreTickState(cfg)
  -- interval: config default -> settings override
  local defaultMs = (cfg and cfg.tickIntervalMs) or CTOmodule._tick.intervalMs or 500
  local savedMs = settingsGetNumber(MODULE_NAME .. '.intervalMs', defaultMs)
  CTOmodule._tick.intervalMs = savedMs
  local intervalEdit = getChild('intervalEdit')
  if intervalEdit and intervalEdit.setText then intervalEdit:setText(tostring(savedMs)) end

  -- running: settings -> optional forced autostart
  local shouldRun = settingsGetBool(MODULE_NAME .. '.running', false)
  if cfg and cfg.tickAutoStart == true then
    shouldRun = true
  end

  updateStatus()

  if shouldRun then
    CTOmodule.start()
  end
end

local function stopTick()
  local t = CTOmodule._tick
  t.running = false
  if t.event and removeEvent then
    safe(removeEvent, t.event)
  end
  t.event = nil
  updateStatus()
end

local function tickStep()
  local t = CTOmodule._tick
  if not t.running then return end

  t.tickCount = (t.tickCount or 0) + 1
  updateStatus()

  -- Optional periodic log (avoid spamming)
  local every = CTOmodule.config and CTOmodule.config.tickLogEvery or 0
  if every and every > 0 and (t.tickCount % every == 0) then
    CTOmodule.log('tick #' .. tostring(t.tickCount))
  end

  if scheduleEvent then
    local ok, ev = safe(scheduleEvent, tickStep, t.intervalMs)
    if ok then t.event = ev end
  end
end

function CTOmodule.setInterval(ms)
  local t = CTOmodule._tick
  ms = parseInt(ms, t.intervalMs)
  if ms < 50 then ms = 50 end
  if ms > 60000 then ms = 60000 end
  t.intervalMs = ms
  settingsSet(MODULE_NAME .. '.intervalMs', ms)
  updateStatus()
end

function CTOmodule.start()
  local t = CTOmodule._tick
  if t.running then
    updateStatus()
    return
  end
  t.running = true
  settingsSet(MODULE_NAME .. '.running', true)
  CTOmodule.log('tick loop started (' .. tostring(t.intervalMs) .. 'ms)')
  tickStep()
end

function CTOmodule.stop()
  local t = CTOmodule._tick
  if not t.running then
    updateStatus()
    return
  end
  stopTick()
  settingsSet(MODULE_NAME .. '.running', false)
  CTOmodule.log('tick loop stopped')
end

function CTOmodule.toggleRun()
  local t = CTOmodule._tick
  if t.running then
    CTOmodule.stop()
  else
    CTOmodule.start()
  end
end
local function mergeInto(dst, src)
  if type(dst) ~= 'table' or type(src) ~= 'table' then return dst end
  for k, v in pairs(src) do
    if type(v) == 'table' and type(dst[k]) == 'table' then
      mergeInto(dst[k], v)
    else
      dst[k] = v
    end
  end
  return dst
end

local function loadConfig()
  local cfg = {}

  -- default.lua is required
  local ok, defaults = safe(dofile, 'config/default.lua')
  if ok and type(defaults) == 'table' then
    mergeInto(cfg, defaults)
  end

  -- optional user.lua
  local userOk, userCfg = safe(dofile, 'config/user.lua')
  if userOk and type(userCfg) == 'table' then
    mergeInto(cfg, userCfg)
  end

  CTOmodule.config = cfg
  return cfg
end

local function unbindHotkey()
  if not (g_keyboard and hotkeyFn) then return end
  if type(g_keyboard.unbindKeyDown) == 'function' then
    safe(g_keyboard.unbindKeyDown, HOTKEY, hotkeyFn, rootWidget)
  elseif type(g_keyboard.unbindKeyPress) == 'function' then
    safe(g_keyboard.unbindKeyPress, HOTKEY, hotkeyFn, rootWidget)
  end
if tickHotkeyFn then
  if type(g_keyboard.unbindKeyDown) == 'function' then
    safe(g_keyboard.unbindKeyDown, TICK_HOTKEY, tickHotkeyFn, rootWidget)
  elseif type(g_keyboard.unbindKeyPress) == 'function' then
    safe(g_keyboard.unbindKeyPress, TICK_HOTKEY, tickHotkeyFn, rootWidget)
  end
if resetHotkeyFn then
  if type(g_keyboard.unbindKeyDown) == 'function' then
    safe(g_keyboard.unbindKeyDown, RESET_HOTKEY, resetHotkeyFn, rootWidget)
  elseif type(g_keyboard.unbindKeyPress) == 'function' then
    safe(g_keyboard.unbindKeyPress, RESET_HOTKEY, resetHotkeyFn, rootWidget)
  end
end
end
end

local function bindHotkey()
  if not (g_keyboard and rootWidget) then return end

  hotkeyFn = function()
    CTOmodule.toggle()
  end

  if type(g_keyboard.bindKeyDown) == 'function' then
    safe(g_keyboard.bindKeyDown, HOTKEY, hotkeyFn, rootWidget)
  elseif type(g_keyboard.bindKeyPress) == 'function' then
    safe(g_keyboard.bindKeyPress, HOTKEY, hotkeyFn, rootWidget)
  end

tickHotkeyFn = function()
  CTOmodule.toggleRun()

resetHotkeyFn = function()
  CTOmodule.resetWindow()
end

if type(g_keyboard.bindKeyDown) == 'function' then
  safe(g_keyboard.bindKeyDown, RESET_HOTKEY, resetHotkeyFn, rootWidget)
elseif type(g_keyboard.bindKeyPress) == 'function' then
  safe(g_keyboard.bindKeyPress, RESET_HOTKEY, resetHotkeyFn, rootWidget)
end
end

if type(g_keyboard.bindKeyDown) == 'function' then
  safe(g_keyboard.bindKeyDown, TICK_HOTKEY, tickHotkeyFn, rootWidget)
elseif type(g_keyboard.bindKeyPress) == 'function' then
  safe(g_keyboard.bindKeyPress, TICK_HOTKEY, tickHotkeyFn, rootWidget)
end
end

function CTOmodule.toggle()
  if not window then return end
  if window:isVisible() then
    window:hide()
  else
    window:show()
    if window.raise then window:raise() end
    if window.focus then window:focus() end
  end
  saveWindowState()
end

function CTOmodule.resetWindow()
  applyWindowDefaults()
  CTOmodule.log('window reset to defaults')
end

function CTOmodule.reload()
  -- Soft reload: re-create UI/binds/config without re-dofiling code.
  CTOmodule.log('reload requested')
  CTOmodule.terminate()
  CTOmodule.init()
end

function CTOmodule.reloadHard()
  -- Hard reload: re-dofile module.lua (refreshes code) then init again.
  CTOmodule.log('hard reload requested')
  CTOmodule.terminate()
  dofile('module.lua')
  if CTOmodule and CTOmodule.init then
    CTOmodule.init()
  end
end


local function registerDefaultActions()
  -- Always override so code changes propagate on hard reloads.
  CTOmodule.actions.register('toggle_window', function()
    CTOmodule.toggle()
  end, { override = true })

  CTOmodule.actions.register('reset_window', function()
    CTOmodule.resetWindow()
  end, { override = true })

  CTOmodule.actions.register('tick_start', function()
    CTOmodule.start()
  end, { override = true })

  CTOmodule.actions.register('tick_stop', function()
    CTOmodule.stop()
  end, { override = true })

  CTOmodule.actions.register('print_state', function()
    local t = CTOmodule._tick
    local running = t and t.running and true or false
    local intervalMs = t and t.intervalMs or nil
    CTOmodule.log('state: running=' .. tostring(running) .. ' intervalMs=' .. tostring(intervalMs) .. ' tickCount=' .. tostring(t and t.tickCount or 0))
  end, { override = true })
  CTOmodule.actions.register('print_hotkey_store', function()
    local raw = settingsGetString(MODULE_NAME .. '.actionHotkeys', '')
    CTOmodule.log('persisted actionHotkeys=' .. (raw ~= '' and raw or '(empty)'))
  end, { override = true })
end

-- Preload defaults so actions exist right after dofile('module.lua')
registerDefaultActions() -- preload


local function actionsUiRefresh()
  local t = CTOmodule._actionsUi
  local filter = tostring(t.filter or ''):lower()
  local all = CTOmodule.actions.list()

  local list = {}
  for i = 1, #all do
    local name = all[i]
    if filter == '' or tostring(name):lower():find(filter, 1, true) then
      list[#list + 1] = name
    end
  end

  if #list == 0 then
    t.idx = 1
  else
    if t.idx < 1 then t.idx = 1 end
    if t.idx > #list then t.idx = #list end
  end

  t.list = list

  local listBox = getChild('actionsListBox')
  if listBox and listBox.setText then
    local lines = {}
    for i = 1, #list do
      local prefix = (i == t.idx) and '> ' or '  '
      lines[#lines + 1] = prefix .. list[i]
    end
    if #lines == 0 then
      lines[1] = '(no actions)'
    end
    listBox:setText(table.concat(lines, '\n'))
  end

  local sel = (list[t.idx] or '')
  local selLabel = getChild('actionsSelectedLabel')
  if selLabel then
    uiSetText(selLabel, sel ~= '' and ('Selected: ' .. sel) or 'Selected: (none)')
  end
end

local function actionsUiSetFilter(s)
  CTOmodule._actionsUi.filter = tostring(s or '')
  CTOmodule._actionsUi.idx = 1
  actionsUiRefresh()
end

local function actionsUiNext(delta)
  local t = CTOmodule._actionsUi
  if #t.list == 0 then
    actionsUiRefresh()
    return
  end
  t.idx = (t.idx or 1) + delta
  if t.idx < 1 then t.idx = 1 end
  if t.idx > #t.list then t.idx = #t.list end
  actionsUiRefresh()
end

local function actionsUiPickToActionEdit()
  local t = CTOmodule._actionsUi
  local sel = t.list[t.idx]
  if not sel then return end
  local actionEdit = getChild('actionEdit')
  if actionEdit and actionEdit.setText then
    actionEdit:setText(sel)
  end
  settingsSet(MODULE_NAME .. '.lastAction', sel)
end

local function hotkeysUiRefresh()
  local box = getChild('hotkeysListBox')
  if not box or not box.setText then return end
  local lines = CTOmodule.listActionHotkeys()
  if #lines == 0 then
    box:setText('(no action hotkeys)')
  else
    box:setText(table.concat(lines, '\n'))
  end
end

local function wireUi()
  local enabledCheck = getChild('enabledCheck')
  if enabledCheck then
    local saved = settingsGetBool(MODULE_NAME .. '.enabled', true)
    if enabledCheck.setChecked then enabledCheck:setChecked(saved) end

    enabledCheck.onCheckChange = function(_, checked)
      settingsSet(MODULE_NAME .. '.enabled', checked and true or false)
      CTOmodule.log('enabled=' .. tostring(checked))
    end
  end

  local btnPrint = getChild('btnPrint')
  if btnPrint then
    btnPrint.onClick = function()
      CTOmodule.log('ping from UI button')
    end
  end

  local btnReload = getChild('btnReload')
  if btnReload then
    btnReload.onClick = function()
      CTOmodule.reload()
    end
  end


  local btnHardReload = getChild('btnHardReload')
  if btnHardReload then
    btnHardReload.onClick = function()
      CTOmodule.reloadHard()
    end
  end
  local btnClear = getChild('btnClear')
  if btnClear then
    btnClear.onClick = function()
      CTOmodule._log.buf = {}
      CTOmodule.log('log cleared')
    end
  end


local function applyIntervalFromUI()
  if not intervalEdit then return end
  if intervalEdit.getText then
    CTOmodule.setInterval(intervalEdit:getText())
  elseif intervalEdit.getPlainText then
    CTOmodule.setInterval(intervalEdit:getPlainText())
  end

local actionEdit = getChild('actionEdit')
if actionEdit then
  local last = nil
  if g_settings and type(g_settings.get) == 'function' then
    local ok, v = safe(g_settings.get, MODULE_NAME .. '.lastAction')
    if ok and v ~= nil then last = tostring(v) end
  end
  if last and actionEdit.setText then actionEdit:setText(last) end

local filterEdit = getChild('actionsFilterEdit')
if filterEdit then
  if filterEdit.setText then filterEdit:setText(CTOmodule._actionsUi.filter or '') end
  filterEdit.onFocusChange = function(_, focused)
    if not focused then
      actionsUiSetFilter(getWidgetText(filterEdit))
    end
  end
end

local btnApplyFilter = getChild('btnApplyFilter')
if btnApplyFilter then
  btnApplyFilter.onClick = function()
    actionsUiSetFilter(getWidgetText(filterEdit))
  end
end

local btnPrevAction = getChild('btnPrevAction')
if btnPrevAction then
  btnPrevAction.onClick = function()
    actionsUiNext(-1)
  end
end

local btnNextAction = getChild('btnNextAction')
if btnNextAction then
  btnNextAction.onClick = function()
    actionsUiNext(1)
  end
end

local btnPickAction = getChild('btnPickAction')
if btnPickAction then
  btnPickAction.onClick = function()
    actionsUiPickToActionEdit()
    actionsUiRefresh()
  end
end

actionsUiRefresh()

local hotkeyEdit = getChild('hotkeyEdit')
local btnBindHotkey = getChild('btnBindHotkey')
if btnBindHotkey then
  btnBindHotkey.onClick = function()
    local key = getWidgetText(hotkeyEdit)
    local actionName = getWidgetText(getChild('actionEdit'))
    if actionName == '' then
      -- fallback to selected
      local t = CTOmodule._actionsUi
      actionName = t.list[t.idx] or ''
    end
    if key == '' or actionName == '' then
      CTOmodule.log('bind hotkey: empty key/action')
      return
    end
    CTOmodule.bindActionHotkey(key, actionName)
    hotkeysUiRefresh()
  end
end

local btnUnbindHotkey = getChild('btnUnbindHotkey')
if btnUnbindHotkey then
  btnUnbindHotkey.onClick = function()
    local key = getWidgetText(hotkeyEdit)
    if key == '' then
      CTOmodule.log('unbind hotkey: empty key')
      return
    end
    CTOmodule.unbindActionHotkey(key)
    hotkeysUiRefresh()
  end
end

local btnListHotkeys = getChild('btnListHotkeys')
if btnListHotkeys then
  btnListHotkeys.onClick = function()
    hotkeysUiRefresh()
    local lines = CTOmodule.listActionHotkeys()
    CTOmodule.log('action hotkeys: ' .. (#lines > 0 and table.concat(lines, ', ') or '(none)'))
  end
end

hotkeysUiRefresh()

end

local function getActionName()
  local name = getWidgetText(actionEdit)
  name = tostring(name or ''):gsub('\r', ''):gsub('\n.*', ''):gsub('^%s+', ''):gsub('%s+$', '')
  if name ~= '' then
    settingsSet(MODULE_NAME .. '.lastAction', name)
  end
  return name
end

local btnRunAction = getChild('btnRunAction')
if btnRunAction then
  btnRunAction.onClick = function()
    local name = getActionName()
    if name == '' then
      CTOmodule.log('action empty')
      return
    end
    CTOmodule.actions.run(name)
  end
end

local btnListActions = getChild('btnListActions')
if btnListActions then
  btnListActions.onClick = function()
    local list = CTOmodule.actions.list()
    CTOmodule.log('actions: ' .. table.concat(list, ', '))
  end
end

end

local intervalEdit = getChild('intervalEdit')
if intervalEdit then
  -- initialize from current interval
  if intervalEdit.setText then intervalEdit:setText(tostring(CTOmodule._tick.intervalMs)) end

  -- Some builds use TextEdit without onEnter; apply on focus loss as a safe fallback.
  intervalEdit.onFocusChange = function(_, focused)
    if not focused then
      applyIntervalFromUI()
    end
  end
end

local btnStart = getChild('btnStart')
if btnStart then
  btnStart.onClick = function()
    applyIntervalFromUI()
    CTOmodule.start()
  end
end

local btnStop = getChild('btnStop')
if btnStop then
  btnStop.onClick = function()
    CTOmodule.stop()
  end
end

local btnToggleRun = getChild('btnToggleRun')
if btnToggleRun then
  btnToggleRun.onClick = function()
    applyIntervalFromUI()
    CTOmodule.toggleRun()
  end
end

updateStatus()

  -- render current log into UI
  local logBox = getChild('logBox')
  if logBox then
    uiSetText(logBox, logRender())
    if type(logBox.moveCursorToEnd) == 'function' then
      logBox:moveCursorToEnd()
    end
  end
end

function CTOmodule.init()
  rootWidget = getRootWidgetSafe()
  -- Idempotent init: if already initialized, clean up first
  if window then
    CTOmodule.terminate()
  end
  rootWidget = g_ui and g_ui.getRootWidget and g_ui.getRootWidget() or nil
  if not rootWidget then
    print('[' .. MODULE_NAME .. '] ERROR: no root widget')
    return
  end

  -- config
  local cfg = loadConfig()

-- apply config defaults
if cfg and cfg.logMaxLines then
  CTOmodule._log.max = cfg.logMaxLines
end
if cfg and cfg.tickIntervalMs then
  CTOmodule._tick.intervalMs = cfg.tickIntervalMs
end

  -- UI (module-relative path)
  window = g_ui.loadUI('ui/main.otui', rootWidget)
  if not window then
    print('[' .. MODULE_NAME .. '] ERROR: failed to load UI: ui/main.otui')
    return
  end

  window:hide()

  wireUi()
  loadActionHotkeys()
  hotkeysUiRefresh()
  local _hk2 = CTOmodule.listActionHotkeys(); CTOmodule.log('action hotkeys loaded: ' .. (#_hk2 > 0 and table.concat(_hk2, ', ') or '(none)'))

  -- hotkey (avoid duplicates)
  unbindHotkey()
  bindHotkey()


  -- ensure default actions are registered (safe on reload/hardReload)
  if registerDefaultActions then
    registerDefaultActions()
  end
CTOmodule.log('loaded (hotkey: ' .. HOTKEY .. ', tick: ' .. TICK_HOTKEY .. ', resetWin: ' .. RESET_HOTKEY .. ')')
  local _alist = CTOmodule.actions.list(); CTOmodule.log('actions ready: ' .. (#_alist > 0 and table.concat(_alist, ', ') or '(none)'))

-- restore persisted window + tick state only after UI and binds are ready
restoreWindowState()
restoreTickState(cfg)

if cfg and cfg.enabledByDefault == false then
  settingsSet(MODULE_NAME .. '.enabled', false)
end
end

function CTOmodule.terminate()
  unbindHotkey()
  stopTick()
  CTOmodule.unbindAllActionHotkeys(true)

  saveWindowState()

  if window then
    window:destroy()
    window = nil
  end

  rootWidget = nil
end
