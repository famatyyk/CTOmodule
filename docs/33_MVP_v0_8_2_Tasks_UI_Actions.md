# MVP v0.8.2 — Tasks UI wiring + console actions

## Additions
- Tasks UI is now controllable from console via actions:
  - `tasks_ui_refresh`
  - `tasks_ui_prev`
  - `tasks_ui_next`
  - `tasks_ui_toggle`
  - `tasks_ui_run_once`
  - `tasks_ui_set_interval`
  - `tasks_ui_set_priority`

## UX
- `CTOmodule.toggle()` now refreshes Tasks UI after showing the window.

## Example
```lua
dofile('modules/CTOmodule/init.lua') init()
CTOmodule.toggle() -- open window, refresh list

CTOmodule.actions.run('tasks_ui_next')
CTOmodule.actions.run('tasks_ui_toggle')
CTOmodule.actions.run('tasks_ui_run_once')
```
