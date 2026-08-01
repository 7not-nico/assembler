# ch14-autostart.md

**Source:** wiki.hypr.land/Configuring/Basics/Autostart/ (2026-07-29), Playwright snapshot

## Autostart pattern

Execute things on the `hyprland.start` event via `hl.on`:

```lua
hl.on("hyprland.start", function ()
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("waybar & hyprpaper & firefox") -- Execute waybar, hyprpaper, firefox
end)
```

## Notes

- `hl.exec_cmd()` spawns **asynchronous** process — no `& disown` needed
- Exit hooks: `hyprland.shutdown` event
- `hl.on` detail: `Configuring/Advanced-and-Cool/Expanding-functionality`
- User services: `Useful-Utilities/Systemd-start#autostart` (systemd-based)

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Configuring/Basics/Autostart/ (2026-07-29), Playwright snapshot
