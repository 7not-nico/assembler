# ch02-wiki-structure.md

**Source:** https://wiki.hypr.land/ (2026-07-30)

## Wiki facts

- Wiki is **versioned** — defaults to latest git commit; use version selector for tagged releases (`hyprctl version` checks running release)
- Content source: github.com/hyprwm/hyprland-wiki (edit via GitHub)
- Last updated 2026-07-29

## Wiki navigation tree

```
| Category | Sections |
|----------|----------|
| Getting Started | Installation, Master Tutorial, Preconfigured setups |
| Configuring | Basics (Variables, Dispatchers, Binds), Advanced-and-Cool (Tearing), Using hyprctl |
| IPC | 2 UNIX sockets, events |
| Hypr Ecosystem | hyprlock, xdg-desktop-portal-hyprland, hyprsysteminfo, hyprsunset, hyprpolkitagent, hyprland-qt-support, hyprqt6engine, hyprpwcenter, hyprshutdown, hyprtoolkit |
| Development | hyprcursor, hyprutils, hyprlang, hyprwayland-scanner, aquamarine, hyprgraphics, hyprland-guiutils |
| Useful Utilities | Must have, Status bars, Wallpapers, Screen sharing, Screenshots & Recording, App launchers, App clients, Phone connect, Color pickers, Clipboard Managers, File Managers, Other |
| Plugins | Using plugins, Development (Getting started, Plugin guidelines), Advanced |
| Nix | Hyprland on NixOS, Other Distros, Home Manager, Cachix, Options & Overrides, Plugins |
| Contributing & Debugging | Nvidia, IPC, Crashes and Bugs, FAQ, Connect; Issue Guidelines, PR Guidelines, Tests, Translations |
```

## Study decomposition (anchors)

1. **Configuring** — variables, dispatchers, binds, window rules (hyprlang → Lua)
2. **IPC** — sockets, hyprctl, events
3. **Hypr Ecosystem** — first-party tools
4. **Plugins** — hyprpm, development
5. **Utilities** — status bars, launchers, wallpaper (waybar, walker, mako, kitty integration)
6. **Nix** — packaging, home-manager

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: https://wiki.hypr.land/ (2026-07-30)
