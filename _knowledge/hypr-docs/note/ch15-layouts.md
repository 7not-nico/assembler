# ch15-layouts.md

**Source:** wiki.hypr.land/Configuring/Layouts/ — Dwindle, Master, Scrolling, Monocle (2026-07-29), latest git

## Dwindle (default) — `hl.config({ dwindle = {...} })`

BSPWM-like: every window is a member of a binary tree.

**Quirk:** splits NOT permanent — determined by W/H ratio of parent (W>H → side-by-side; H>W → top-and-bottom). Enable `preserve_split` to fix.

```
| Option | Default | Meaning |
|--------|---------|---------|
| force_split | 0 | 0 mouse-follows; 1 always left/top; 2 always right/bottom |
| preserve_split | false | keep split direction |
| smart_split | false | cursor position (4 triangles) decides split; turns on preserve_split |
| smart_resizing | true | resize dir by mouse position vs tiling position |
| permanent_direction_override | false | preselect dir persists |
| special_scale_factor | 1 | scale of windows on special workspace [0-1] |
| split_width_multiplier | 1.0 | auto-split width multiplier (widescreen) |
| use_active_for_splits | true | active window vs mouse for splits |
| default_split_ratio | 1.0 | 1 = 50/50 [0.1-1.9] |
| split_bias | 0 | 0 directional (top/left); 1 current window |
| precise_mouse_move | false | bindm movewindow precision |
```

### Dwindle layout messages (`hl.dsp.layout(msg)`)

`splitratio` (float [0.1-1.9]; delta default, `+0.5`/`-0.5`, `exact` keyword), `togglesplit` (needs preserve_split), `swapsplit`, `rotatesplit [angle]` (multiple of 90, CW+), `preselect direction` (one-time override), `movetoroot [window, [unstable]]`.

Dispatcher: `hl.dsp.window.pseudo()` — `hl.bind("SUPER + P", hl.dsp.window.pseudo())`.

## Master — `hl.config({ master = {...} })`

Master window (default left) + slave stack on right; per-workspace orientation.

```
| Option | Default | Meaning |
|--------|---------|---------|
| mfact | 0.55 | master size % [0.0-1.0] |
| new_status | "slave" | "master"/"slave"/"inherit" |
| new_on_top | false | new window on stack top |
| new_on_active | "none" | "before"/"after"/"none" relative to focused |
| orientation | "left" | left/right/top/bottom/center |
| slave_count_for_center_master | 2 | center master only with ≥N slaves (0 = always) |
| center_master_fallback | "left" | fallback when fewer slaves |
| smart_resizing | true | mouse-position resize |
| drop_at_cursor | true | drag-drop at cursor |
| always_keep_position | false | keep master position with no slaves |
| focus_master_on_close | false | close → focus master |
```

### Master layout messages

`swapwithmaster [master/child/auto] [ignoremaster]`, `focusmaster [master/auto/previous]`, `cyclenext/cycleprev [loop/noloop]` (DWM-style), `swapnext/swapprev [loop/noloop]`, `addmaster`, `removemaster`, `orientationleft/right/top/bottom/center`, `orientationnext/prev`, `orientationcycle [values]`, `mfact [delta|exact]`, `rollnext/rollprev`.

Workspace rule: `hl.workspace_rule({ workspace = "2", layout_opts = { orientation = "top" } })`.

## Scrolling — `hl.config({ scrolling = {...} })`

Windows on infinitely growing tape.

```
| Option | Default | Meaning |
|--------|---------|---------|
| fullscreen_on_one_column | true | single column spans screen |
| focus_fit_method | 1 | 0 center, 1 fit |
| follow_focus | true | auto-scroll to focused window |
| follow_min_visible | 0.4 | min fraction visible for focus-follow |
| explicit_column_widths | "0.333, 0.5, 0.667, 1.0" | preconfigured widths for colresize ±conf |
| wrap_focus | true | focus l/r wraps |
| wrap_swapcol | true | swapcol wraps |
| direction | "right" | new windows/scroll direction |
```

### Scrolling layout messages

`colresize [value|+conf|-conf|all (number)]`, `fit [active/visible/all/toend/tobeg/expand]`, `fit_into_view`, `focus [dir]` (wraps), `promote` (window → own column), `swapcol l/r`, `inhibit_scroll [bool]` (per-workspace), `expel`, `consume`, `consume_or_expel prev/next`.

Window rule: `hl.window_rule({ match = { class = "kitty" }, scrolling_width = 0.5 })`.

**Layout Handled FS** — scrolling's own fullscreen handler: `layout_aware = true` (default) lets you scroll away from FS windows without unFSing.

## Monocle — windows fill entire space

**Quirk:** `hl.dsp.window.cycle_next()` does NOT work; use `hl.dsp.layout("cyclenext")` or `hl.dsp.window.cycle_next({ tiled = true })`.

Layout messages: `cyclenext`, `cycleprev` only.

## Summary

```
| Layout | Model | Distinction |
|--------|-------|-------------|
| Dwindle | binary tree | dynamic splits, default |
| Master | master+slave | configurable orientation/center |
| Scrolling | infinite tape | columns, FS handler |
| Monocle | single pane | full-bleed windows |
```

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Configuring/Layouts/ — Dwindle, Master, Scrolling, Monocle (2026-07-29), latest git
