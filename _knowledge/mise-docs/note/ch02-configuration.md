# ch02-configuration.md

**Source:** https://mise.jdx.dev/configuration/ (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Config file paths (precedence, top overrides)

1. `mise.local.toml` — local, not committed
2. `mise.toml`
3. `mise/config.toml`
4. `.mise/config.toml`
5. `.config/mise.toml`
6. `.config/mise/config.toml`

Plus: env-specific `mise.{env}.toml` via `MISE_ENV`; platform-specific `mise.windows.toml`/`mise.macos-arm64.toml` via `auto_env`; system-wide `/etc/mise/config.toml` + `conf.d/*.toml` fragments.

## Sections

```toml
[tools]
node = '24'

[env]
NODE_ENV = 'development'

[tasks.dev]
run = 'npm run dev'
```

### Merge behavior

```
| Section | Behavior |
|---------|----------|
| `[tools]` | additive with overrides |
| `[env]` | additive with overrides |
| `[tasks]` | complete replace — project wins entirely |
| `[settings]` | additive with overrides |
```

### Tool options

- `install_env` — env vars during install + tool postinstall
- `postinstall` — command after install; env has `MISE_TOOL_INSTALL_PATH`; skipped on failure
- `os` — restrict tool to OS

## Global config `~/.config/mise/config.toml`

Applies to every directory: `[tools]`, `[settings]` (idiomatic_version_file_enable_tools, trusted_config_paths, env_file), `[settings.status]` (show_env/show_tools), `[_]` special key (never parsed).

## Env variables

```
| Variable | Default | Purpose |
|----------|---------|---------|
| `MISE_GLOBAL_CONFIG_FILE` | `$MISE_CONFIG_DIR/config.toml` | global config path for writes |
| `MISE_DEFAULT_CONFIG_FILENAME` | `mise.toml` | default local config filename |
| `MISE_GLOBAL_CONFIG_ROOT` | `$HOME` | `{{config_root}}` for global config |
| `MISE_ENV_FILE` | — | dotenv filename, cwd + parents (dotenvy) |
| `MISE_${TOOL}_VERSION` | — | force tool version (e.g. `MISE_NODE_VERSION=20`) |
```

## Write target behavior

- `mise use node@22` → `mise.toml` (shared)
- `mise use --env local node@20` → `mise.local.toml`
- `mise set NODE_ENV=production` → `mise.toml`

## Schema

- `mise.toml`: mise.en.dev/schema/mise.json, JSON schema store
- Included tasks: separate mise.en.dev/schema/mise-task.json

## Grounding

- concept/config-hierarchy.md
- research/mise-configuration.md
- reference/site-citations.md — precedence, merge, write-target quotes
