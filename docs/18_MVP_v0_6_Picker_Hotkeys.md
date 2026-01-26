# MVP v0.6 — Action picker + Action hotkeys

## Cel
1) Picker akcji bez wpisywania nazwy:
- filter + prev/next + pick → ustawia `actionEdit`

2) Przypinanie hotkey → action:
- `Bind`: `hotkeyEdit` + `actionEdit` (lub aktualnie selected z pickera)
- `Unbind`: usuwa mapping
- `Show`: pokazuje listę mappingów w `hotkeysListBox`

## API
```lua
CTOmodule.actions.list()
CTOmodule.actions.run('print_state')

CTOmodule.bindActionHotkey('Ctrl+Alt+1', 'tick_start')
CTOmodule.unbindActionHotkey('Ctrl+Alt+1')
CTOmodule.listActionHotkeys()
```

## Persist
- `CTOmodule.actionHotkeys` (string: linie `key=action`)

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()

CTOmodule.bindActionHotkey('Ctrl+Alt+1', 'tick_start')
CTOmodule.bindActionHotkey('Ctrl+Alt+2', 'tick_stop')

-- naciśnij hotkeye w kliencie:
-- Ctrl+Alt+1 -> start tick
-- Ctrl+Alt+2 -> stop tick
```
