# CTOmodule - GitHub Copilot Agent Instructions

## Project Overview
**CTOmodule** is a minimal OTClient module skeleton in Lua 5.1 for creating custom Tibia client modules. Features: dev console, tick loop, action system, task scheduler with editor, hotkey bindings, settings persistence.

- **Technology**: Lua 5.1, OTUI (CSS-like UI), no build system, no automated tests
- **Size**: ~2400 lines in module.lua, ~10 docs files, 6 Lua files, 1 OTUI file
- **Testing**: Manual only - install in OTClient, press Ctrl+Shift+C to toggle window


## Build & Test

**No build system exists.** This is pure Lua interpreted by OTClient.

**Setup (Windows)**: Create junction to OTClient modules folder:
```powershell
cmd /c mklink /J "C:\Users\<USER>\AppData\Roaming\mklauncher\althea\modules\CTOmodule" "C:\dev\CTOmodule\modules\CTOmodule"
```
See `docs/08_CTOmodule_Dev_Setup.md` for details.

**Test manually**:
1. Start OTClient with module in `modules/` directory
2. Press **Ctrl+Shift+C** to toggle module window
3. Check dev console in UI for logs
4. Test changed functionality
5. Check OTClient console for Lua errors

**Manual load** (OTClient console):
```lua
dofile('modules/CTOmodule/init.lua')  -- Note: uses full path from OTClient root
init()
```


## Project Layout

**Key directories**:
- `modules/CTOmodule/` - All module code
  - `init.lua` - Entry point (⚠️ HAS MERGE CONFLICTS - DO NOT EDIT)
  - `module.lua` - Core logic ~2400 lines (⚠️ HAS MERGE CONFLICTS line 12 - DO NOT EDIT)
  - `default.lua` - Legacy config (kept for backward compatibility; use `config/default.lua`)
  - `ui/main.otui` - UI definition (⚠️ HAS MERGE CONFLICTS - DO NOT EDIT)
  - `config/default.lua` - Active configuration file
  - `patches/*.lua` - Version compatibility patches loaded via pcall()
- `docs/` - Comprehensive docs (Polish/English mixed)
  - `00_README.md` - Doc index
  - `08_CTOmodule_Dev_Setup.md` - Dev setup (Polish)
  - `TODO.md` - Task list
  - `##_MVP_*.md` - Feature development history
- `.github/agents/` - Custom agent configs (DO NOT MODIFY)
- `tools/install_symlink.ps1` - Windows installation script

**No CI/CD**: No GitHub Actions, no automated tests, no linting configured.


## Code Conventions

**Lua Style**:
- 2 spaces indent, LF line endings
- Naming: `camelCase` (functions), `PascalCase` (modules), `UPPER_CASE` (constants)
- Namespace: Everything under `CTOmodule` global table
- Error handling: Always use `pcall()` for risky operations
- Check globals before use: `if not g_ui then perror("..."); return end`

**OTUI Style**:
- CSS-like syntax, 2-space indent
- Widget events: `onClick:` / `onDoubleClick:` (no `@` prefix)
- Key handlers: `@onEscape` / `@onEnter` (with `@` prefix on MainWindow)
- Event handlers: `onClick: g_lua.call('CTOmodule.functionName', args)`

**Critical Path Rule**: Inside module files (`init.lua`, `module.lua`, OTUI files), use **module-relative paths**:
- ✅ `dofile('module.lua')` NOT `dofile('modules/CTOmodule/module.lua')`
- ✅ `g_ui.loadUI('ui/main.otui', parent)` NOT `g_ui.loadUI('modules/CTOmodule/ui/main.otui', parent)`
- OTClient sets working directory to module folder when running init.lua
- Exception: OTClient console/manual loads may still need `modules/CTOmodule/` prefix

**API Compatibility**: Module includes fallback functions for cross-version OTClient support (see lines 18-120 in `module.lua` for patterns like `getRootWidgetSafe()`, `settingsSet()`, `settingsGetBool()`).

## Key Constraints

1. **Merge Conflicts**: `init.lua` (line 4-21), `module.lua` (line 12), and `ui/main.otui` (line 16-554) contain conflict markers. DO NOT modify these files unless explicitly asked to resolve conflicts.
2. **No Dependencies**: Module must be self-contained. Do not add npm packages, external libraries, or build tools.
3. **Manual Testing Only**: No automated tests. Test all changes in actual OTClient.
4. **Mixed Documentation**: Docs are Polish/English - match the language of the file you're editing.
5. **No Modifications**: Never touch `.github/agents/` directory or OTClient core files.

## Common Patterns

**Module reload support**:
```lua
function CTOmodule.terminate()
  if CTOmodule.mainWindow then
    CTOmodule.mainWindow:destroy()
    CTOmodule.mainWindow = nil
  end
  -- Unbind hotkeys, stop timers
end
```

**Settings persistence**:
```lua
settingsSet('CTOmodule.key', value)
local val = settingsGetBool('CTOmodule.key', defaultValue)
```

**Safe global access**:
```lua
if not g_settings then 
  perror("g_settings not available")
  return 
end
```

## Validation

Since there are no automated checks:
1. Load module in OTClient
2. Test functionality via Ctrl+Shift+C window
3. Check for Lua errors in OTClient console
4. Verify logs in module's dev console
5. Test hotkeys if modified
6. Reload module (Reload/Hard buttons) to verify persistence

## Resources

- **OTClient**: https://github.com/edubart/otclient/wiki
- **OTClientV8**: https://github.com/OTCv8/otclientv8
- **Lua 5.1**: https://www.lua.org/manual/5.1/
- **Internal docs**: `docs/00_README.md`, `docs/04_Lua_Scripting_Guide.md`, `docs/05_OTClient_API_Reference.md`
- **Dev setup**: `docs/08_CTOmodule_Dev_Setup.md` (Polish)
- **Additional details**: See `AGENTS.md` for extended guidance

## Frequently Modified Files
- `modules/CTOmodule/module.lua` - Core logic
- `modules/CTOmodule/ui/main.otui` - UI (careful: has conflicts)
- `modules/CTOmodule/config/default.lua` - Settings
- `docs/TODO.md` - Task tracking
