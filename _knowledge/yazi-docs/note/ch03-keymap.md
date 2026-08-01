# ch03-keymap.md

**Source:** https://yazi-rs.github.io/docs/configuration/keymap (2026-07-31), 26.5.6

## 8 layers

```
| Layer | Component |
|-------|-----------|
| `[[mgr]]` | file list |
| `[[tasks]]` | task manager |
| `[[spot]]` | file info spotter |
| `[[pick]]` | pick component ("open with") |
| `[[input]]` | input component (create, rename) |
| `[[confirm]]` | confirmation dialog (remove, overwrite) |
| `[[cmp]]` | completion component ("cd" URL completion) |
| `[[help]]` | help menu |
```

## Attributes per layer

`prepend_keymap` (before defaults — higher priority) / `append_keymap` (after defaults — lower priority). Yazi runs first matching key.

```toml
[mgr]
prepend_keymap = [
  { on = "<C-a>", run = "act1", desc = "Single action with Ctrl + a" },
]
append_keymap = [
  { on = ["g", "b"], run = "act2", desc = "Single action with g ⇒ b" },
  { on = "c", run = ["act1", "act2"], desc = "Multiple actions with c" },
]
```

## Key notation

- `<C-a>` — Ctrl+a; `<A-*>` alt; sequence arrays `["g", "b"]` — press g then b
- Per-OS keybindings supported

## Key actions (mgr)

```
| Action | Description |
|--------|-------------|
| `arrow` | move cursor; `arrow prev`/`next` wrap-around vs `arrow -1`/`1` |
| `seek [n]` | scroll preview; negative up / positive down |
| `visual_mode [--unset]` | enter selection mode |
| `open [--interactive] [--hovered]` | open via `[open]` rules; interactive chooser; hovered override |
| `noop` | disable key — no action, hidden from `which` |
| `escape`, `quit`, `close`, `suspend`, `leave`, `enter`, `back`, `forward`, `spot`, `cd`, `follow`, `reveal`, `toggle`, `toggle_all`, `yank`, `unyank`, `paste`, `link`, `hardlink`, `remove`, `create`, `rename`, `copy` | file ops |
```

## Default keybinds (from preset)

- `;` shell non-blocking, `:` shell blocking (`--block`)
- `,m/,b/,e/,a/,n/,s` + SHIFT reverse — sort by modified/birth/extension/alpha/natural/size
- `t` new tab; `1-9` switch; `[`/`]` prev/next tab; `{`/`}` swap tabs
- `<C-c>` close tab; `w` task manager; `~`/`F1` help; `q` quit (write CWD); `Q` quit no-write
- `.` toggle hidden; `Z` zoxide; `S` ripgrep search

## noop pattern

```toml
[[mgr.prepend_keymap]]
on = ["g", "c"]
run = ["noop"]   # array must be single-element "noop"
```

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: https://yazi-rs.github.io/docs/configuration/keymap (2026-07-31), 26.5.6
