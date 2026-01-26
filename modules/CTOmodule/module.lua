-- modules/CTOmodule/module.lua
CTOmodule = CTOmodule or {}

local MODULE_NAME = 'CTOmodule'
local HOTKEY = 'Ctrl+Shift+C'

local rootWidget = nil
local window = nil
local hotkeyFn = nil

-- keep log across reloads
CTOmodule._log = CTOmodule._log or { buf = {}, max = 200 }
CTOmodule.config = CTOmodule.config or {}

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
end

function CTOmodule.reload()
  CTOmodule.log('reload requested')
  CTOmodule.terminate()
  CTOmodule.init()
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

  local btnClear = getChild('btnClear')
  if btnClear then
    btnClear.onClick = function()
      CTOmodule._log.buf = {}
      CTOmodule.log('log cleared')
    end
  end

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
  rootWidget = g_ui and g_ui.getRootWidget and g_ui.getRootWidget() or nil
  if not rootWidget then
    print('[' .. MODULE_NAME .. '] ERROR: no root widget')
    return
  end

  -- config
  local cfg = loadConfig()

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

  CTOmodule.log('loaded (hotkey: ' .. HOTKEY .. ')')
  if cfg and cfg.enabledByDefault == false then
    -- optionally start disabled
    settingsSet(MODULE_NAME .. '.enabled', false)
  end
end

function CTOmodule.terminate()
  unbindHotkey()

  if window then
    window:destroy()
    window = nil
  end

  rootWidget = nil
end
