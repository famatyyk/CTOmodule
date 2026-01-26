# v0.8.4.3 — Fix OTUI: single root widget

## Problem
OTClient error:
`cannot have multiple main widgets in otui files`

## Cause
Several `Button` widgets were accidentally placed at root level (no indentation), creating multiple main widgets.

## Fix
Indent the trailing Buttons so they are children of the existing `MainWindow`.

## Test
```lua
dofile('modules/CTOmodule/init.lua'); init(); CTOmodule.toggle()
```
