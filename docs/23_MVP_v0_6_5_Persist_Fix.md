# MVP v0.6.5 — Persist hotkeys fix (settings method-call compatibility)

## Problem
After binding action hotkeys, `CTOmodule.reload()` shows:
`action hotkeys: (none)`.

## Cause
On some OTClient builds, `g_settings` uses method-call style and requires `self`:
- `g_settings:set(key, value)` instead of `g_settings.set(key, value)`

Earlier fallback `settingsSet/settingsGet*` only tried dot-call and silently failed, so mappings were never persisted.

## Fix
Robust global fallbacks that try both:
- dot-call
- colon-call (self)

## Debug
Action:
```lua
CTOmodule.actions.run('print_hotkey_store')
```

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1','tick_start')
CTOmodule.actions.run('print_hotkey_store')
CTOmodule.reload()
CTOmodule.listActionHotkeys()
```
