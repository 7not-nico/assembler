# window-rule.md

A window rule is a declarative match-and-effect pair applied to windows.

`hl.window_rule({ name?, match = {...}, ...effects })` — match props include `class`, `title` (RegEx), `initial_class`, `tag`, `xwayland`, `float`, `fullscreen_state_client/internal`, `workspace`. Effects include static (`float`, `tile`, `fullscreen`, `maximize`, `monitor`, `workspace`, `pin`, `scrolling_width`, `move`, `size`) and dynamic (`opacity`, `border_color`, `rounding`, `persistent_size`, `focus_on_activate`, `no_auto_hdr`, `opaque`, `force_rgbx`).

Rules return a handle with `set_enabled(bool)` / `is_enabled()` for runtime control. Named rules are re-targetable. `move`/`size` use monitor-local expressions (`monitor_w/h`, `window_x/y/w/h`, `cursor_x/y`).

Layer rules (`hl.layer_rule`) apply to layer surfaces (bars) — `match = { namespace = "waybar" }`.
