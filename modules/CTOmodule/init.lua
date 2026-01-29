-- init.lua (fixed paths for local folder)

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
