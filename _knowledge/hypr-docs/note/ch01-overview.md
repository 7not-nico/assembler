# ch01-overview.md

**Source:** https://hypr.land/ (2026-07-30), cross-ref ArchWiki Hyprland, wiki.hypr.land

## Core identity

Hyprland — independent dynamic-tiling Wayland compositor, written in modern C++, custom renderer. Independent implementation — does not rely on wlroots; uses aquamarine as rendering backend library (since PR #6608). Emphasis: looks, smoothness, lightweight responsiveness.

## Configuration state (2026-07)

Since Hyprland 0.55, hyprlang is deprecated in favor of **Lua**. Config located at `$XDG_CONFIG_HOME/hypr/hyprland.lua` → `~/.config/hypr/hyprland.lua` in most cases. Override with `--config`/`-c` argument. Support for `hyprland.conf` removed in future release.

## Feature set

```
| Feature | Detail |
|---------|--------|
| Smooth | transitions, animations, performance |
| Easy to configure | live reloading config, sensible defaults |
| Dynamic tiling | automatic tiling, multiple fine-tuneable layouts, more via plugins |
| Socket-based IPC | runtime control via UNIX socket |
| Window groups | tabbed/grouped windows |
| Special workspaces | scratchpad-like workspaces |
| Global shortcuts | global keybinds for apps (e.g. OBS) |
| Touchpad gestures | gestures config |
| Tearing support | `Configuring/Advanced-and-Cool/Tearing/` |
| Plugins | hypractive development, plugin ecosystem |
```

## Site structure (hypr.land)

Nav: Get started → wiki Master-Tutorial; Wiki; Forums; Account; Hall of fame; News; Plugins; Support; Install.

## Ecosystem (from ArchWiki cross-ref)

- `hyprctl` — CLI utility, communicates with display server (dispatch, keywords, queries)
- 2 UNIX sockets — events on focus change, windows, workspaces, monitors
- First-party Hypr\* tools — hyprpaper, hypridle, hyprlock, hyprpolkitagent, hyprpm (plugin manager)
- ecosystem page: `wiki.hypr.land/Hypr-Ecosystem/`

## Session startup

- `uwsm` — wraps compositor + apps via systemd units; Hyprland no longer recommends uwsm (experimental)
- `start-hyprland` wrapper — provides crash recovery and safe mode (new recommendation)
- Display manager not officially supported; GDM/SDDM reported working

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: https://hypr.land/ (2026-07-30), cross-ref ArchWiki Hyprland, wiki.hypr.land
