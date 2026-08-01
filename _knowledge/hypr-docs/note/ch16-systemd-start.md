# ch16-systemd-start.md

**Source:** wiki.hypr.land/Useful-Utilities/Systemd-start/ (2026-07-29), Playwright snapshot

## UWSM (Universal Wayland Session Manager)

Wraps standalone Wayland compositors into systemd units. Session management: environment, XDG autostart, bi-directional binding with login session, clean shutdown. **Advanced users only** — has quirks.

### Launch in tty (shell profile)

```sh
if uwsm check may-start && uwsm select; then exec uwsm start default; fi
# direct launch (bypass menu):
if uwsm check may-start; then exec uwsm start hyprland.desktop; fi
```

Display manager: choose `Hyprland (uwsm-managed)` entry.

### Applications in session

Prefix with `uwsm app --` (also Desktop Entries by ID/path; see `man uwsm`, `uwsm app --help`). Running apps as children of compositor unit discouraged.

Faster alternatives: `uwsm-app` (shell client + daemon), `app2unit` (pure shell, file opener), `runapp` (C++).

## hyprland-session.target (minimal alternative)

Wayland compositor expected to tell systemd it's a graphical session. Minimal way to start `graphical-session.target` without UWSM. Autostarts user services (bars, notification daemons); XDG Desktop Portal (XDPH) may refuse to start without it.

```sh
systemctl --user edit --full --force hyprland-session.target
```
```ini
[Unit]
Description=Hyprland session
BindsTo=graphical-session.target
Wants=graphical-session-pre.target
After=graphical-session-pre.target
PropagatesStopTo=graphical-session.target
```

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)
hl.on("hyprland.shutdown", function()
    os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)
```

## Autostart

- XDG Autostart handled by systemd; target activated automatically in uwsm sessions
- Native units: `systemctl --user enable [app].service`; no `[Install]` → `systemctl --user add-wants graphical-session.target [app].service`; ensure `After=graphical-session.target`
- Example: `systemctl --user enable hyprpaper.service` replaces `hl.exec_cmd("hyprpaper")`
- More: github.com/Vladimir-csp/uwsm/tree/master/example-units

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Useful-Utilities/Systemd-start/ (2026-07-29), Playwright snapshot
