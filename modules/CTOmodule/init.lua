-- init.lua (fixed paths for local folder)

dofile('module.lua')
<<<<<<< Updated upstream

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
=======
pcall(dofile, 'patches/v0_9_1_apply.lua')
pcall(dofile, 'patches/v0_9_2_editor_apply_ui.lua')
pcall(dofile, 'patches/v0_9_3_editor_ui_edit.lua')
>>>>>>> Stashed changes
