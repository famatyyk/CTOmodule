# MVP v0.6.8 — Fix syntax in print_hotkey_store action

## Problem
`module.lua` failed to load with:
`) expected ... near 'CTOmodule'`

## Cause
`print_hotkey_store` action was injected with a broken structure:
- function closed early
- log line was outside the function
- resulting in mismatched parentheses / ends

## Fix
Rewrite the `print_hotkey_store` registration to the correct 4-line block inside `registerDefaultActions()`.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1','tick_start')
CTOmodule.actions.run('print_hotkey_store')
CTOmodule.reload()
CTOmodule.actions.run('print_hotkey_store')
CTOmodule.listActionHotkeys()
```
