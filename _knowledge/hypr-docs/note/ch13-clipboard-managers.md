# ch13-clipboard-managers.md

**Source:** wiki.hypr.land/Useful-Utilities/Clipboard-Managers/ (2026-07-29), Playwright snapshot

**Starting method:** manual (hyprland config autostarts)

## Catalog

```
| Tool | Scope | Notes |
|------|-------|-------|
| cliphist | text, images, binary | wl-clipboard-based; the standard choice |
| clipman | text only | simple |
| clipvault | text, images, binary | cliphist alternative; max age for entries, min/max entry length |
| clipse | text, images | TUI in floating window; themes, previews, multi-select, pinned, auto-paste, sensitive handling |
| copyq | text, images, formats | searchable history, editing, scripting, tabs, cross-device sync |
| wl-clip-persist | clipboard persistence | keeps data after source app closes (Wayland quirk fix) |
| cursor-clip | text, images, files | Rust+GTK4+Libadwaita+Layer Shell; Win11-style overlay at cursor |
```

## Setup per tool

### cliphist
```sh
# autostarts
wl-paste --type text --watch cliphist store
wl-paste --type image --watch cliphist store
# bind (SUPER+V):
cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy
```

### clipman
```sh
wl-paste -t text --watch clipman store --no-persist
# primary clipboard variant:
wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"
# bind:
hl.bind("SUPER + V", hl.dsp.exec_cmd("clipman pick -t rofi"))
```

### clipvault
```lua
-- autostart
wl-paste --watch clipvault store
-- options: --min-entry-length 2 --max-entries 200 --max-entry-age 2d
-- bind:
clipvault list | rofi -dmenu -display-columns 2 | clipvault get | wl-copy
```

### clipse
```lua
-- autostart
clipse -listen
-- bind (kitty recommended for image rendering; float it):
hl.bind("SUPER + V", hl.dsp.exec_cmd("kitty --class clipse -e clipse", { float = true, size = {622, 652}, stay_focused = true }))
```

### copyq
```sh
copyq --start-server
# fix hide: Preferences → Layout → "Hide main window"
```

### wl-clip-persist
```sh
wl-clip-persist --clipboard regular
# primary selection possible but NOT recommended (GTK side-effects)
```

### cursor-clip
```sh
cursor-clip --daemon    # background daemon
cursor-clip             # bind to hotkey — overlay at mouse position
```

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Useful-Utilities/Clipboard-Managers/ (2026-07-29), Playwright snapshot
