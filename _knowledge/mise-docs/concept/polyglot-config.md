# polyglot-config.md

A polyglot config is a single mise.toml managing dev tools, env vars, and tasks together.

One file checked into the repo — every machine gets the same setup. Combines asdf (tools), direnv (env), make (tasks) roles. Sections: `[tools]`, `[env]`, `[tasks]`, `[settings]`.

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-homepage.md | "all configured in a single `mise.toml` checked into your repo, so every machine gets the same setup" |
| research/mise-homepage.md | asdf+direnv+make replacement |

## Sub-concepts

| # | Sub-concept | Anchored by |
|---|-------------|-------------|
| 1 | config-hierarchy | research/mise-configuration.md |
| 2 | path-activation | research/mise-dev-tools.md |
| 3 | tool-resolution | research/mise-dev-tools.md |
| 4 | env-directives | research/mise-environments.md |
| 5 | task-runner | research/mise-tasks.md |

## Distilled into

- note/ch01-overview.md
- note/ch02-configuration.md

## Precedes

config-hierarchy, path-activation, tool-resolution, env-directives, task-runner
