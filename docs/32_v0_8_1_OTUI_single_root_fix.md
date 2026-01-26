# v0.8.1 — OTUI single-root fix

## Problem
OTClient error:
`cannot have multiple main widgets in otui files`

## Cause
The Tasks UI block was appended at top-level (no indentation), creating multiple root widgets.

## Fix
Indent the Tasks UI block so it becomes children of the existing `MainWindow` (`ctoWindow`).

## Test
```lua
dofile('modules/CTOmodule/init.lua') init()
CTOmodule.toggle() -- window should open without OTUI errors
```
