# Patlib queries

## Entity types

| Type | Flag |
|------|------|
| Patterns | `--type patterns` |
| Terms | `--type terms` |
| Rules | `--type rules` |
| Skills | `--type skills` |
| Commands | `--type commands` |
| Protocols | `--type protocols` |
| Abstractions | `--type abstractions` |
| Apologias | `--type apologias` |
| Maxims | `--type maxims` |

Default: patterns, terms, maxims when task scope unknown.

## Gotchas

- **`nerdfont/sets/`** — authoritative glyph source, not training memory
- **`ludoteca/docs/`** — documentation standard for all subprojects
- **`ludoteca/.opencode/`** — IaC template; new projects derive from it, not built from scratch
- **`future-patterns-terms/`** — `.bak` and scratch proposals only. Do not sync or reference.
