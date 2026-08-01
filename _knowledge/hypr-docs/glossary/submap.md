# submap.md

A submap is a named mode that temporarily rebinds keys.

Submaps enable modal keybinding (like Vim modes). `hl.bind("ALT + R", hl.dsp.submap("resize"))` enters the mode; `hl.define_submap("resize", function() hl.bind(...) end)` defines its binds; `hl.dsp.submap("reset")` returns to default.

Submap events: `submap` on socket2 (empty = default). Waybar uses `hyprland/submap` module to display active mode.
