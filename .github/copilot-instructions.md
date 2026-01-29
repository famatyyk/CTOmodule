
# CTOmodule - Copilot Instructions

## Project Overview

CTOmodule is a minimal OTClient module skeleton written in Lua. OTClient is an alternative Tibia client framework that uses:
- **C++11** core engine
- **Lua** scripting for game logic and UI
- **OTUI** (CSS-like syntax) for interface design

This module serves as a starter template for creating custom OTClient modules with task scheduling, action management, and hotkey binding capabilities.

## Tech Stack

- **Primary Language**: Lua
- **UI Framework**: OTUI (OTClient UI markup language)
- **Target Platform**: OTClient (compatible with edubart/otclient and mehah/otclient)
- **Tibia Protocol**: Supports versions 7.x - 12.x

## Project Structure

```
CTOmodule/
├── modules/CTOmodule/        # Main module directory
│   ├── CTOmodule.otmod      # Module manifest
│   ├── init.lua             # Module initialization
│   ├── module.lua           # Core module logic
│   ├── default.lua          # Default configuration
│   ├── config/              # Configuration files
│   ├── patches/             # Version-specific patches
│   └── ui/                  # OTUI interface files
│       └── main.otui        # Main UI definition
├── docs/                    # Documentation
├── tools/                   # Utility scripts
└── README.md
```

## Coding Conventions

### Lua Style Guidelines

1. **Global Tables**: Use module namespacing to avoid polluting global scope
   ```lua
   CTOmodule = CTOmodule or {}
   CTOmodule.taskEditor = {}
   ```

2. **Error Handling**: Use `pcall` for potentially failing operations
   ```lua
   local ok, result = pcall(someFunction)
   if ok then
     -- handle success
   end
   ```

3. **Fallback Patterns**: Implement safe fallback functions for cross-version compatibility
   ```lua
   if type(getRootWidgetSafe) ~= 'function' then
     function getRootWidgetSafe()
       -- fallback implementation
     end
   end
   ```

4. **Settings**: Use global fallback helpers for settings operations that support both function-call and method-call styles

### OTUI Guidelines

1. **Anchoring**: Use anchors for responsive layouts
   ```otui
   anchors.top: parent.top
   anchors.left: parent.left
   margin-top: 10
   ```

2. **IDs**: Always provide meaningful IDs for interactive elements
   ```otui
   Button id: btnSave
   TextEdit id: taskNameEdit
   ```

3. **Lua Callbacks**: Use `g_lua.call()` for Lua function calls from OTUI
   ```otui
   onClick: g_lua.call('CTOmodule.someFunction')
   ```

### Module Loading

- Use `.otmod` files for module metadata
- Always check for existence before calling module functions
- Use `dofile()` for loading Lua files
- Use `pcall(dofile, ...)` for optional patches

## OTClient API Reference

### Common Global Objects

- `g_ui` - UI management
- `g_settings` - Settings persistence
- `g_lua` - Lua scripting interface
- `player` - Player object with methods like `getName()`, `getHealth()`, etc.
- `rootWidget` - Root UI widget

### Key Functions

- `scheduleEvent(callback, delay)` - Schedule delayed execution
- `print()` / `perror()` - Console output
- Widget methods: `getText()`, `setText()`, etc.

## Development Practices

### Module Development

1. **Initialization**: Implement `init()` and `terminate()` functions
2. **UI Management**: Create window with toggle functionality (default: Ctrl+Shift+C)
3. **State Persistence**: Use `g_settings` for saving user preferences
4. **Safe Widget Access**: Always use safe accessors that handle nil cases

### Testing

- Manual testing in OTClient
- Place module in `modules/` directory
- Use Ctrl+Shift+C to toggle the module window
- Check console for errors with `perror()`

### Compatibility

- Support multiple OTClient versions (handle API differences with fallbacks)
- Use patches for version-specific fixes (see `patches/` directory)
- Test with both older builds (df422c0) and newer forks

## Important Warnings

1. **No Build System**: This is a Lua module, no compilation needed
2. **Merge Conflicts**: Always resolve merge conflicts completely before committing - do not leave conflict markers in code
3. **Global Scope**: Avoid polluting global namespace - use module tables
4. **OTClient Specific**: Code only runs within OTClient environment, not standalone Lua

## Module Toggle

Default hotkey: **Ctrl+Shift+C**

## References

- OTClient API documentation in `docs/05_OTClient_API_Reference.md`
- TFS Lua API in `docs/06_TFS_Lua_API_Reference.md`
- OTClient overview in `docs/01_OTC_Overview.md`
- Project TODOs in `docs/TODO.md`

## Special Notes

- Polish language comments may appear in documentation (project has Polish contributors)
- Task Editor is a core feature (v0.9) with scheduler, actions, and hotkey binding
- Module uses a fallback pattern for settings and widget access to ensure cross-version compatibility
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

