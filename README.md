# CTOmodule

Minimal OTClient module skeleton.

## Features
- Development console with logging
- Tick loop system
- Action system with hotkey bindings
- Task scheduler with editor
- Settings persistence
- **Data collector** (collects UI widget, hotkey, and connection state data)
- **Module builder** (displays collected data summary)

## Test
- Start OTClient (module placed in modules/).
- Press **Ctrl+Shift+C** to toggle the window.

## Data Collection
The module includes an opt-in data collector that automatically gathers:
- UI widget tree and window list
- Hotkey bindings
- Connection state (online/ping)
- Player state (minimal, privacy-aware)

Data is written to `config/collector_output.lua` and can be viewed using `CTOmodule.builder.refresh()`.