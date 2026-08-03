# tracexec-reference

Timestamp: 2026-08-03 20260803-052356

## What was done

- Captured verbatim `tracexec --help` and `tracexec log --help` output (`tracexec-reference-capture` → task-stdout).
- Wrote `reference/tracexec.md` (4,691 bytes, 0 md tables) — first content file in the rust-docs reference/ layer: Source block (version 0.17.0, captured date), verbatim citations (top-level help, log-mode usage/output selectors, observed line grammar `{pid}<{comm}>: "{exe}" ["argv"...] fd [...]`), claim mapping from every learning/tracexec.md claim to its citation, governs list.
- Cross-linked `learning/tracexec.md` Open edges → `reference/tracexec.md` as grounding source.
- Verified via `reference-verify`: file in place, no md tables, chain intact.

## Decisions

- Verbatim help output is the canonical citation — the tool documents itself; no external source needed.
- Code-block formatting only, matching the `_templates` formatting convention.
- reference/ naming `{name}.md` — lowercase single word `tracexec`.

## Open edges

- None — reference created, learning note grounded, todo closed.

## Todo state

- [x] capture tracexec --help + log --help verbatim
- [x] write reference/tracexec.md
- [x] cross-link learning/tracexec.md → reference/tracexec.md
- [x] close todo, write report

Logs: `tracexec-reference-capture`, `reference-verify`, `bitacora-ref-todo`, `bitacora-ref-close` → `_knowledge/_bitacora/task-stdout/`.
