# MVP v0.8 — Tasks UI + per-task config (interval/priority)

## Co dochodzi
- **Sekcja Tasks (Scheduler) w oknie CTOmodule**
  - lista tasków (z filtrem) + wybór (Prev/Next)
  - Toggle (enable/disable), RunOnce
  - edycja **intervalMs** i **priority** dla zaznaczonego taska (Set)

## Persist (ustawienia w g_settings)
- `CTOmodule.tasksEnabled` — już działało: które taski są włączone
- `CTOmodule.tasksConfig` — **nowe**: zapisuje konfigurację per-task:
  - `intervalMs` i `priority` (format linii: `name=intervalMs,priority`)

## Run-order
- Tick loop uruchamia taski według **priority (malejąco)**.
- Przy remisach priority sortuje alfabetycznie po nazwie.

## Test (konsola)
1) Start:
- `dofile('modules/CTOmodule/init.lua') init()`

2) UI:
- Otwórz okno (`Ctrl+Shift+C`)
- Wejdź w sekcję **Tasks**
- Ustaw filter / Prev / Next, klikaj:
  - Toggle
  - RunOnce
  - Set Interval / Set Priority

3) Persist:
- Ustaw interval/priority w UI (Set)
- `CTOmodule.reload()` lub `CTOmodule.reloadHard()`
- Sprawdź, że wartości wracają po re-init.

## Pliki
- `modules/CTOmodule/module.lua` — tasksConfig + sort po priority + UI wiring
- `modules/CTOmodule/ui/main.otui` — Tasks UI w oknie
