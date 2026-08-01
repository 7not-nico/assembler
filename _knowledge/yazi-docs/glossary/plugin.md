# plugin

A plugin is a Lua extension directory for Yazi, named kebab-case ending `.yazi`.

Located at `~/.config/yazi/plugins/{name}.yazi/` with `main.lua` (entry), `README.md`, `LICENSE`. Two usages: functional (bound to a key via `plugin` action) and previewers/preloaders (configured under `[plugin]` in yazi.toml). Async-first; `@sync` annotation forces sync context; `ya.sync()` bridges state. Install via `ya pkg add`.
