# config-hierarchy.md

Config hierarchy is the precedence-ordered set of mise config files, merged top-down.

Paths (top overrides): `mise.local.toml` (not committed) → `mise.toml` → `mise/config.toml` → `.mise/config.toml` → `.config/mise.toml` → `.config/mise/config.toml`. Plus env-specific `mise.{env}.toml` via `MISE_ENV`, platform-specific via `auto_env`, system-wide `/etc/mise/`. Merge: tools/env/settings additive, tasks complete-replace. Writes target shared config by default, local/env-specific only when targeted.

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-configuration.md | "in order of precedence, top overrides configuration of lower paths" |
| research/mise-configuration.md | "Tasks: completely replaces global" |
| research/mise-dev-tools.md | hierarchy example (global → work → project → .tool-versions) |

## Sub-concepts

- env-directives (env merge behavior)
- tool-resolution (config discovery step)

## Distilled into

- note/ch02-configuration.md

## Precedes

env-directives
