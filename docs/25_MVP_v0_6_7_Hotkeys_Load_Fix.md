# MVP v0.6.7 — Hotkeys load after reload + robust getString

## Problem
`persisted actionHotkeys=Ctrl+Alt+1=tick_start`, but after `CTOmodule.reload()` log showed `(none)`.

## Root cause (2 parts)
1) `loadActionHotkeys()` read `g_settings.get` directly; on some builds it may require `self` or return types inconsistently.
2) The "action hotkeys: ..." log was printed before `loadActionHotkeys()` ran, so it could display `(none)` even if bindings loaded later.

## Fix
- Add global `settingsGetString()` fallback that supports dot/colon calls.
- `loadActionHotkeys()` now uses `settingsGetString(...)`.
- Log `action hotkeys loaded:` is printed **after** loading.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1','tick_start')
CTOmodule.reload()
CTOmodule.actions.run('print_hotkey_store')
-- check log: action hotkeys loaded: Ctrl+Alt+1 -> tick_start
```
