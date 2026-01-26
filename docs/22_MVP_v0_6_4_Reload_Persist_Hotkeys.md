# MVP v0.6.4 — Hotkeys persist across reload

## Problem
After `CTOmodule.reload()`, `action hotkeys: (none)` even though hotkeys were bound before reload.

## Cause
`CTOmodule.terminate()` called `unbindAllActionHotkeys()`, which cleared runtime mappings **and saved empty mapping** to `g_settings`, overwriting persisted `CTOmodule.actionHotkeys`.

## Fix
- `CTOmodule.unbindAllActionHotkeys(dontSave)`
- `terminate()` uses `dontSave=true` so reload/hardReload unbinds runtime keys but does **not** overwrite persisted settings.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1','tick_start')
CTOmodule.reload()
CTOmodule.listActionHotkeys() -- should contain mapping
```
