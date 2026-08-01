# snes9x invariant layer + codex template completion

Timestamp: 2026-07-31 19:45

## What was done

### Invariant layer (new dive layer, outermost)

| File | Category | Grounding incident |
|------|----------|--------------------|
| `guideline/invariant-layer.md` | layer constitution | definitional work: invariant = always-true state predicate; 4 categorical axes (subsystem × kind × strength × detector); standard semantic form; composition rules; non-invariants excluded |
| `invariant/browser-singleton.md` | browser × safety × by-guard × state-query | SingletonLock ping-pong |
| `invariant/download-destination.md` | acquisition × safety × by-construction × state-query | save-dir fix 14:16 |
| `invariant/acquisition-consistency.md` | acquisition × consistency × by-verification × outcome-check | Phantom 2040 accident |
| `invariant/rom-integrity.md` | verification × consistency × by-verification × outcome-check | Blues/Gundam transient FAILs |
| `invariant/launch-detachment.md` | launch × process × by-construction × state-query | setsid nohup work 14:38 |
| `invariant/scale-centralization.md` | structure × structural × by-audit × static-scan | 17-site scale sweep |
| `invariant/depth-24-buffer.md` | structure × structural × by-construction × runtime-symptom | -v9 segfault fix |
| `invariant/precedence-chain.md` | record × process × by-audit × static-scan | chain-run enforcement |

All files in plain prose (no symbols) per user direction. Standard semantic form: Invariant / Formal / Violation signature / Enforced by / Instance.

### Chain placement decision

User directive: invariant precedes script — `invariant/` is the outermost layer:

```
invariant/ → scripts/ → _bitacora/ → precept/ → backup/ → study/ → fixture/ → pattern/ → procedure/
```

Rationale: state facts exist before any work; tooling is built to preserve them; the record documents work governed by them. Propagated to `_templates/precedence-chain.md`, `_codex/AGENTS.md`, dive AGENTS.md (roles + structure), `invariant/precedence-chain.md`. Grep confirms no stale chain strings.

### Template completion (9 dive templates)

New: `invariant-template.md`, `guideline-template.md`, `study-template.md`, `fixture-template.md`, `backup-template.md`, `dive-agents-template.md` (the latter four filled gaps — no study/fixture templates existed anywhere; `AGENTS.template.md` was knowledge-only).

Wired: `copy-templates.sh` CODEX_FILES now 9 templates + 4 tools; `_templates/AGENTS.md` inventory updated; `_codex/AGENTS.md` conventions gained the propagation note.

## Decisions

- Invariant files: plain prose, not symbols — "declare in math" rejected, prose declared instead.
- Non-invariants excluded: cascade anchor, probe letter count, provenance-as-conduct, retry-as-conduct — mechanisms/precepts, not state facts.
- `guideline/` is a support layer (referenced, not a chain step).

## Errors found

- `copy-templates.sh` did not include headless browser launcher or new templates — fixed and verified (9/9 COPY).
- First invariant draft used math symbols; rewritten per user direction to plain prose.

## Findings

- Invariant/collision rule: a file that restates steps/structure/rules collides with procedure/pattern/precept; the standard semantic form forbids restatement, mandates `Enforced by` links.
- Chain placement: outermost invariant means new dives scaffold with the state-fact layer first (dive-agents-template carries it verbatim).

## Open edges

- Phantom 2040 removed 2026-07-31 19:50 (user directive) — library 30; zip + ROM both deleted.
- `_templates/AGENTS.md` tooling line: dive-agents-template mention beyond layer list (minor — already listed in dive layers line).
- MCP browser tools still unavailable; script flow independent.

## Todo state

All invariant-layer + template items closed in `task-todo/20260731-093638-snes9x-compile.md`.
