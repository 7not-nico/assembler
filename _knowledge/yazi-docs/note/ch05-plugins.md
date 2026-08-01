# ch05-plugins.md

**Source:** https://yazi-rs.github.io/docs/plugins/overview, /docs/tips (2026-07-31), 26.5.6 — Plugins BETA

## Structure

Plugins live in `~/.config/yazi/plugins/` (Unix) or `%AppData%\yazi\config\plugins\` (Windows):

```
~/.config/yazi/
├── init.lua
├── plugins/
│   ├── foo.yazi/
│   └── bar.yazi/
└── yazi.toml
```

Each plugin: kebab-case dir ending `.yazi` with `main.lua` (entry), `README.md`, `LICENSE`.

## Two usages

1. **Functional** — bind `plugin` action in keymap.toml; `[name]` required, `[args]` shell-style (positional + `--named`, no `-a` shorthand)
2. **Previewers/preloaders** — configure under `[plugin]` in yazi.toml

## Sync vs Async

- **Async-first** — all plugins run async unless `@sync` annotation
- **Sync context** — active during UI rendering (UI plugins) and sync functional plugins; `init.lua` is synchronous (configures plugins)
- `ya.sync()` — get/set plugin state across async/sync boundary

```lua
-- init.lua
require("my-plugin"):setup { key1 = "value1", key2 = "value2" }
```

```lua
-- plugins/my-plugin.yazi/main.lua
return { setup = function(state, opts)
    state.key1 = opts.key1
    state.key2 = opts.key2
end }
```

## Interfaces

- Preloader: return table implementing `preload(job)` method → returns `false, Err(...)` on error
- Job args: `job.args[1]` positional, `job.args.bar` named

## Ownership

Userdata = native Rust types with own ownership — safe/efficient cross-thread transfer (Url etc.), no memory reallocation.

## Debugging

- `ya.dbg()` / `ya.err()` → `~/.local/state/yazi/yazi.log` (Unix), `%AppData%\yazi\state\yazi.log` (Win)
- `YAZI_LOG` env var before start
- Valid `init.lua` syntax required — Yazi can't parse otherwise
- Lua LSP: VSCode sumneko.lua / Neovim nvim-lspconfig
- Debug preset plugins: clone source, edit `yazi-plugin/preset`, build debug, run with YAZI_LOG

## Tips (plugin examples)

```
| Tip | Pattern |
|-----|---------|
| Smart tab | `ya.emit("tab_create", ...)` on hovered dir |
| Smart switch | create tab if target missing |
| Folder-specific rules | per-dir sort; `require("folder-rules"):setup()` |
| Parent nav | navigate parent without leaving CWD |
| Confirm quit | multi-tab quit guard |
| Status bar symlink | `Status:children_add(fn, 3300, Status.LEFT)` |
| Header user@host | `Header:children_add(fn, 500, Header.LEFT)`; `ui.Span(...):fg("blue")` |
```

## Ecosystem

- `ya pkg add yazi-rs/plugins:git` — official monorepo
- `ya pkg list/upgrade/delete/install` — 26.x package manager
- awesome-yazi — 150+ community plugins

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: https://yazi-rs.github.io/docs/plugins/overview, /docs/tips (2026-07-31), 26.5.6 — Plugins BETA
