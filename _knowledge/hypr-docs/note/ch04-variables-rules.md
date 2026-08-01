# ch04-variables-rules.md

**Source:** wiki.hypr.land/Configuring/Basics/Variables, /Monitors, /Window-Rules, /Workspace-Rules (2026-07-30), latest git — post-0.55 Lua

## Config sections (`hl.config({...})`)

```
| Section | Key options (default) |
|---------|----------------------|
| general | `border_size` (1), `gaps_in` (5), `gaps_out` (20), `float_gaps` (0, -1=default), `gaps_workspaces` (0, stacks with gaps_out), `col.inactive_border` (0xff444444), `col.active_border` (0xffffffff), `layout` ("dwindle" / "master" / "scrolling" / "monocle") |
| decoration | `rounding` (0), `dim_strength` (0.5), `dim_special` (0.2), `dim_around` (0.4) |
| input | tablet: `transform`, `region_position`, `absolute_region_position`; keyboard `kb_options` |
| misc | `disable_hyprland_logo`, `disable_splash_rendering`, `exit_window_retains_fullscreen`, `initial_workspace_tracking` (0/1/2) |
| layout | `single_window_aspect_ratio_tolerance` (0.1) |
| binds | `workspace_back_and_forth`, `hide_special_on_workspace_change`, `allow_workspace_cycles`, `workspace_center_on` (0=cursor, 1=last active window) |
| cursor | `invisible`, `warp_on_change_workspace` (0/1/2 force), `warp_on_toggle_special`, `default_monitor` |
```

## Monitors (`hl.monitor({...})`)

```lua
hl.monitor({ output = "DP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })
```

```
| Field | Type | Default | Notes |
|-------|------|---------|-------|
| output | string | required | name or `desc:...` prefix |
| mode | string | preferred | `1920x1080@144` |
| position | string | auto | virtual layout px; `auto-right/left/up/down` |
| scale | string/float | auto | auto from PPI |
| bitdepth | int | 8 | 8 or 10 |
| cm | string | srgb | color management preset |
| vrr | int | 0 | per-display VRR |
| icc | string | | ICC profile path |
| transform | int | | rotation |
| disabled | bool | false | removes from layout |
| mirror | string | | mirrored display |
```

- Empty `output` = fallback rule; recommended: `hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })`
- List: `hyprctl monitors all`
- Reserved area: `reserved_area = 10` or `{ top, bottom, left, right }` — stacks with bars
- Disabling ≠ screensaver: use `dpms` dispatcher to just turn off

## Window Rules (`hl.window_rule({...})`)

```lua
hl.window_rule({ name = "apply-something", match = { class = "my-window" }, border_size = 10 })
-- anonymous variant omits name
```

### Match props

`class`, `title` (RegEx); `initial_class`; `tag` (name); `xwayland` (bool); `float` (bool); `fullscreen_state_client`/`fullscreen_state_internal` (0/1/2/3); `workspace` (`id`, `"name:string"`, or selector).

### Static effects

`float`, `tile`, `fullscreen` (bool); `maximize`; `monitor` (e.g. `"1"`/`"DP-1"`, suffix ` silent`); `workspace` (or `"unset"`, ` silent`); `pin` (floating only, all workspaces); `scrolling_width` (column width); `move`/`size` via expressions.

### Expressions (move/size)

Monitor-local vars: `monitor_w/h`, `window_x/y`, `window_w/h`, `cursor_x/y`. Space-separated, no spaces within expression:
```lua
move = {"window_w * 0.5", "(monitor_h / 2) + 17"}
size = {"monitor_w * 0.5", "monitor_h * 0.5"}
```

### Dynamic effects

`persistent_size` (restore float size per class+title), `focus_on_activate`, `no_auto_hdr` (foot AutoHDR fix), `opaque`, `force_rgbx` (ignore alpha), `opacity` (`"1.0 override 0.5 override 0.8 override"` — active/inactive/fullscreen), `border_color`, `rounding`.

### Tags

```lua
hl.bind("SUPER + CTRL + 2", hl.dsp.window.tag({ tag = "alpha_0.2" }))
hl.window_rule({ match = { tag = "alpha_0.2" }, opacity = "0.2 override" })
```

### Runtime control

```lua
local myRule = hl.window_rule({ name = "my-rule", match = { class = "kitty" }, border_size = 5 })
myRule:set_enabled(false)  -- disable
myRule:set_enabled(true)   -- re-enable
myRule:is_enabled()        -- query
```

## Layer Rules (`hl.layer_rule({...})`)

```lua
local myLayerRule = hl.layer_rule({
  name = "my-layer-rule",
  match = { namespace = "waybar" },
  blur = true,
})
myLayerRule:set_enabled(false)
```
Same handle API. Used for bars/layers — `match = { namespace = ... }`.

## Workspace Rules (`hl.workspace_rule({...})`)

```lua
hl.workspace_rule({ workspace = "name:coding", no_rounding = true, decorate = false,
                    gaps_in = 0, gaps_out = 0, no_border = true, monitor = "DP-1" })
```

### Selectors

- `w[(flags)A-B]`, `w[(flags)X]` — window counts; flags: `t` tiled-only, `f` floating-only, `g` count groups, `v` visible only, `p` pinned only
- `f[-1]/f[0]/f[1]/f[2]` — fullscreen state: -1 none, 0 FS, 1 maximized, 2 FS w/o state sent
- `s[false]` — ignore special workspaces

### Rules

`monitor`, `default` (default workspace for monitor), `gaps_out`, `float_gaps`, `border_size`, `no_border`, `no_shadow`, `no_rounding`, `decorate`, `persistent` (keep alive when empty), `on_created_empty` (command), `default_name`, `layout` (per-workspace layout, e.g. `"scrolling"`), `layout_opts` (layout-specific table), `animation`.

### Examples

```lua
hl.workspace_rule({ workspace = "5", on_created_empty = "[float] firefox" })
hl.workspace_rule({ workspace = "15", animation = "slidevert", default_name = "slider" })
```

### Smart gaps

```lua
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
-- ignore special: add s[false]
```

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Configuring/Basics/Variables, /Monitors, /Window-Rules, /Workspace-Rules (2026-07-30), latest git — post-0.55 Lua
