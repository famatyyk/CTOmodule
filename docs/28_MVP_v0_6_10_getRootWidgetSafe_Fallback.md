# MVP v0.6.10 — Fix getRootWidgetSafe nil (global fallback)

## Problem
`attempt to call global 'getRootWidgetSafe' (a nil value)`

## Cause
Some blocks resolved `getRootWidgetSafe` as a global due to lexical ordering; local definition wasn't visible.

## Fix
Provide a global fallback `getRootWidgetSafe()` (like `safe()` and settings helpers).

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1','tick_start')
CTOmodule.reload()
CTOmodule.listActionHotkeys()
```
