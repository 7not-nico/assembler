# Semantic engine test — session report

Date: 2026-08-02
Branch: main (d7b08f8)

## Work done

Full semantic engine toolchain exercised end-to-end: stats, drift, search, eval (3 variants + 3 document modes), purge survey, plus a stall investigation.

| Check | Command | Result |
|-------|---------|--------|
| Stats | `semantic-stats` | 567 embeddings, 25 tables, uniform 384-dim, model `Xenova/bge-small-en-v1.5` |
| Drift | `semantic-drift --check` | 0 missing, 0 stale, no drift (28 tables) |
| Search 1 | "agent session record keeping bitacora todo report workflow" | Top `IDENTITY.BITACORA` @ 0.7323 |
| Search 2 | "vector embedding nearest neighbor cosine similarity retrieval" | Top `PROT.SEARCH.QUERY` @ 0.7290 |
| Search 3 | "how to phrase rule instructions for agents" `--type rules` | Top `RUL.DECLARATIVE.OVER.IMPERATIVE` @ 0.6826 (79 indexed) |
| Eval | `--k 5` default/stored | MRR 0.1040, Recall 0.1673, Hit 0.2780, Self-hit 258/259 |
| Eval | `--k 5` passage/stored | MRR 0.0687, Recall 0.1230, Hit 0.2008, Self-hit 254/259 |
| Eval | `--k 5` default/title | MRR 0.0739, Recall 0.1213, Hit 0.1969, Self-hit 259/259 |
| Eval | `--k 5` default/body | MRR 0.1040, Recall 0.1673, Hit 0.2780, Self-hit 258/259 — identical to stored (expected) |

## Findings

1. **Index health** — no drift; self-hit 258-259/259 proves self-retrieval works. Low related-pair MRR (~0.10) reflects the `related:` graph encoding logical edges (composes-with, derives-from), not semantic similarity.
2. **Body-eval equivalence** — `--documents body` re-embeds the same body text the stored embeddings derive from, so metrics match `stored` exactly.
3. **Embedder truncates long inputs** — probe: 100 chars → 17 ms, 2000 → 93 ms, 8000 → 162 ms, 20000 → 165 ms (flat after 8k, internal truncation). Long bodies never stall the ONNX pass.
4. **Wrapper buffering** — `bitacora-log.sh` replays inner output from temp files at completion; long runs stream only the header. This produced the "stalled engine" appearance across three aborted runs. The engine and the wrapper both function; the fix is running long diagnostics directly (documented in AGENTS.md).
5. **Body lengths** — max concatenated body 5081 chars (skills); largest tables: skills avg 2442, protocols avg 2314, nexus max 2778.

## Decisions

- Probe workflow scaffolded at `.opencode/_shell/survey/semantic-engine-probe/` (bash orchestrates; TS probe for embedder behavior): `s01-body-lengths.sh`, `s02-embed-probe.ts`, `s03-eval-body.sh`, `run-probe.sh`.
- AGENTS.md updated: `semantic-purge` documented in CLI tools; eval caveat corrected per probe evidence; wrapper buffering behavior noted.
- Long diagnostics run directly (bypass wrapper) to watch live progress.

## Open edges

- `semantic-purge` dry-run not executed (drift shows 0 stale, so the purge would report 0).
- `--variant raw` eval not run (default and passage covered).
- Concurrent pipeline inits (two evals launched in parallel) remain untested as a contention source; the earlier body-run stall coincided with a parallel title run, but the wrapper buffering explains the appearance without needing a contention hypothesis.

## Logs

`20260802-105452-semantic-stats.log`, `20260802-105500-semantic-drift.log`, `20260802-105520-semantic-search-1.log`, `20260802-105528-semantic-search-2.log`, `20260802-105534-semantic-search-3.log`, `20260802-105924-semantic-eval.log`, `20260802-105949-semantic-eval-passage.log`, `20260802-110004-semantic-eval-title.log`, `20260802-111131-probe-s01.log` (all in `.opencode/_bitacora/task-stdout/`). The s03 body-eval verification ran directly (no wrapper) — output captured in session; identical metrics to the stored run.

## Todo state

All todo items complete: survey, stats, drift, embed-skip (no drift), search (3), eval (4 configs), report written.
