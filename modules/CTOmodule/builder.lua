-- builder.lua
-- Module builder using collector output (safe, opt-in)

CTOmodule = CTOmodule or {}
CTOmodule.builder = CTOmodule.builder or {}

local M = CTOmodule.builder

M.config = M.config or {
  enabled = true,
  inputPath = 'config/collector_output.lua',
}

M.state = M.state or {
  data = nil,
  window = nil,
}

local function log(msg)
  if CTOmodule and CTOmodule.log then
    CTOmodule.log('[builder] ' .. tostring(msg))
  else
    print('[builder] ' .. tostring(msg))
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

local function parseLuaData(content)
  if type(content) ~= 'string' or content == '' then
    return nil, 'empty content'
  end
  local chunk, err = loadstring(content)
  if not chunk then
    return nil, err
  end
  setfenv(chunk, {})
  local ok, data = pcall(chunk)
  if not ok then
    return nil, data
  end
  if type(data) ~= 'table' then
    return nil, 'data is not table'
  end
  return data, nil
end

local function destroyWindow()
  if M.state.window then
    pcall(function() M.state.window:destroy() end)
    M.state.window = nil
  end
end

local function ensureWindow()
  if M.state.window then return M.state.window end
  if not g_ui or type(g_ui.createWidget) ~= 'function' then return nil end

  local root = getRootWidgetSafeLocal()
  if not root then return nil end

  local ok, win = pcall(g_ui.createWidget, 'MainWindow', root)
  if not ok or not win then
    ok, win = pcall(g_ui.createWidget, 'Window', root)
  end
  if not ok or not win then return nil end

  pcall(function() win:setId('ctomoduleBuilderWindow') end)
  pcall(function() win:setText('CTOmodule Builder') end)
  pcall(function() win:setSize({ width = 420, height = 220 }) end)
  pcall(function() win:move({ x = 100, y = 100 }) end)

  local okLabel, label = pcall(g_ui.createWidget, 'Label', win)
  if okLabel and label then
    pcall(function() label:setId('ctomoduleBuilderLabel') end)
    pcall(function() label:setText('No data loaded') end)
    pcall(function() label:setMarginTop(10) end)
    pcall(function() label:setMarginLeft(12) end)
  end

  M.state.window = win
  return win
end

local function renderSummary(data)
  local win = ensureWindow()
  if not win then return false end

  local label
  if win.getChildById then
    local ok, child = safeCall(win.getChildById, win, 'ctomoduleBuilderLabel')
    if ok then label = child end
  end

  local widgetCount = 0
  if data and data.ui and type(data.ui.widgets) == 'table' then
    widgetCount = #data.ui.widgets
  end

  local hotkeyCount = 0
  if data and type(data.hotkeys) == 'table' then
    hotkeyCount = #data.hotkeys
  end

  local text = string.format('Loaded data v%s\nWidgets: %d\nHotkeys: %d',
    tostring(data and data.version or '?'),
    widgetCount,
    hotkeyCount
  )

  if label and label.setText then
    pcall(function() label:setText(text) end)
  end
  return true
end

function M.load()
  local content = readFileSafe(M.config.inputPath)
  if not content then
    return nil, 'file not found'
  end
  return parseLuaData(content)
end

function M.apply(data)
  M.state.data = data
  renderSummary(data)
  return true
end

function M.refresh()
  if not M.config.enabled then
    log('builder disabled (config.enabled=false)')
    return false
  end

  local data, err = M.load()
  if not data then
    log('load failed: ' .. tostring(err))
    return false
  end

  M.apply(data)
  log('loaded data')
  return true
end

function M.selfTest()
  local data, err = M.load()
  if not data then
    log('selfTest load failed: ' .. tostring(err))
    return false
  end
  return M.apply(data)
end

function M.hide()
  destroyWindow()
end

log('builder loaded')
