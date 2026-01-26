# MVP v0.7.1 — Task system fixes

## Fixes
1) `tasks_list` output:
- stable per-task lines
- no duplicated persisted flags
- includes priority and interval

2) `tasks_enable_demo`:
- enables all registered tasks deterministically
- single summary log

3) Tick loop:
- `startTick()` is idempotent (prevents duplicate start logs/timers)

4) Tasks persistence:
- de-dup + sort enabled list before saving

5) Debug action:
- `print_tasks_store` prints the raw persisted `tasksEnabled`.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.actions.run('tasks_list')
CTOmodule.actions.run('tasks_enable_demo')
CTOmodule.start()
CTOmodule.reload()
CTOmodule.actions.run('tasks_list')
CTOmodule.actions.run('print_tasks_store')
```
