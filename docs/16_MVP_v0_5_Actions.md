# MVP v0.5 — Actions / Commands

## Cel
Prosty system rejestrowania i uruchamiania komend (akcji), żeby kolejne feature'y dodawać jako pluginy/komendy.

## API
```lua
-- list
CTOmodule.actions.list()

-- run
CTOmodule.actions.run('print_state')

-- register (custom)
CTOmodule.actions.register('my_action', function(ctx)
  CTOmodule.log('hi from my_action')
end)
```

## UI
- `Action:` (pole `actionEdit`) — wpisz nazwę akcji
- `Run` — uruchamia akcję
- `List` — wypisuje dostępne akcje do loga

## Domyślne akcje
- `toggle_window`
- `reset_window`
- `tick_start`
- `tick_stop`
- `print_state`

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()

CTOmodule.actions.list()
CTOmodule.actions.run('print_state')
CTOmodule.actions.run('toggle_window')
CTOmodule.actions.run('reset_window')
```
