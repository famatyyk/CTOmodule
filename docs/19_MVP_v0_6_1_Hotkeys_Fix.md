# MVP v0.6.1 — Hotkeys fix (normalizeKeyCombo)

## Problem
Calling `CTOmodule.bindActionHotkey(...)` raised:
`attempt to call global 'normalizeKeyCombo' (a nil value)`.

## Fix
Define `normalizeKeyCombo()` in `module.lua` before hotkey binding functions.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1', 'tick_start')
CTOmodule.bindActionHotkey('Ctrl+Alt+2', 'tick_stop')
CTOmodule.actions.run('print_state')
```
