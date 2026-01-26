# MVP v0.6.6 — Fix syntax error in settings fallback block

## Problem
`module.lua` failed to load with:
`'<eof>' expected near 'end'`

## Cause
A duplicated fragment of an older `settingsGetNumber` implementation remained at top-level,
leaving extra `end` statements.

## Fix
Remove the stray duplicate block so the settings fallback section is valid Lua.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1','tick_start')
CTOmodule.actions.run('print_hotkey_store')
CTOmodule.reload()
CTOmodule.listActionHotkeys()
```
