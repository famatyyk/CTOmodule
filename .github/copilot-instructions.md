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
2. **Version Conflicts**: Handle merge conflicts carefully (note the conflict markers in code)
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
