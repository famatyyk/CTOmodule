-- init.lua (fixed paths for local folder)

dofile('module.lua')
copilot/fix-issue-to-make-it-work
pcall(dofile, 'collector.lua')
pcall(dofile, 'builder.lua')
Updated upstream
main

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
