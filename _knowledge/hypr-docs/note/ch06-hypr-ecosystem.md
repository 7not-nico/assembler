# ch06-hypr-ecosystem.md

**Source:** wiki.hypr.land/Hypr-Ecosystem/ (2026-07-29), Playwright snapshot — latest -git branch for all apps

## Overview

This wiki section hosts docs for various `hypr*` projects. Docs always target latest `-git` branch of respective apps. Each app has wiki page + GitHub repo (github.com/hyprwm/{repo}).

## User Apps and Utilities

```
| App | Repo | Role |
|-----|------|------|
| hyprpaper | hyprpaper | wallpaper daemon |
| hyprpicker | hyprpicker | color picker (Wayland) |
| hyprlauncher | hyprlauncher | app launcher |
| hypridle | hypridle | idle daemon (before lock) |
| hyprlock | hyprlock | screen locker |
| xdg-desktop-portal-hyprland | xdg-desktop-portal-hyprland | portal (screen sharing, file pickers) |
| hyprsysteminfo | hyprsysteminfo | system info utility |
| hyprsunset | hyprsunset | night light / blue light filter |
| hyprpolkitagent | hyprpolkitagent | polkit authentication agent (QT/QML) |
| hyprland-qt-support | hyprland-qt-support | Qt support for Hyprland |
| hyprqt6engine | hyprqt6engine | Qt6 theme engine |
| hyprpwcenter | hyprpwcenter | PipeWire center utility |
| hyprshutdown | hyprshutdown | shutdown wrapper utility |
```

## Dev Libraries and Toolkits

```
| Library | Repo | Role |
|---------|------|------|
| hyprtoolkit | hyprtoolkit | toolkit (has Development subpage) |
| hyprcursor | hyprcursor | cursor theme format/library |
| hyprutils | hyprutils | shared utilities library |
| hyprlang | hyprlang | config language library (legacy hyprlang — now Lua config) |
| hyprwayland-scanner | hyprwayland-scanner | Wayland protocol scanner |
| aquamarine | aquamarine | rendering backend library (replaced bundled wlroots) |
| hyprgraphics | hyprgraphics | graphics library |
| hyprland-guiutils | hyprland-guiutils | GUI utilities library |
```

## Notes

- **aquamarine** — since Hyprland PR #6608, used as rendering backend library; before, bundled own wlroots version
- **hyprlang** — legacy config language, deprecated since 0.55 in favor of Lua
- hyprtoolkit has a `development/` subpage — dev-oriented toolkit
- Ecosystem index also under `Useful-Utilities/Hypr-Ecosystem/` in wiki nav

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Hypr-Ecosystem/ (2026-07-29), Playwright snapshot — latest -git branch for all apps
