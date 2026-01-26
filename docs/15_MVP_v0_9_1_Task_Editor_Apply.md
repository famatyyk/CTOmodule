# MVP v0.9.1 - Task Editor Apply (runtime binding)

This patch makes Task Editor entries actually create/update runtime scheduler tasks.

## What changed

- Added `CTOmodule.taskEditor.applyToRuntime()`:
  - Registers editor entries as runtime tasks (scheduler).
  - Each entry runs `CTOmodule.actions.run(<action>)` if `action` is set.
  - Applies `intervalMs`, `priority`, and `enabled` from the editor entry.
  - Avoids overriding existing non-editor tasks (conflict protection).
  - Removes runtime tasks that were previously created by the editor but were deleted from the editor.

- Added UI button **Apply** (`btnTaskEditorApply`) + wiring.

- Added actions:
  - `task_editor_apply`
  - `task_editor_ui_apply`

## Console usage

After you create/edit entries in UI and press Save:

- Apply editor entries to runtime:
  - `CTOmodule.actions.run('task_editor_apply')`
  - or click **Apply** in Task Editor section

## Notes

- Editor enabled state is persisted in the Task Editor store.
- `applyToRuntime()` does **not** write `tasksEnabled` store (so it will not pollute the scheduler persistence).
