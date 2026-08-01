# ch08-status-bars.md

**Source:** wiki.hypr.land/Useful-Utilities/Status-Bars/ (2026-07-29), Playwright snapshot

## Simple status bars

Config order/style of widgets, minimal coding.

### Waybar

GTK status bar, made for wlroots compositors, supports Hyprland by default.

**Setup:**
```sh
cp -r /etc/xdg/waybar/ ~/.config/waybar/
```
- Workspaces module: replace `sway/workspaces` → `hyprland/workspaces`; `sway/mode` → `hyprland/submap`
- Launch: `waybar` in terminal; add to hyprland autostarts for session start
- systemd: `systemctl --user enable --now waybar.service` (uwsm)

**FAQ fixes:**
- Active workspace not showing: `#workspaces button.focused` → `#workspaces button.active` in `~/.config/waybar/style.css`
- Scroll workspaces:
  ```json
  "hyprland/workspaces": {
      "format": "{icon}",
      "on-scroll-up": "hyprctl dispatch 'hl.dsp.focus({workspace=\"e+1\"})' ",
      "on-scroll-down": "hyprctl dispatch 'hl.dsp.focus({workspace=\"e-1\"})' ",
  }
  ```
- Window title missing: module prefix is `hyprland` not `wlr`: `"modules-center": ["hyprland/window"]`; multi-monitor: `"hyprland/window": { "separate-outputs": true }`
- Ref: github.com/Alexays/Waybar/wiki/Module:-Hyprland

### ashell

- Ready-to-go Wayland status bar for Hyprland (malpenzibo.github.io/ashell)
- Out-of-box modules: workspaces, time, battery, network
- Powered by iced (Rust GUI library)
- Limited config options — quick decent result, no waybar-alike tweaks

### Noctalia

- Minimal desktop shell for Wayland (noctalia.dev)
- Quickshell-based; theming with predefined schemes + auto color from wallpaper
- Notification system w/ history + Do Not Disturb; plugin support

## Widget systems

Custom menus, fully customizable layout, code required. Three popular choices:

```
| | AGS/Astal | EWW | Quickshell |
|--|-----------|-----|------------|
| UI toolkit | GTK 3/4 | GTK 3 | Qt |
| Config lang | JS(X)/TS/GObject-Introspection | Yuck (Lisp flavor) | QML |
| Hot reload | no (out of box) | — | yes, automatic |
| Pros | language flexibility, network+bluetooth libs | simple Lisp-like syntax, SCSS styling | advanced Hyprland integration (live window previews) |
| Cons | no hot reload OOB | external scripts reliance, GTK3 no GPU accel, performance | Qt less intuitive, no Wi-Fi service yet, alpha status, styles in components not CSS |
```

- **Astal** — suite/framework for desktop shells with GTK; **AGS** (Aylur's GTK Shell) — scaffolding tool for Astal in TS/JS(X)
- **EWW** — Rust+GTK widget system, independent of WM/compositor; install `eww-wayland`; read Wayland section of config carefully for Hyprland
- **Quickshell** — QtQuick-based shell toolkit, styleable independently

## Tips — blur

Layer rules `blur` + `ignore_alpha` (value > shadow opacity, < bar content opacity); `blur_popups` for transparent popups.

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Useful-Utilities/Status-Bars/ (2026-07-29), Playwright snapshot
