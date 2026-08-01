# workspace.md

A workspace is a virtual desktop within Hyprland that holds a set of windows.

Workspaces are identified by name or id. They can be created, destroyed, renamed, and moved between monitors. Workspaces receive per-workspace rules (`hl.workspace_rule`) controlling gaps, borders, layout, monitor binding, and persistence.

Events: `createworkspace`, `destroyworkspace`, `moveworkspace`, `renameworkspace` (socket2).

Selectors for workspace rules: `w[A-B]` window-count ranges with flags (`t` tiled, `f` floating, `g` groups, `v` visible, `p` pinned); `f[-1..2]` fullscreen state.
