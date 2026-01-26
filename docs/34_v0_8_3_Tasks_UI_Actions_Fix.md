# v0.8.3 — Fix Tasks UI actions nil (forward declarations)

## Problem
Actions failed:
- `tasks_ui_next` -> `tasksUiNext` nil
- `tasks_ui_toggle` -> `tasksUiToggleSelected` nil
- `tasks_ui_run_once` -> `tasksUiRunOnceSelected` nil

## Cause
The UI helper functions were defined later as `local function ...`, so they were not in scope
when `registerDefaultActions()` created the action callbacks (Lua resolves them as globals -> nil).

## Fix
- Add forward declarations near the top:
  `local tasksUiRefresh, tasksUiNext, ...`
- Convert later `local function ...` definitions to assignments:
  `tasksUiNext = function(...) ... end`

## Test
```lua
dofile('modules/CTOmodule/init.lua') init()
CTOmodule.toggle()
CTOmodule.actions.run('tasks_ui_next')
CTOmodule.actions.run('tasks_ui_toggle')
CTOmodule.actions.run('tasks_ui_run_once')
```
