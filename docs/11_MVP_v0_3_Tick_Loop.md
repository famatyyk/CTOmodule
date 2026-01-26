# MVP v0.3 — Tick loop (Start/Stop) + interval

## Cel
Cykliczny tick, sterowany z UI i hotkeyem, odporny na reload/hardReload.

## Kontrakt w konsoli
```lua
dofile('modules/CTOmodule/init.lua')
init()

CTOmodule.setInterval(250)
CTOmodule.start()
CTOmodule.stop()

CTOmodule.toggleRun()
CTOmodule.reload()
CTOmodule.reloadHard()
```

## UI
- Interval (ms): `intervalEdit`
- Start / Stop / Toggle
- Status: `statusLabel`

## Hotkeys
- Toggle window: `Ctrl+Shift+C`
- Toggle tick: `Ctrl+Shift+T`

## Config
`modules/CTOmodule/config/default.lua`:
- `tickIntervalMs`
- `tickAutoStart`
- `tickLogEvery`

Optional override:
`modules/CTOmodule/config/user.lua` (nie commituj, jeśli ma być lokalny).
