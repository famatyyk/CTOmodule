# DESIGN notes (v0.2)
- Always use module-relative paths:
  - dofile('module.lua')
  - g_ui.loadUI('ui/main.otui', parent)
- Avoid duplicated hotkey binds (unbind before bind where supported)
- Keep log buffer across reloads; UI is reloaded safely
