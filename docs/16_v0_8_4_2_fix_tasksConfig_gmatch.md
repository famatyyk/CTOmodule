# v0.8.4.2 — Fix tasksConfig parser (gmatch newline)

## Problem
Lua parse error:
`unfinished string near ''[^'`

## Cause
The pattern in `_loadTasksConfig()` was split across lines:
`raw:gmatch('[^<newline>]+')`

## Fix
Use an explicit escaped newline:
`raw:gmatch('[^\\n]+')`
