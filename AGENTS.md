# CTOmodule - GitHub Copilot Instructions

## Project Overview

CTOmodule is a minimal OTClient module skeleton written in Lua. OTClient is an alternative Tibia client for OTServ servers, heavily scriptable with Lua and using CSS-like syntax for UI design.

## Technology Stack

- **Primary Language**: Lua (5.1/LuaJIT)
- **UI Framework**: OTUI (CSS-like syntax for OTClient UI)
- **Target Platform**: OTClient (Open Tibia Client)
- **Documentation**: Markdown

## Project Structure

```
CTOmodule/
├── modules/CTOmodule/    # Main module code
│   ├── init.lua          # Module initialization
│   ├── module.lua        # Core module logic
│   ├── default.lua       # Default settings
│   ├── CTOmodule.otmod   # Module manifest
│   ├── ui/               # OTUI interface files
│   ├── config/           # Configuration files
│   └── patches/          # Compatibility patches
├── docs/                 # Documentation in Polish and English
├── tools/                # Installation and utility scripts
└── README.md             # Project README
```

## Key Commands

This is a Lua module project with no build system. Testing is done by:
1. Placing the module in OTClient's `modules/` directory
2. Starting OTClient
3. Testing the module with **Ctrl+Shift+C** hotkey

## Code Style Guidelines

### Lua Code Style
- Use 2 spaces for indentation
- Follow existing naming conventions:
  - `camelCase` for functions and local variables
  - `PascalCase` for module/global table names
  - `UPPER_CASE` for constants
- Use `CTOmodule` as the global namespace
- Add error handling with `pcall()` for potentially failing operations
- Use fallback functions for API compatibility (see `module.lua` examples)

### Example Lua Code:
```lua
-- Module structure
CTOmodule = CTOmodule or {}

CTOmodule.taskEditor = {
  store = {},
  upsert = function(taskId, data, force)
    if not force and CTOmodule.taskEditor.store[taskId] then
      perror("TaskEditor: Task ID already exists: " .. taskId)
      return false
    end
    CTOmodule.taskEditor.store[taskId] = data
    return true
  end
}

-- Always use safe access patterns
function CTOmodule.init()
  if not g_ui then 
    perror("g_ui not available")
    return 
  end
  -- initialization code
end
```

### OTUI Style
- Follow CSS-like syntax
- Use existing widget patterns
- Anchor widgets properly using OTClient anchor system
- Example:
```
MainWindow < Window
  id: mainWindow
  size: 400 300
  text: CTOmodule
  @onEscape: self:destroy()
```

## Documentation Style

- Use clear, concise English or Polish (match existing docs)
- Include code examples where relevant
- Reference OTClient API when applicable
- Keep TODO.md updated with pending tasks

## Boundaries - DO NOT

- **Never** edit or remove files in `.git/` directory
- **Never** modify OTClient core files (this is a module only)
- **Never** commit secrets, passwords, or API keys
- **Never** remove or significantly modify existing working functionality without explicit request
- **Never** add external dependencies or libraries (module must be self-contained)
- **Never** modify the merge conflict markers in `init.lua` unless specifically asked to resolve them

## Best Practices

1. **Maintain Compatibility**: Use fallback functions for API calls (see `getRootWidgetSafe`, `settingsSet` examples)
2. **Error Handling**: Always use `pcall()` for operations that might fail
3. **Global Namespace**: Keep everything under `CTOmodule` table to avoid conflicts
4. **Testing**: Test changes in OTClient by placing module in modules/ directory
5. **Documentation**: Update relevant docs when making functional changes
6. **Minimal Changes**: Make the smallest possible changes to achieve the goal

## Special Considerations

- The module contains merge conflict markers in `init.lua` - handle with care
- Some docs are in Polish - maintain language consistency when editing
- Patches directory contains compatibility fixes - understand context before modifying
- This is a starter/skeleton module - keep it simple and extensible
