# conventions.md

**Source:** compiled from yazi-rs.github.io docs ch01-ch05 (2026-07-31), 26.5.6

## Config layout

```
~/.config/yazi/
├── yazi.toml      # general config
├── keymap.toml    # keybindings (8 layers)
├── theme.toml     # colors
├── init.lua       # plugin init (sync)
├── package.toml   # installed packages
├── vfs.toml       # virtual filesystem
└── plugins/*.yazi/
```

Defaults: `sxyazi/yazi` shipped tag, `yazi-config/preset`. Override by copying the needed part only.

## Config conventions

- **Mixing** — user options override defaults; `prepend_*` (higher priority) / `append_*` (lower) for keymaps, open rules, icons, previewers, preloaders
- **First-match wins** — Yazi runs the first matching key
- `YAZI_CONFIG_HOME` env — custom config dir
- Clear cache after preview changes: `yazi --clear-cache`

## yazi.toml surface

```
| Section | Key options |
|---------|-------------|
| `[mgr]` | ratio [parent,current,preview], sort_by (natural/alpha/size/modified/birth/extension), sort_*, linemode, show_hidden, show_symlink, scrolloff, mouse_events |
| `[preview]` | wrap, tab_size, max_width/height, cache_dir, image_delay, image_filter, image_quality, ueberzug_scale/offset |
| `[opener]` | run, desc, for (unix/macos/windows), block; `%s`/`%S` single, `%d`/`%D` dirnames, `%dN`/`%DN` N-th, `%%` escape |
| `[open]` | prepend_rules/append_rules — mime → use ["edit","open","reveal"] |
| `[tasks]` | *_workers (file/plugin/fetch/preload/process), bizarre_retry, suppress_preload, image_alloc/bound |
| `[plugin]` | fetchers/previewers/preloaders; bridges: folder, code, json (jq), noop, image, video (ffmpeg), pdf (pdftoppm) |
| `[input]` | cursor_blink, offset (x,y,w,h), placeholder |
```

## keymap.toml surface

- Layers: mgr, tasks, spot, pick, input, confirm, cmp, help
- Key notation: `<C-a>`, `<A-*>`, sequences `["g","b"]`, per-OS binds
- mgr actions: arrow (prev/next wrap), seek, visual_mode, open (--interactive/--hovered), noop (disable key), cd, follow, reveal, yank, paste, link, hardlink, remove, create, rename, copy, spot, escape, quit, suspend
- Defaults: `;` shell async, `:` shell blocking, `,m/,b/,e/,a/,n/,s` sort (+SHIFT reverse), `t`/`1-9`/`[]`/`{}` tabs, `w` tasks, `~`/F1 help, `q` quit-write-CWD, `Q` quit-no-write, `.` hidden, `Z` zoxide, `S` ripgrep

## theme.toml surface

- Style type: `{ fg, bg, bold, dim, italic, underline, blink, blink_rapid, reversed, hidden, crossed }`
- `[flavor]` dark/light; flavors own tmTheme (`tmtheme.xml`)
- Sections: app, mgr, indicator, tabs, mode, status, which, confirm, spot, notify, pick, input, cmp, tasks, help, filetype (name/mime match), icon (metadata conds)

## Plugins

- Structure: `plugins/{name}.yazi/{main.lua, README.md, LICENSE}`
- Async-first; `@sync` for sync; `init.lua` synchronous
- `ya.pkg` (26.x): add/list/upgrade/delete/install; `ya pack` deprecated
- Debug: `ya.dbg()`/`ya.err()` → yazi.log; `YAZI_LOG` env

## Ecosystem

- Official plugins: yazi-rs/plugins; flavors: yazi-rs/flavors; community: awesome-yazi
- Community: Discord (EN), Telegram (CN)
