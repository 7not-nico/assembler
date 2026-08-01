# ch01-overview.md

**Source:** https://yazi-rs.github.io/ (2026-07-31), version 26.5.6

## Core identity

Yazi — blazing-fast terminal file manager written in Rust, based on async I/O. Vim-style keybindings, image preview, plugin ecosystem. Public beta, daily-driver capable; heavy development, expect breaking changes.

## Config files (3 + extras)

```
| File | Purpose |
|------|---------|
| `yazi.toml` | general configuration |
| `keymap.toml` | keybindings |
| `theme.toml` | color scheme |
| `init.lua` | plugin initialization (runs on startup) |
| `package.toml` | plugin/flavor registry (installed packages) |
| `vfs.toml` | virtual filesystem config |
```

Default configs: github.com/sxyazi/yazi/tree/shipped/yazi-config/preset (shipped tag).

**Locations:** `~/.config/yazi/` (Unix), `%AppData%\yazi\config\` (Windows).

## Config mixing

- Options override defaults (don't copy whole file unless full overwrite)
- Keymaps: `prepend_keymap` (higher priority than default) / `append_keymap` (lower priority) — Yazi runs first matching key
- Also available for open/icon/previewer/preloader rules
- `YAZI_CONFIG_HOME` env var → custom config dir (own yazi.toml, keymap.toml, init.lua)

## Image preview

- Protocols per platform: Chafa (character-based, macOS auto), Überzug++ (Linux real image quality)
- `yazi --clear-cache` after preview changes
- tmux passthrough: `set -g allow-passthrough on` + TERM/TERM_PROGRAM update

## Package manager

- 26.x: `ya pkg add/list/upgrade/delete/install` (old `ya pack` deprecated)
- Plugins: `ya pkg add yazi-rs/plugins:git`
- Flavors (themes): `ya pkg add yazi-rs/flavors:catppuccin-mocha`; set in theme.toml `[flavor] dark/light`
- Recorded in `~/.config/yazi/package.toml`

## Ecosystem

- Plugins monorepo: yazi-rs/plugins (~18 official); 150+ community (awesome-yazi)
- Flavors: yazi-rs/flavors
- Community: Discord (EN), Telegram (CN)
- Integrations: yazi.nvim, lazygit.yazi, starship.yazi

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: https://yazi-rs.github.io/ (2026-07-31), version 26.5.6
