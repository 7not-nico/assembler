# ch05-ipc.md

**Source:** wiki.hypr.land/IPC/, /Configuring/Advanced-and-Cool/Using-hyprctl/ (2026-07-30), latest git — post-0.55 Lua

## Two UNIX sockets

Per-instance, under `$XDG_RUNTIME_DIR/hypr/[HIS]/` where HIS = `$HYPRLAND_INSTANCE_SIGNATURE`:

```
| Socket | Purpose | Protocol |
|--------|---------|----------|
| `.socket.sock` | hyprctl-like requests | synchronous — write `[flag(s)]/command args` |
| `.socket2.sock` | events broadcast | `EVENT>>DATA\n` e.g. `workspace>>2` |
```

**Sync warning** — `.socket.sock` connections evaluated synchronously; unclosed connections freeze Hyprland until 5s timeout. Open immediately, write, close.

## socket2 events (v1/v2 pairs)

```
| Event | Data |
|-------|------|
| workspace / workspacev2 | WORKSPACENAME / ID,NAME (user-requested changes only) |
| focusedmon / focusedmonv2 | MONNAME,WORKSPACENAME / MONNAME,WORKSPACEID |
| activewindow / activewindowv2 | CLASS,TITLE / ADDRESS |
| fullscreen | 0 exit / 1 enter |
| monitorremoved / added (+v2) | NAME / ID,NAME,DESC |
| createworkspace / destroyworkspace (+v2) | NAME / ID,NAME |
| moveworkspace (+v2) | NAME,MONNAME / ID,NAME,MONNAME |
| renameworkspace | ID,NEWNAME |
| activespecial (+v2) | NAME,MONNAME (closing = empty) |
| activelayout | KEYBOARDNAME,LAYOUTNAME |
| openwindow | ADDRESS,WORKSPACENAME,CLASS,TITLE |
| closewindow / kill | ADDRESS |
| movewindow (+v2) | ADDRESS,WORKSPACENAME / +ID |
| openlayer / closelayer | NAMESPACE |
| submap | SUBMAPNAME (empty = default) |
| changefloatingmode | ADDRESS,0/1 |
| urgent | ADDRESS |
| screencast (+v2) | STATE,OWNER / +NAME |
| windowtitle (+v2) | ADDRESS / ADDRESS,TITLE |
| togglegroup | state,handles e.g. `0,64cea2525760,64cea2522380` |
| moveintogroup / moveoutofgroup | ADDRESS |
| ignoregrouplock / lockgroups | 0/1 |
| configreloaded | empty |
| pin | ADDRESS,PINSTATE |
| minimized | ADDRESS,0/1 |
| bell | ADDRESS (may be empty) |
```

### socket2 + bash

```sh
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
  case $line in monitoradded*) ... ;; focusedmon*) ... ;; esac
done
```

## hyprctl

CLI utility, ships with Hyprland. Synchronous — spam causes slowdowns. Use `--batch` for control calls; limit info calls.

### Control commands

```
| Command | Purpose |
|---------|---------|
| `eval 'lua'` | execute Lua dynamically, returns ok/error — full `hl` access |
| `repl [code]` | interactive Lua REPL; `tostring` output; Ctrl+D exit |
| `dispatch` | shorthand for `eval 'hl.dispatch(...)'` |
| `reload` / `reload full-reset` | force config reload; full-reset recreates entire config context (lua↔hyprlang switch; use sparingly) |
| `kill` | xkill mode; click to kill; ESCAPE exits |
| `setcursor` | set cursor theme (0.37+: hyprcursor only; XCursor via env vars) |
| `output create/remove [backend] (name)` | fake outputs; backends: wayland, headless, auto |
| `switchxkblayout [device] next/prev/[id]` | XKB layout switch; device = name/`current`/`all` |
| `seterror` | set custom error |
| `getprop [window] [property]` | get window property |
| `notify` / `dismissnotify` | built-in notifications; ICON 0-5/-1, TIME_MS, COLOR, `fontsize:N` prefix |
```

### Info commands

`version`, `monitors` (`monitors all` incl. inactive), `workspaces`, `activeworkspace`, `workspacerules`, `clients`, `devices`, `binds`, `activewindow`, `layers`, `getoption section.option` (e.g. `general.border_size`, `input.touchpad.disable_while_typing`), `cursorpos`, `instances`, `layouts` (incl. plugin layouts), `rollinglog` (`-f` follow), `descriptions` (JSON of all options).

### Flags

`-j` JSON output; `-i [instance]` select instance (id or index); `-r` force state refresh after commands (layout/rule changes).

### Batch

`hyprctl --batch "cmd1 ; cmd2"` — legacy flag, `;`-separated. Reduces IPC overhead.

## Notes

- `hl.dsp.event(string)` — dispatcher sends events to socket2
- `hl.dsp.global(string)` — activate dbus global shortcut

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/IPC/, /Configuring/Advanced-and-Cool/Using-hyprctl/ (2026-07-30), latest git — post-0.55 Lua
