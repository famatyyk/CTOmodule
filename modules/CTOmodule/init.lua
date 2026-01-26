-- modules/CTOmodule/init.lua
-- NOTE: In OTClient, init.lua runs with the module directory as the base path.
-- So use relative paths like 'module.lua' and 'ui/main.otui'.

dofile('module.lua')

function init()
  if CTOmodule and CTOmodule.init then
    CTOmodule.init()
  end
end

function terminate()
  if CTOmodule and CTOmodule.terminate then
    CTOmodule.terminate()
  end
end
