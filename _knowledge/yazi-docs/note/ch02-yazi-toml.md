# ch02-yazi-toml.md

**Source:** https://yazi-rs.github.io/docs/configuration/yazi (2026-07-31), 26.5.6

## [mgr] — manager

```
| Option | Description |
|--------|-------------|
| `ratio` | layout ratio, 3-element array `[1, 4, 3]` (parent/current/preview); 0 hides a panel (≥1 visible) |
| `sort_by` | natural / alphabetical / size / modified / birth / extension |
| `sort_sensitive`, `sort_reverse`, `sort_dir_first` | sorting flags |
| `sort_translit` | transliteration sort |
| `linemode` | size / permissions / etc. |
| `show_hidden` | toggle hidden files |
| `show_symlink` | symlink display |
| `scrolloff` | scroll offset |
| `mouse_events` | `["click", "scroll"]` |
```

## [preview]

`wrap`, `tab_size`, `max_width`, `max_height`, `cache_dir`, `image_delay`, `image_filter` (e.g. lanczos3), `image_quality`, `ueberzug_scale` / `ueberzug_offset` (Linux overlay tuning).

## [opener]

Openers with `%` substitution:
- `%s` — single path, `%S` — URL form
- `%d`/`%D` — dirnames of all selected; `%dN`/`%DN` — N-th selected
- `%%` — literal `%`
- `block` — blocking open
- Fields: `run`, `desc`, `for` (unix/macos/windows), `block`

Example:
```toml
[opener]
edit = [{ run = 'code %s', desc = "VSCode", for = "unix" }]
```

## [open]

`prepend_rules` / `append_rules` — mime-type → opener mapping:
```toml
[open]
prepend_rules = [
  { mime = "text/*", use = ["edit", "open", "reveal"] },
]
```

## [tasks]

`file_workers`, `plugin_workers`, `fetch_workers`, `preload_workers`, `process_workers`, `bizarre_retry`, `suppress_preload`, `image_alloc`, `image_bound`.

## [plugin]

Fetchers / previewers / preloaders (bridges):
- `folder` — filesystem → preview
- `code` — built-in code highlighting (async concurrent)
- `json` — `jq` bridge
- `noop` — no operation
- `image` — built-in image preview presentation layer
- `video` — `ffmpeg` bridge
- `pdf` — `pdftoppm` bridge

Fetcher example:
```toml
[plugin]
prepend_fetchers = [
  { id = "git", mime = "*", run = "git", prio = "normal", group = "file" },
]
```

## [input]

`cursor_blink`, Origin, `offset` (4-element tuple x,y,width,height), Placeholder.

## Other sections

`[confirm]`, `[pick]`, `[which]` (`sort_by`, `sort_sensitive`, `sort_reverse`, `sort_translit`).

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: https://yazi-rs.github.io/docs/configuration/yazi (2026-07-31), 26.5.6
