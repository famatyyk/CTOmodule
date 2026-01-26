# v0.8.4.4 — OTUI fix: recursive anchor + wrong nesting

## Symptoms
- `child 'btnTasksEnableAll' ... is recursively anchored to itself`
- Crash during `g_ui.loadUI(...)`

## Causes
1) `btnTasksEnableAll` had `anchors.top: btnTasksEnableAll.bottom`
2) The rest of the Tasks UI was accidentally nested under `btnTasksMuteAll` (indentation too deep)

## Fixes
- `btnTasksEnableAll` now anchors to `tasksSelectedLabel.bottom`
- Dedent the Tasks UI tail so widgets are siblings under `ctoWindow` (single-root & correct hierarchy)

## Test
```lua
dofile('modules/CTOmodule/init.lua'); init(); CTOmodule.toggle()
```
