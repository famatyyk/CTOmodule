# MVP v0.6.3 — Hotkeys fix (global settings helpers)

## Problem
`CTOmodule.bindActionHotkey(...)` raised:
`attempt to call global 'settingsSet' (a nil value)`

## Fix
Provide global fallbacks:
- `settingsSet`
- `settingsGetBool`
- `settingsGetNumber`

These call `g_settings` safely via `pcall`.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1', 'tick_start')
CTOmodule.bindActionHotkey('Ctrl+Alt+2', 'tick_stop')
CTOmodule.actions.run('print_state')
```
