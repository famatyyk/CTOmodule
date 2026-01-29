# CTOmodule - GitHub Copilot Agent Instructions

## Project Overview

**CTOmodule** is a minimal, extensible OTClient module skeleton written in Lua. OTClient is an alternative open-source Tibia client for OTServ servers, heavily scriptable with Lua and using CSS-like OTUI syntax for UI design.

This module serves as a starter template for creating custom OTClient modules with features like:
- Dev console with logging
- Tick loop system for periodic tasks
- Action system with hotkey bindings
- Task scheduler with priority support
- Task editor for runtime task management
- Settings persistence across reloads

## Technology Stack

- **Primary Language**: Lua (5.1/LuaJIT)
- **UI Framework**: OTUI (CSS-like syntax specific to OTClient)
- **Target Platform**: OTClient (Open Tibia Client)
- **Documentation**: Markdown (mixed Polish and English)
- **Version Control**: Git
- **No Build System**: This is a pure Lua module with no compilation step

## Project Structure

```
CTOmodule/
├── .github/
│   ├── agents/              # Custom agent definitions (DO NOT MODIFY)
│   └── copilot-instructions.md  # This file
├── modules/CTOmodule/       # Main module code
│   ├── init.lua             # Module entry point (HAS MERGE CONFLICTS)
│   ├── module.lua           # Core module logic (~2400 lines)
│   ├── default.lua          # Default settings (deprecated)
│   ├── CTOmodule.otmod      # Module manifest
│   ├── ui/
│   │   └── main.otui        # Main UI definition (HAS MERGE CONFLICTS)
│   ├── config/
│   │   └── default.lua      # Configuration defaults
│   └── patches/             # Compatibility patches for different versions
│       ├── task_editor_patch_v_092.lua
│       ├── v0_9_3_editor_ui_edit.lua
│       └── ...
├── docs/                    # Comprehensive documentation (Polish & English)
│   ├── 00_README.md         # Documentation index
│   ├── 01_OTC_Overview.md   # OTClient overview
│   ├── 08_CTOmodule_Dev_Setup.md  # Dev environment setup
│   ├── TODO.md              # Project TODO list
│   ├── DESIGN.md            # Design notes
│   └── [MVP documentation files for various versions]
├── tools/
│   └── install_symlink.ps1  # Windows symlink installer
├── AGENTS.md                # Agent guidelines (similar content to this file)
├── README.md                # Project README
└── .gitignore               # Git ignore rules
```

## Key Commands & Testing

**⚠️ CRITICAL**: This module has **NO build system, NO test suite, NO CI/CD**. 

### Testing Process:
1. Install the module in OTClient's `modules/` directory (use symlink for dev):
   - Windows: See `docs/08_CTOmodule_Dev_Setup.md` or use `tools/install_symlink.ps1`
   - Direct: Copy `modules/CTOmodule` to OTClient's modules folder
2. Start OTClient
3. Press **Ctrl+Shift+C** to toggle the module window
4. Use the Dev Console in the module UI to:
   - View logs
   - Test actions
   - Debug tick loop
   - Manage tasks

### Manual Testing Commands (in OTClient console):
```lua
-- Load module manually
dofile('modules/CTOmodule/init.lua')
init()

-- Toggle window
-- Ctrl+Shift+C (hotkey)

-- Test specific functions
if CTOmodule then print("CTOmodule loaded") end
```

## Code Style Guidelines

### Lua Code Conventions

#### Naming Conventions:
- **camelCase**: Functions and local variables
  - `function loadSettings()`, `local playerName = ""`
- **PascalCase**: Module/global table names
  - `CTOmodule`, `CTOmodule.TaskEditor`
- **UPPER_CASE**: Constants
  - `DEFAULT_INTERVAL`, `MAX_LOG_LINES`

#### Indentation & Formatting:
- **2 spaces** for indentation (not tabs)
- No trailing whitespace
- LF line endings (Unix style)

#### Module Structure Pattern:
```lua
-- Always initialize module table safely
CTOmodule = CTOmodule or {}

-- Use sub-tables for organization
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
```

#### Error Handling:
- **ALWAYS** use `pcall()` for operations that might fail:
  ```lua
  local ok, result = pcall(functionThatMightFail, arg1, arg2)
  if not ok then
    perror("Error: " .. tostring(result))
    return
  end
  ```

- Check for global availability before use:
  ```lua
  function CTOmodule.init()
    if not g_ui then 
      perror("g_ui not available")
      return 
    end
    -- safe to use g_ui here
  end
  ```

#### Global Namespace:
- Keep **everything** under `CTOmodule` table to avoid conflicts
- Use `CTOmodule.` prefix for all module functions and data
- Exception: Helper fallback functions (see below)

#### API Compatibility Fallbacks:
The module includes extensive fallback functions for OTClient API compatibility across versions. See `module.lua` for examples:

```lua
-- Example: Safe getRootWidget access
if type(getRootWidgetSafe) ~= 'function' then
  function getRootWidgetSafe()
    if g_ui then
      local fn = g_ui.getRootWidget
      if type(fn) == 'function' then
        local ok, w = pcall(fn, g_ui)
        if ok and w then return w end
        ok, w = pcall(fn)
        if ok and w then return w end
      end
    end
    return rootWidget
  end
end
```

When adding new OTClient API calls, follow this pattern to support both method-call (colon) and function-call (dot) styles.

### OTUI (UI) Code Conventions

OTUI uses CSS-like syntax for defining OTClient UI widgets.

#### Basic Structure:
```otui
MainWindow < Window
  id: mainWindow
  size: 400 300
  text: CTOmodule
  @onEscape: self:destroy()

  Button
    id: btnStart
    text: Start
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 10
    margin-left: 10
    width: 64
```

#### Key Points:
- Widget hierarchy defined by indentation (2 spaces)
- Use existing widget patterns from `ui/main.otui`
- Anchor widgets properly using OTClient's anchor system
- IDs must be unique within their parent widget
- Use `@onEvent` syntax for event handlers
- Event handlers call Lua functions: `onClick: g_lua.call('CTOmodule.functionName', args)`

#### Common Anchor Patterns:
```otui
-- Anchor to parent
anchors.top: parent.top
anchors.left: parent.left
anchors.right: parent.right
anchors.bottom: parent.bottom

-- Anchor to sibling
anchors.top: prevWidget.bottom
anchors.left: otherWidget.right

-- Margins
margin-top: 8
margin-left: 12
```

## Documentation Standards

### Language:
- Some docs are in **Polish** (e.g., `08_CTOmodule_Dev_Setup.md`, `00_README.md`)
- Some docs are in **English** (e.g., MVP docs, this file)
- **Match the language** of the file you're editing
- When creating new docs, prefer English unless context suggests Polish

### Format:
- Use clear, concise Markdown
- Include code examples where relevant
- Reference OTClient API when applicable
- Update `docs/TODO.md` when adding/completing features
- Link to external resources (OTClient wiki, OTLand forums)

### MVP Documentation Pattern:
The `docs/` folder contains numbered MVP documentation files tracking feature development:
- Pattern: `##_MVP_v#_#_Feature_Name.md`
- Documents development steps, issues encountered, and solutions
- Keep these as historical records - don't delete old MVP docs

## Module Path Conventions

**⚠️ CRITICAL PATH RULE**

In OTClient, `init.lua` executes **in the context of the module folder**.

### ✅ CORRECT Paths (relative to module folder):
```lua
dofile('module.lua')
dofile('config/default.lua')
dofile('patches/v0_9_1_apply.lua')
g_ui.loadUI('ui/main.otui', parent)
```

### ❌ WRONG Paths (double module prefix):
```lua
dofile('modules/CTOmodule/module.lua')  -- NO!
g_ui.loadUI('modules/CTOmodule/ui/main.otui', parent)  -- NO!
```

This is a common mistake. The module system already sets the working directory to the module folder.

## Known Issues & Special Considerations

### 1. Merge Conflicts in init.lua
**⚠️ CRITICAL**: `modules/CTOmodule/init.lua` contains unresolved merge conflict markers:

```lua
<<<<<<< Updated upstream
function init()
  if CTOmodule and CTOmodule.init then
    CTOmodule.init()
  end
end

function terminate()
  if CTOmodule and CTOmodule.terminate then
    CTOmodule.terminate()
  end
end
=======
pcall(dofile, 'patches/v0_9_1_apply.lua')
pcall(dofile, 'patches/v0_9_2_editor_apply_ui.lua')
pcall(dofile, 'patches/v0_9_3_editor_ui_edit.lua')
>>>>>>> Stashed changes
```

**DO NOT** modify these markers unless **explicitly asked** to resolve the merge conflict. The module may be in an intentional intermediate state for development purposes.

### 2. Merge Conflicts in main.otui
`modules/CTOmodule/ui/main.otui` also contains merge conflict markers between the old UI layout and the new task editor UI. Same rule applies: handle with care.

### 3. Patches Directory
The `patches/` directory contains compatibility fixes for different OTClient versions:
- These are loaded conditionally via `pcall(dofile, ...)`
- Understand the context before modifying patches
- New patches should follow naming convention: `v#_#_#_description.lua`

### 4. module.lua Size
`module.lua` is ~2400 lines and contains:
- All core module functionality
- Fallback functions for API compatibility
- Task system, action system, hotkey management
- Task editor logic

When editing, consider:
- Breaking into smaller modules if adding significant features
- Maintaining the existing organization pattern
- Testing thoroughly as this is the module's core

### 5. No Automated Testing
There is no unit test framework, integration tests, or CI/CD pipeline. All testing must be:
- Manual testing in OTClient
- Visual inspection of UI changes
- Testing with actual OTClient running
- Checking console output for errors

## Development Workflow

### For Code Changes:

1. **Understand First**:
   - Read relevant docs in `docs/`
   - Review `docs/TODO.md` for context
   - Check `docs/DESIGN.md` for design decisions
   - Look for related MVP documentation

2. **Make Minimal Changes**:
   - Change as few lines as possible
   - Preserve existing functionality
   - Follow established patterns in the codebase
   - Use existing helper functions (fallbacks, safe accessors)

3. **Test Manually**:
   - Set up symlink to OTClient modules (see `docs/08_CTOmodule_Dev_Setup.md`)
   - Start OTClient and test with **Ctrl+Shift+C**
   - Exercise the changed functionality
   - Check for Lua errors in OTClient console
   - Verify logs in the module's dev console

4. **Document if Needed**:
   - Update docs if behavior changes significantly
   - Add comments only if they match existing style or explain complexity
   - Update `docs/TODO.md` if completing/adding tasks

### For Documentation Changes:

1. Match the language of the existing document (Polish or English)
2. Maintain the markdown structure and formatting
3. Test any code examples if provided
4. Update cross-references if document structure changes

## Security & Safety Guidelines

### Never:
- Commit secrets, passwords, or API keys
- Introduce security vulnerabilities (e.g., code injection)
- Modify `.git/` directory
- Modify `.github/agents/` directory (agent configs, not relevant to coding tasks)
- Modify OTClient core files (this is a module only)
- Remove or significantly modify working functionality without explicit request
- Add external dependencies or libraries (module must be self-contained)
- Modify merge conflict markers unless explicitly asked to resolve them

### Always:
- Use `pcall()` for error-prone operations
- Validate user inputs if adding interactive features
- Escape strings properly for UI display
- Follow the established global namespace pattern (`CTOmodule.*`)
- Preserve backward compatibility when possible

## Common Patterns & Best Practices

### 1. Safe Global Access
```lua
if not g_settings then 
  perror("g_settings not available")
  return 
end
```

### 2. Module Reload Support
```lua
-- In init/terminate, clean up safely
function CTOmodule.terminate()
  if CTOmodule.mainWindow then
    CTOmodule.mainWindow:destroy()
    CTOmodule.mainWindow = nil
  end
  -- Unbind hotkeys, stop timers, etc.
end
```

### 3. Settings Persistence
```lua
-- Use fallback helpers for settings
settingsSet('CTOmodule.windowVisible', true)
local visible = settingsGetBool('CTOmodule.windowVisible', false)
```

### 4. Logging Pattern
```lua
-- Use the module's log functions
function CTOmodule.log(message)
  -- Logs to internal buffer and UI
end

function perror(message)
  print("[ERROR] " .. message)
end
```

### 5. UI Loading
```lua
-- Load UI relative to module folder
if not CTOmodule.mainWindow then
  CTOmodule.mainWindow = g_ui.loadUI('ui/main.otui', getRootWidgetSafe())
end
```

## Quick Reference: Files You'll Likely Edit

### Frequently Modified:
- `modules/CTOmodule/module.lua` - Core logic, add features here
- `modules/CTOmodule/ui/main.otui` - UI layout changes
- `modules/CTOmodule/config/default.lua` - Default settings
- `docs/TODO.md` - Task tracking

### Occasionally Modified:
- `modules/CTOmodule/init.lua` - Module entry (careful with merge conflicts!)
- `modules/CTOmodule/patches/*.lua` - Version compatibility
- `docs/##_MVP_*.md` - Feature documentation
- `README.md` - Project description

### Rarely Modified:
- `modules/CTOmodule/CTOmodule.otmod` - Module manifest
- `.gitignore` - Ignore patterns
- `tools/install_symlink.ps1` - Installation script

## Git & Version Control

### Branch Naming:
The repository appears to use descriptive branch names. Follow existing patterns.

### Commit Messages:
- Be descriptive but concise
- Reference issue numbers if applicable
- Example: "Fix task editor save button handler"

### What NOT to Commit:
- `.DS_Store`, `Thumbs.db` (OS files)
- `*.log`, `*.tmp` (temporary files)
- IDE folders: `.idea/`, `.vscode/`
- Build artifacts: `out/`, `build/`, `dist/`
- Dependencies: `node_modules/`, `__pycache__/`, `.venv/`
- Archive files: `*.zip`

Already covered by `.gitignore`.

## Resources & References

### OTClient Documentation:
- **GitHub**: https://github.com/edubart/otclient
- **Wiki**: https://github.com/edubart/otclient/wiki
- **Forum**: https://otland.net/forums/otclient.494/

### OTClientV8 (Bot Features):
- **GitHub**: https://github.com/OTCv8/otclientv8
- **Discord**: https://discord.gg/feySup6
- **Bot Scripts**: https://otland.net/threads/scripts-macros-for-kondras-otclientv8-bot.267394/

### Lua Resources:
- **Lua 5.1 Manual**: https://www.lua.org/manual/5.1/
- **OTLand Lua Guide**: https://docs.otland.net/lua-guide/

### In This Repository:
- `docs/00_README.md` - Documentation index
- `docs/01_OTC_Overview.md` - OTClient overview
- `docs/04_Lua_Scripting_Guide.md` - Lua programming guide
- `docs/05_OTClient_API_Reference.md` - Complete OTClient API
- `docs/07_Quick_Start_Examples.md` - Code examples
- `docs/08_CTOmodule_Dev_Setup.md` - Development setup (Polish)

## Troubleshooting Common Issues

### "System cannot find the specified path" (Windows symlink)
- Parent folder doesn't exist: Ensure `...\mklauncher\althea\modules` exists
- Wrong user in path: Check username in AppData path

### "Double module path" Error
- Using `dofile('modules/CTOmodule/...')` instead of `dofile('...')`
- Using `g_ui.loadUI('modules/CTOmodule/ui/...')` instead of `g_ui.loadUI('ui/...')`

### Module Doesn't Load
- Check OTClient console for Lua errors
- Verify `enabled: true` in `CTOmodule.otmod`
- Check path to OTClient modules folder
- Try manual load: `dofile('modules/CTOmodule/init.lua')` then `init()`

### UI Doesn't Show
- Press **Ctrl+Shift+C** hotkey
- Check if window is created: print(`tostring(CTOmodule.mainWindow)`)
- Check for OTUI syntax errors in `ui/main.otui`

### Hotkeys Don't Work
- Check hotkey bindings in module console
- Use "Show" button in Hotkeys section to list active bindings
- Verify no conflicts with OTClient default hotkeys

## Working with This Module

### When Adding New Features:
1. Add core logic to `module.lua` in the `CTOmodule` namespace
2. Add UI elements to `ui/main.otui` following anchor patterns
3. Wire UI events to Lua functions: `onClick: g_lua.call('CTOmodule.yourFunction')`
4. Add default settings to `config/default.lua` if needed
5. Document in a new MVP doc or update existing docs
6. Update `docs/TODO.md`

### When Fixing Bugs:
1. Reproduce the issue in OTClient
2. Check console/log output for errors
3. Make minimal, targeted fix
4. Test thoroughly in OTClient
5. Document fix if it's a known issue

### When Updating Documentation:
1. Match language (Polish/English) of existing doc
2. Maintain markdown structure
3. Test any code examples
4. Update cross-references

## Summary: Key Takeaways

1. **No Build/Test System**: Manual testing in OTClient only
2. **Module-Relative Paths**: Never use `modules/CTOmodule/` prefix in paths
3. **Merge Conflicts Exist**: Don't touch `init.lua` conflict markers without explicit request
4. **Lua 5.1**: Use compatible syntax (no bitwise ops, `goto`, etc.)
5. **Error Handling**: Always use `pcall()` for risky operations
6. **Global Namespace**: Keep everything under `CTOmodule` table
7. **Fallback Functions**: Support multiple OTClient API versions
8. **2-Space Indent**: Consistent with existing code
9. **Self-Contained**: No external dependencies allowed
10. **Documentation**: Mixed Polish/English - match the file you're editing

## Getting Help

- Check `docs/` folder for comprehensive guides
- Review existing code in `module.lua` for patterns
- Refer to OTClient wiki for API questions
- See `docs/00_README.md` for documentation index
- Ask the user if you're unsure about merge conflicts or major changes

---

**Last Updated**: January 2026
**Module Version**: 0.1.0 (v0.9 features)
