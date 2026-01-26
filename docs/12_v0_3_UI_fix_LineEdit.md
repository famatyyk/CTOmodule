# UI fix (v0.3)

Some OTClient builds do not define the `LineEdit` widget/style in OTUI.

Fix:
- Replace `LineEdit` with `TextEdit` configured as a single-line input:
  - `height: 20`
  - `multiline: false`

File:
- `modules/CTOmodule/ui/main.otui`
