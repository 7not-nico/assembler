# use-hyprctl.md

**Composes with:** note/ch05-ipc.md, precept/cite-versioned-wiki.md

Control and query Hyprland at runtime via hyprctl. Synchronous — batch control calls, limit info calls.

## Query state

1. Version/build: `hyprctl version`
2. Monitors: `hyprctl monitors` / `hyprctl monitors all` (inactive too)
3. Windows: `hyprctl clients` — address, class, title (match verification)
4. Workspaces: `hyprctl workspaces`, `hyprctl activeworkspace`
5. Devices: `hyprctl devices` (keyboards, mice, tablets)
6. Binds: `hyprctl binds` — conflict check
7. Config options: `hyprctl getoption general.border_size` (section.option)
8. JSON output: `-j` flag — scriptable

## Control

9. Reload config: `hyprctl reload`; full context reset: `hyprctl reload full-reset` (sparingly)
10. Dynamic Lua: `hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = "3" }))'`
11. Interactive: `hyprctl repl` — explore API; `hyprctl repl [code]` — print result
12. Kill mode: `hyprctl kill` — click to kill; ESCAPE exits
13. Cursor theme: `hyprctl setcursor [theme]`
14. Notify: `hyprctl notify [icon] [time_ms] [color] [message]` — icons 0-5/-1

## Batch

15. Multiple control calls: `hyprctl --batch "cmd1 ; cmd2"` — reduce IPC overhead
16. Instance selection: `-i [instance]`; list with `hyprctl instances`
17. Force state refresh: `-r` flag after layout/rule changes

## Script integration

18. Events: socket2 via socat (see ch05) — subscribe for live changes
19. Waybar scroll (ch08):
    ```json
    "on-scroll-up": "hyprctl dispatch 'hl.dsp.focus({workspace=\"e+1\"})' "
    ```
20. Verify window class before pass binds: `hyprctl clients`
