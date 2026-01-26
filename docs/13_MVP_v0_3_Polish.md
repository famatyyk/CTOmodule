# MVP v0.3 — Tick loop (polish)

## Co poprawione
- Stabilne ustawianie `intervalEdit` dla buildów bez `LineEdit`:
  - `TextEdit` stosuje wartość po utracie focusu (kliknięcie poza pole) i przed Start/Toggle
- Kolejność logów: `loaded(...)` pojawia się zanim auto-start tick loop wystartuje (jeśli włączysz `tickAutoStart`)

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()

CTOmodule.setInterval(250)
CTOmodule.toggleRun()
CTOmodule.reload()
CTOmodule.reloadHard()
```
