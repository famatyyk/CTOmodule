# MVP v0.8.4 - Tasks UI controls + mute logs + priority order (ASCII)

## Adds
- Buttons in Tasks UI: EnableAll / DisableAll / Mute / MuteAll
- Per-task mute (persisted) and global mute for task logs (persisted)
- Scheduler runs tasks by priority (DESC)

## Notes
- tasksConfig format: name=intervalMs,priority,mute
  - backward compatible with name=intervalMs,priority

## Quick test
```lua
dofile('modules/CTOmodule/init.lua'); init(); CTOmodule.toggle()
CTOmodule.actions.run('tasks_enable_demo')
CTOmodule.actions.run('tasks_list')
```
