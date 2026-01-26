-- modules/CTOmodule/module.lua
CTOmodule = CTOmodule or {}

local MODULE_NAME = 'CTOmodule'
local rootWidget = nil
local window = nil

local function settingsGetBool(key, default)
  if not g_settings then return default end

  if type(g_settings.getBoolean) == 'function' then
    local ok, v = pcall(g_settings.getBoolean, key)
    if ok and type(v) == 'boolean' then return v end
  end

  if type(g_settings.get) == 'function' then
    local ok, v = pcall(g_settings.get, key)
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
  if type(g_settings.set) == 'function' then pcall(g_settings.set, key, value); return end
  if type(g_settings.setBoolean) == 'function' then pcall(g_settings.setBoolean, key, value); return end
end

local function getChild(id)
  if not window then return nil end
  if type(window.recursiveGetChildById) == 'function' then
    return window:recursiveGetChildById(id)
  end
  return window:getChildById(id)
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

function CTOmodule.init()
  rootWidget = g_ui and g_ui.getRootWidget and g_ui.getRootWidget() or nil
  if not rootWidget then
    print('[' .. MODULE_NAME .. '] ERROR: no root widget')
    return
  end

  -- IMPORTANT: load UI using a path relative to the module directory
  window = g_ui.loadUI('ui/main.otui', rootWidget)
  if not window then
    print('[' .. MODULE_NAME .. '] ERROR: failed to load UI: ui/main.otui')
    return
  end

  window:hide()

  -- Wire UI events
  local enabledCheck = getChild('enabledCheck')
  if enabledCheck then
    local saved = settingsGetBool(MODULE_NAME .. '.enabled', true)
    if enabledCheck.setChecked then enabledCheck:setChecked(saved) end

    enabledCheck.onCheckChange = function(_, checked)
      settingsSet(MODULE_NAME .. '.enabled', checked and true or false)
      print('[' .. MODULE_NAME .. '] enabled=' .. tostring(checked))
    end
  end

  local btnPrint = getChild('btnPrint')
  if btnPrint then
    btnPrint.onClick = function()
      print('[' .. MODULE_NAME .. '] ping from UI button')
    end
  end

  -- Hotkey toggle
  if g_keyboard and type(g_keyboard.bindKeyDown) == 'function' then
    pcall(g_keyboard.bindKeyDown, 'Ctrl+Shift+C', function() CTOmodule.toggle() end, rootWidget)
  end

  print('[' .. MODULE_NAME .. '] loaded (Ctrl+Shift+C)')
end

function CTOmodule.terminate()
  if window then
    window:destroy()
    window = nil
  end
  rootWidget = nil
  print('[' .. MODULE_NAME .. '] terminated')
end
