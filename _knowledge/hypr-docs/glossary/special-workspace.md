# special-workspace.md

A special workspace is a scratchpad-like workspace that overlays the current workspace.

Special workspaces hide/show on demand, named `special:NAME`. Windows moved to a special workspace are hidden until the workspace is toggled. `hl.dsp.window.move({ workspace = "special:magic" })` moves a window; `hl.dsp.workspace.toggle_special("magic")` reveals it.

Behavior config: `general` special workspace options, `misc` dim effects (`dim_special` dims the rest of the screen when a special workspace is open). Events: `activespecial`.

Scale on special workspace (dwindle): `dwindle.special_scale_factor`.
