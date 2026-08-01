# conventions.md

**Source:** compiled from wiki.hypr.land notes ch01-ch16 (2026-07-30), latest git — post-0.55 Lua config

## Config file

`~/.config/hypr/hyprland.lua` — live reload on save; `hyprctl reload`; `--config`/`-c` override. Multi-file via `require()`. LSP stubs at `/usr/share/hypr/stubs/`.

## Lua API surface (`hl.*`)

```
| Call | Purpose |
|------|---------|
| `hl.config({ section = {...} })` | config sections: general, decoration, input, misc, layout, binds, cursor, dwindle, master, scrolling, plugin |
| `hl.bind(keys, dispatcher, flags?)` | keybinding; flags: locked, release, non_consuming, auto_consuming, mouse, long_press, description, device |
| `hl.dispatch(dispatcher)` | runtime dispatch |
| `hl.dsp.*` | dispatcher table constructors |
| `hl.window_rule({...})` | window rules; returns handle (`set_enabled`/`is_enabled`) |
| `hl.layer_rule({...})` | layer rules (bars); handle API |
| `hl.workspace_rule({...})` | workspace rules |
| `hl.monitor({...})` | monitor config |
| `hl.on(event, fn)` | event listeners; `hyprland.start`, `hyprland.shutdown` |
| `hl.exec_cmd(cmd)` | async process spawn (no `& disown` needed) |
| `hl.timer(fn, {timeout, type})` | timers |
| `hl.define_submap(name, fn)` | submaps |
| `hl.permission(path, op, allow)` | permission rules (e.g. hyprpm) |
| `hl.plugin.*` | plugin APIs (guard with `~= nil`) |
| `os.execute()` | blocking exec (shutdown hooks) |
```

## Key syntax

- Mods: `SUPER`, `SHIFT`, `ALT`, `CTRL`, combined `SUPER + SHIFT + Q`
- Keycodes: `code:28`; mouse: `mouse:272/273/276`; wheel: `mouse_up/down/left/right`
- Modkey-only: target modmask + `release` flag (e.g. `ALT + ALT_L`)

## Window selection (dispatcher params + rules)

`class:`, `initialclass:`, `title:`, `initialtitle:`, `tag:`, `pid:`, `stableid:`, `address:0x...`, `activewindow`, `floating`, `tiled` — default active window.

## Fullscreen state values

`-1` current, `0` none, `1` maximized (margins kept), `2` fullscreen (whole screen). Decoupled: `fullscreen_state_internal` (Hyprland) vs `fullscreen_state_client` (app-received).

## Event model (socket2)

`EVENT>>DATA\n` format; v2 events carry IDs. Key events: workspace, focusedmon, activewindow, openwindow, closewindow, fullscreen, monitoradded/removed, activespecial, submap, screencast, togglegroup, configreloaded, pin, bell.

## IPC

- `.socket.sock` — sync hyprctl requests (open-write-close; 5s freeze risk)
- `.socket2.sock` — events (socat pattern)
- hyprctl: `eval`, `repl`, `dispatch`, `reload [full-reset]`, `kill`, `setcursor`, `output create/remove`, `switchxkblayout`, `getprop`, `notify/dismissnotify`; info: version, monitors, workspaces, clients, devices, binds, layers, getoption, cursorpos, instances, layouts, rollinglog, descriptions
- Flags: `-j` JSON, `-i` instance, `-r` state refresh; `--batch "a ; b"`

## Layouts

`general.layout`: dwindle (default), master, scrolling, monocle. Per-workspace via `workspace_rule.layout` or `layout_opts`. Layout messages via `hl.dsp.layout(msg)` — layout-specific (see ch15).

## Ecosystem autostart pattern

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
```

## Versioning

Wiki versioned — latest git by default; tagged releases via version selector. 0.55+ = Lua. `hyprctl version` checks running build.
