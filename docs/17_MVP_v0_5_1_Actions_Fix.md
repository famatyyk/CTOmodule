# MVP v0.5.1 — Actions fix

## Problem
`CTOmodule.actions.run('...')` returned "action not found" and `actions ready:` was empty.

## Cause
Default actions were not guaranteed to be registered during init/reload on some code paths.

## Fix
- Register default actions:
  - once at file load (preload)
  - once again inside `CTOmodule.init()` (safe override)

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.actions.run('print_state')
CTOmodule.actions.run('tick_start')
CTOmodule.actions.run('tick_stop')
CTOmodule.actions.run('reset_window')
```
