# Fix: module.lua syntax error near '.7'

## Symptom
Lua error:
`unexpected symbol near '.7'`

## Cause
A comment line lost its `--` prefix and became:
`.7: Task Scheduler ...`

## Fix
Restore it as a comment:
`-- === MVP v0.7: Task Scheduler ... ===`
