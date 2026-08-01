# ch03-dev-tools.md

**Source:** https://mise.jdx.dev/dev-tools/ (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Tool resolution flow

1. **Configuration discovery** — walk directory tree, merge config files hierarchically
2. **Tool resolution** — resolve version specs (`node@latest`, `python@3`) via registries + version lists
3. **Environment setup** — configure PATH + env vars for resolved versions

## Version file compatibility

- `mise.toml` `[tools]` — primary
- asdf `.tool-versions` — legacy
- Idiomatic version files — `.node-version`, `.ruby-version` (opt-in via `idiomatic_version_file_enable_tools`)
- Tool version/option templates may reference env vars or `vars` from config hierarchy

## Environment integration

```
| Mode | Usage |
|------|-------|
| Automatic activation | `eval "$(mise activate zsh)"` — hooks shell prompt, updates env on cd |
| On-demand | `mise exec -- node my-script.js` — no permanent activation |
| Task execution | `mise run` — activates full environment with tools |
```

## PATH management

```sh
# After activation in project with node@20:
/home/user/.local/share/mise/installs/node/20.11.0/bin:/usr/local/bin:/usr/bin:/bin
```
Real binaries — `which node` returns real path, zero overhead. `hook-env` fast-exits when dir/configs unchanged.

## Common commands

```
| Command | Purpose |
|---------|---------|
| `mise use node@26` | install + create/update mise.toml; `-g` for global config |
| `mise install` | download/build/compile into `~/.local/share/mise/installs` — no activation |
| `mise exec` / `mise x` | run command with mise env (reads local/global configs) |
| `mise run` / `mise r` | execute tasks with full env |
```

## Auto-install mechanisms (all default on)

```
| Trigger | Setting |
|---------|---------|
| On-demand (`mise x`, `mise r`) | `exec_auto_install`, `task_auto_install` |
| Command-not-found handler | shell hook installs missing tool providing that binary |
| Requires global `auto_install` enabled |
```

## OS-specific tools

`os` field restricts tools to specific OSes.

## Caching

Prompt hook calls `mise hook-env` each display; exits early if dir unchanged or configs unmodified. PATH modified ahead of time — direct runtime calls.

## Grounding

- concept/tool-resolution.md, concept/path-activation.md
- research/mise-dev-tools.md
- reference/site-citations.md — resolution flow, activation, zero-overhead quotes
