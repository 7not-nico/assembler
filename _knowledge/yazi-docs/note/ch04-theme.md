# ch04-theme.md

**Source:** https://yazi-rs.github.io/docs/configuration/theme (2026-07-31), 26.5.6

## Style type

`{ fg = "", bg = "black", ... }` properties: fg, bg (Color); bold, dim, italic, underline, blink, blink_rapid, reversed, hidden, crossed (Boolean).

## [flavor]

- `dark` — flavor name for dark mode (e.g. "dracula")
- `light` — flavor name for light mode (e.g. "gruvbox")
- Flavors own their tmTheme files (`tmtheme.xml`) — `syntect_theme` not available when flavor active
- Ready-made: yazi-rs/flavors

## Sections

```
| Section | Key styles |
|---------|-----------|
| [app] | `overall` (bg only, needs OSC 11 terminal support) |
| [mgr] | `cwd`, `find_keyword`, `find_position`, `symlink_target`, `marker_copied/cut/marked/selected`, `count_copied/cut/selected`, `border_symbol`, `border_style`, `syntect_theme` (path to .tmTheme) |
| [indicator] | `parent`, `current`, `preview`, `padding` (e.g. `{ open = "▐", close = "▌" }`) |
| [tabs] | `active`, `inactive`, `sep_inner`, `sep_outer` |
| [mode] | `normal_main`, `normal_alt`, `select_main`, `select_alt`, `unset_main`, `unset_alt` |
| [status] | `overall`, `sep_left`, `sep_right`, `perm_type` (d/-/l), `perm_read/write/exec`, `perm_sep`, `progress_label`, `progress_normal`, `progress_error` |
| [which] | `cols`, `mask`, `cand`, `rest`, `desc`, `separator`, `separator_style` |
| [confirm] | `border`, `title`, `body`, `list`, `btn_yes`, `btn_no`, `btn_labels` |
| [spot] | `border`, `title`, `tbl_col`, `tbl_cell` |
| [notify] | `title_info`, `title_warn`, `title_error` |
| [pick] | `border`, `active`, `inactive` |
| [input] | `border`, `title`, `value`, `selected` |
| [cmp] | `border`, `active`, `inactive`, `icon_file`, `icon_folder`, `icon_command` |
| [tasks] | `border`, `title`, `hovered` |
| [help] | `on`, `run`, `desc`, `hovered`, `footer`, `icon_info`, `icon_warn`, `icon_error` |
```

## [filetype]

File list item display styles per type — match by name and mime-type.

## [icon]

Icon rules; falls back to `conds` for metadata-based conditions (file metadata conditional factors).

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: https://yazi-rs.github.io/docs/configuration/theme (2026-07-31), 26.5.6
