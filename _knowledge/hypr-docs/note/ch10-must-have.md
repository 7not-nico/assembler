# ch10-must-have.md

**Source:** wiki.hypr.land/Useful-Utilities/Must-have/ (2026-07-29), Playwright snapshot

Strongly recommended software for smooth Hyprland experience. DEs (Plasma/GNOME) handle these automatically; Hyprland does not.

```
| Component | Starting method | Notes |
|-----------|----------------|-------|
| **Notification daemon** | auto via D-Bus activation on notification; or autostart in `hyprland.lua` (preferable with multiple daemons) | many apps (Discord) freeze without one; examples: dunst, **mako**, fnott, swaync |
| **PipeWire** | auto on systemd, manual otherwise | screensharing needs it; install `pipewire` + `wireplumber` (NOT `pipewire-media-session`); non-systemd distros: `<distro>-pipewire-launcher` (e.g. Gentoo OpenRC, Artix) |
| **XDG Desktop Portal** | auto on systemd, manual otherwise | file pickers, screensharing; see Hypr-Ecosystem/xdg-desktop-portal-hyprland |
| **Authentication agent** | manual (autostart in config) | password popups for privilege elevation; see hyprpolkitagent |
| **Qt Wayland Support** | none (library) | install `qt5-wayland` + `qt6-wayland` |
| **Fonts** | none (library) | `sans-serif` required (squares otherwise); `noto-fonts` common; Nerd Font for icons (default if available, then FontAwesome, then text) |
```

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Useful-Utilities/Must-have/ (2026-07-29), Playwright snapshot
