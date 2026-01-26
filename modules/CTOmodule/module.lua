-- modules/CTOmodule/module.lua
CTOmodule = CTOmodule or {}

local MODULE_NAME = 'CTOmodule'
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

CTOmodule._tick = CTOmodule._tick or { running = false, intervalMs = 500, event = nil, tickCount = 0 }


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

  -- hotkey (avoid duplicates)
  unbindHotkey()
  bindHotkey()

CTOmodule.log('loaded (hotkey: ' .. HOTKEY .. ', tick: ' .. TICK_HOTKEY .. ', resetWin: ' .. RESET_HOTKEY .. ')')

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

  saveWindowState()

  if window then
    window:destroy()
    window = nil
  end

  rootWidget = nil
end
