# v0.4.1 — Window not visible fix (off-screen/invalid geometry)

## Symptom
Window exists (module logs `loaded(...)`), but the UI is not visible.

## Cause
Persisted `CTOmodule.win.x/y/w/h` can become invalid (off-screen / wrong values) on some OTClient builds.

## Fix
- Clamp restored geometry; if invalid → reset to conservative defaults.
- Add API + hotkey to force reset:

Console:
```lua
CTOmodule.resetWindow()
```

Hotkey:
- `Ctrl+Shift+O` = reset window to defaults and show it
