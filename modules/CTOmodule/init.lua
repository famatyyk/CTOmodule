-- modules/CTOmodule/init.lua
-- Module-relative paths only (OTClient executes init.lua with module dir as base).

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
