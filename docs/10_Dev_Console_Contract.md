# CTOmodule — Dev Console Contract (Reload + Hard Reload)

This patch makes the dev console workflow stable and repeatable:

```lua
dofile('modules/CTOmodule/init.lua')
init()
CTOmodule.log('hello')
CTOmodule.reload()
CTOmodule.reloadHard()
```

## What changed
- `init.lua` now returns `CTOmodule` (optional convenience)
- `CTOmodule.init()` is idempotent: if already initialized, it cleans up first
- `CTOmodule.reload()` = soft reload (recreate UI/binds/config)
- `CTOmodule.reloadHard()` = hard reload (re-dofile `module.lua`, then init)
- UI adds **Hard** button if you overwrite `ui/main.otui`
