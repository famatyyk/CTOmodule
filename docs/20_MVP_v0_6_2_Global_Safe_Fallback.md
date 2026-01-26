# MVP v0.6.2 — Hotkeys fix (global safe fallback)

## Problem
Calling action hotkey APIs raised:
`attempt to call global 'safe' (a nil value)`

## Cause
Some hotkey-related functions compiled `safe()` as a global due to lexical ordering.

## Fix
Add a global fallback `safe(fn, ...)` wrapper (pcall-based).

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1', 'tick_start')
CTOmodule.bindActionHotkey('Ctrl+Alt+2', 'tick_stop')
CTOmodule.actions.run('print_state')
```
