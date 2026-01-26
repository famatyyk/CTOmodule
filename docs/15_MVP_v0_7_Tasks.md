# MVP v0.7 - Task Scheduler (console-first)

This version adds a small task scheduler that runs inside the existing tick loop.

## New API

### Register a task
```lua
CTOmodule.tasks.register('my_task', function(ctx)
  -- ctx.online, ctx.hpPct, ctx.manaPct, ctx.tickCount, ctx.nowMs
  if ctx.online then
    CTOmodule.log('my_task: online tick=' .. tostring(ctx.tickCount))
  end
end, { intervalMs = 1000, priority = 0, override = true })
```

### Enable / disable
```lua
CTOmodule.tasks.enable('my_task', true)
CTOmodule.tasks.enable('my_task', false)
CTOmodule.tasks.toggle('my_task')
```

### Run once
```lua
CTOmodule.tasks.runOnce('my_task')
```

### List
```lua
print(table.concat(CTOmodule.tasks.list(), ', '))
print(table.concat(CTOmodule.tasks.listEnabled(), ', '))
```

## Persistence

Enabled tasks are persisted in settings key:
- `CTOmodule.tasksEnabled`

So after `CTOmodule.reload()` / `CTOmodule.reloadHard()` the enabled set should be restored.

## Default demo tasks

- `online_state` (interval 500ms)
- `vitals` (interval 2000ms)

Enable both:
```lua
CTOmodule.actions.run('tasks_enable_demo')
-- or:
CTOmodule.tasks.enable('online_state', true)
CTOmodule.tasks.enable('vitals', true)
```

## Actions

- `tasks_list`
- `tasks_enable_demo`
- `tasks_disable_all`

Example:
```lua
CTOmodule.actions.run('tasks_list')
```

## Notes

- Tasks execute only while tick loop is running (`CTOmodule.start()` / `CTOmodule.toggleRun()`).
- Keep tasks lightweight; they run on the main thread.
