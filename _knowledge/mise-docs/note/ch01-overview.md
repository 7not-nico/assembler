# ch01-overview.md

**Source:** https://mise.jdx.dev/ (2026-07-31), 2026.7.0
**Method:** parallel-search web_search + web_fetch excerpts

## Core identity

mise-en-place — "your dev environment, prepped and ready". One Rust CLI managing dev tools, env vars, and tasks per project. Replaces asdf/nvm/pyenv (tools) + direnv (env) + make (tasks). 1000+ tool registry.

## Install + activate

```sh
curl https://mise.run | sh
eval "$(mise activate zsh)"   # .zshrc / .bashrc / fish
```

Linux, Windows, macOS. Homebrew: `brew install jdx/mise/mise`.

## Config model

Single `mise.toml` checked into repo — identical setup on every machine:

```toml
[tools]
node = "24"
python = "3.13"

[env]
_.file = ".env.local"

[tasks.test]
run = "pytest"
```

## Three pillars

```
| Pillar | Command | Purpose |
|--------|---------|---------|
| Dev tools | `mise use/install` | install tools, pin versions, auto-switch per directory |
| Environments | `mise env` | load project env vars from mise.toml, .env files, shell commands |
| Tasks | `mise run` | define build/test/lint/deploy next to tools+env |
```

## Key properties

- **Real PATH** — `which node` returns real binary path, no shims; zero overhead per call
- **`hook-env` fast-exit** — prompt hook skips when dir/configs unchanged
- **Hierarchical config** — child mise.toml overrides parent
- **Schema** — JSON schema (mise.en.dev/schema/mise.json + schemastore.org); separate task schema
- **Companion** — aube (fast Node package manager, same author)

## Getting started (4 steps)

1. Install — `curl https://mise.run | sh`
2. Tools — `mise use node@24 python@3.13` (installs + writes mise.toml)
3. Env — `mise env -s bash` exports; `mise set MY_VAR=123`
4. Tasks — `mise run test`

## Community

Discord: discord.gg/mABnUDvP57. GitHub Discussions (not issues).

## Grounding

- concept/polyglot-config.md, concept/path-activation.md
- research/mise-homepage.md
- reference/site-citations.md — homepage quotes, README quotes
