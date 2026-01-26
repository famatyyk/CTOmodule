# MVP v0.9.0 — Task Editor core (model + persistence + UI skeleton)

## Model
- `CTOmodule.taskEditor` with `map`, `order`, `index`
- Helpers: `load`, `save`, `list`, `get`, `upsert`, `remove`
- Stored in `modules/CTOmodule/module.lua`

## Persistence
- Key: `CTOmodule.taskEditor`
- Line format:
  - `name=intervalMs,priority,enabled,action`
  - `action` is optional
  - Defaults: intervalMs=1000, priority=0, enabled=1

## UI skeleton
- Section: **Task Editor (v0.9)**
- Read-only list box + name/action/interval/priority fields
- Enabled checkbox
- Buttons: Prev/Next, Save, Delete
- Wired in `module.lua` and refreshed on init
