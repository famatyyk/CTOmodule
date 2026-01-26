# MVP v0.7.2 — Fix tasks_list action

## Problem
`tasks_list` crashed:
`attempt to call field '_get' (a nil value)`

## Fix
- Add `CTOmodule.tasks._get(name)` helper (returns `tasks.map[name]`)
- `tasks_list` uses `tasks.map[name]` directly for maximum compatibility

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.actions.run('tasks_list')
CTOmodule.actions.run('tasks_enable_demo')
CTOmodule.start()
CTOmodule.reload()
CTOmodule.actions.run('tasks_list')
```
