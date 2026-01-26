# MVP v0.6.9 — Hotkeys load/bind fix (rootWidget + init order)

## Problem
`persisted actionHotkeys=Ctrl+Alt+1=tick_start` is present, but after reload no hotkeys are active.

## Root cause
Binding/unbinding used a stale or nil `rootWidget` upvalue, and `loadActionHotkeys()` could run before UI/rootWidget is ready.

## Fix
- Add `getRootWidgetSafe()` and use it in bind/unbind.
- Store `widget` per binding.
- Ensure `rootWidget` is refreshed in `init()`.
- Ensure `loadActionHotkeys()` runs after `wireUi()`.

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.bindActionHotkey('Ctrl+Alt+1','tick_start')
CTOmodule.reload()
CTOmodule.actions.run('print_hotkey_store')
CTOmodule.listActionHotkeys()
-- press Ctrl+Alt+1 to verify it triggers tick_start
```
