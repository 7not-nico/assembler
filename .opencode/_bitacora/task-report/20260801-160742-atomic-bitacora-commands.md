# Atomic Bitacora Commands

Timestamp: 2026-08-01 160742

## What was done

Built three atomic shell commands in `.opencode/_bitacora/` (all `chmod +x`, use `rg`, location-aware, `set -uo pipefail`):

| Script | Function |
|--------|----------|
| `bitacora-find.sh {topic}` | Locate records across all 7 task-* folders by name/content; print `{kind}/{file} [status]` |
| `bitacora-close.sh {todo} {topic}` | Complete pending `[ ]` items, stamp `Status: completed (date)`, scaffold the report via `bitacora-create.sh` |
| `stale-id-list.sh [--top N]` | Group `rs check stale-refs` output into per-ID counts, sorted descending |

**rg conversion** — user direction ("we use rg, ripgrep"): `grep` → `rg` in `bitacora-find.sh` (content + basename matching, status extraction) and `bitacora-close.sh` (Status-line check).

## Verification

- `bitacora-find.sh "corruption"` — found the incident report + repair logs (+ its own log, self-referential)
- `bitacora-close.sh` round-trip — throwaway todo: items `[ ]`→`[x]`, Status stamped, report scaffolded, artifacts cleaned (2× runs)
- `stale-id-list.sh --top 10` — grouped counts: `RUL.WRITING.CONVENTION` 44, `REF.LIB.DIRECTORY.LAYER` 33, `PROT.LLM.SPECIFICATION` 25, `MAX.KNOWLEDGE.CLASSIFICATION` 25, `MAX.CODE.LAYERS` 25, `PAT.SHARED.LIB` 23...
- All logged: `task-stdout/20260801-160725-atomic-commands-verify.log`

## Decisions

- Atomic per `MAX.ATOMIC.CONCERN`: find (search), close (complete+scaffold), stale-id-list (group)
- `rg` over `grep` throughout per house tooling
- `stale-id-list.sh` uses `awk` for table parsing (not rg) — the `rs` output is already a pipe stream
- Scripts do not self-log (agent wraps invocations via `bitacora-log.sh`; avoids recursion into task-stdout)

## Open edges

- Broader stale waves surfaced: RUL.* (44), REF.LIB.* (33), MAX.* (25), PAT.* (23) — folded into `resolve-remaining-stale-protocol-ids` todo; rename-vs-create decision extends beyond PROT.*
- `bitacora-close.sh` completes ALL pending items — no selective close (fine for closure ritual; note if partial completion needed)

## Todo state

- `task-todo/2026-08-01--resolve-remaining-stale-protocol-ids.md` — in progress (parked; addendum added)
- `task-todo/2026-08-01--continue-session-queue.md` — completed
- `task-todo/2026-08-01--go-scripts-toolchain.md` — completed

## Logs

- `task-stdout/20260801-160725-atomic-commands-verify.log` — find/stale-id/close round-trip, exit 0
