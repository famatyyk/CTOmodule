# MVP v0.4 — Persist state + safe autostart

## Cel
1) Zapamiętaj i przywróć stan tick loop:
- `intervalMs`
- `running`

2) Zapamiętaj i przywróć stan okna:
- widoczność
- pozycja i rozmiar (jeśli OTClient build wspiera)

3) Uruchamiaj autostart/restore dopiero po pełnym `init()` (UI + hotkeys + log `loaded(...)`).

## Test
```lua
dofile('modules/CTOmodule/init.lua')
init()

-- ustaw i odpal
CTOmodule.setInterval(250)
CTOmodule.start()

-- reload/hardReload nie dubluje eventów
CTOmodule.reload()
CTOmodule.reloadHard()

-- po restarcie klienta init() powinien przywrócić interval i running (jeśli było ustawione)
```

## Klucze g_settings
- `CTOmodule.intervalMs`
- `CTOmodule.running`
- `CTOmodule.win.visible`
- `CTOmodule.win.x`, `CTOmodule.win.y`
- `CTOmodule.win.w`, `CTOmodule.win.h`
