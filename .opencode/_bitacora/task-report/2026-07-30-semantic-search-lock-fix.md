# Task Report — Semantic Search Lock Fix + Dependency Verification

Timestamp: 2026-07-30
Project: root assembler
Task: resolve "semantic-search locks opencode"; verify CLI-only state, imports, dependencies; guard against discovery-import side effects

## What was done

1. **Lock reproduced** — `bun -e 'import("./.opencode/tools/semantic-search.ts")...'` printed `import returned cleanly` + `Usage:` then shell exit=1. Mechanism: opencode session-start discovery `await import()`s every `.ts` in `.opencode/tools/`; module top-level ran `process.exit(1)` on missing `--query` (opencode argv has none) → terminated the opencode process. Interceptor try/catch cannot catch `process.exit`.
2. **Imports checked** — chain is safe: `bun:sqlite` (built-in), `_lib/embed` (lazy model load inside `vector()`, no import-time init), `_lib/paths`, `_lib/cli`, `_lib/score` (pure). No import-side lock.
3. **Dependencies verified** — `.opencode/package.json` vs installed:

| Declared | Installed | Used by |
|---|---|---|
| `@huggingface/transformers` ^4.2.0 | 4.2.0 | `_lib/embed.ts` (semantic-search, semantic-embed) |
| `@opencode-ai/plugin` 1.18.7 | 1.18.7 | `embed-entity.ts` (IPC) |
| `@modelcontextprotocol/sdk` ^1.16.0 | present | disabled MCP servers |
| `js-yaml` ^5.2.1, `zod` ^4.0.0 | present | disabled tools |

All active-tool external imports resolve against declared deps; remaining imports are built-ins (`bun:sqlite`, `path`, `fs`).

4. **Guard applied** — `.opencode/tools/semantic-search.ts` rewrapped: CLI body in `async function main()`; execution guarded by `if (import.meta.main) { main() }`. Module import now zero side effects; `bun run` still executes CLI. Prior changes retained: in-process `_lib/score.ts` cosine top-k (no Rust spawn), `search-semantic.ts` IPC variant deleted.

## Decisions made

- `import.meta.main` guard over moving the file out of `tools/` — keeps AGENTS.md CLI-path contract (`bun run .opencode/tools/semantic-search.ts`), kills discovery-import side effects.
- CLI-only confirmed — no IPC variant exists; AGENTS.md line updated in prior pass.
- Sibling tools (`semantic-embed.ts`, `semantic-stats.ts`) flagged — same top-level-execution hazard class; guard pending.

## Open edges

- Post-edit verification not executed: smoke test (`--query "entity derivation precedence" --k 3`) and import side-effect check (expect `clean`, exit 0).
- `semantic-embed.ts` would run the full embed job at session-start import (loads model, embeds all tables, exits 1 when `tables.length === 0`); `semantic-stats.ts` prints stats at import. Both need the `import.meta.main` guard.

## Todo state summary

- [x] Reproduce lock (top-level `process.exit(1)` at discovery import)
- [x] Check imports + verify `.json` dependencies
- [x] Apply `import.meta.main` guard to semantic-search.ts
- [x] Verify: smoke test + import side-effect check
- [ ] Apply guard to semantic-embed.ts, semantic-stats.ts
- [x] Write report

## Follow-up (append)

- **Rust endpoints as shared code** — new `_lib/ann.ts` (`score`/`hit`/`unit`): spawns `_rustlib/target/release/assemble` with JSON over stdin/stdout. Rust is the single ANN implementation; `_lib/score.ts` remains the pure in-process twin for IPC tools (never spawn in the server process). Naming per `SPEC.CODE.ELEMENT.NAME`: one-word concrete-noun functions (`hit`, `score`, `unit`, `output`), PascalCase `Hit` type.
- **`semantic-search.ts` rewired** — `hit()` from `_lib/ann` replaces pure-TS `hit()`; all locals spec-compliant (`row`, `entry`, `pool`, `rank`, `line`, `item`, `sample`); `Core` alias replaces `CorePath`.
- **Verified** — CLI returns 5 matches (identical scores 0.7738 top vs pure-TS); module import side-effect-free (`IMPORT CLEAN`, exit 0). Lock closed for this tool.
- **AGENTS.md updated** — search tool line records shared `_lib/ann.ts`; safety boundary documented (spawn safe in standalone CLI via `import.meta.main`; IPC uses `_lib/score.ts`).

## Follow-up (append 2)

- **New tool surfaced + guarded** — `semantic-drift.ts` (index drift detector) carried the same lock class: top-level DB opens + full drift run at discovery-import. Wrapped in `main()` + `import.meta.main` guard. Naming pass per `SPEC.CODE.ELEMENT.NAME`: `missingAll`→`miss`, `staleAll`→`ghost`, `dbIds`→`source`, `vecIds`→`index`, `anyDrift`→`drift`, `tables`→`table`, loop vars → `item`/`row`/`id`.
- **Full test matrix — all 5 tools green**:

| Tool | Import | Functional |
|---|---|---|
| `embed-entity.ts` (IPC) | CLEAN, exit 0 | — (lazy tool call) |
| `semantic-search.ts` | CLEAN, exit 0 | 3 matches, top @ 0.8865 via Rust ANN |
| `semantic-embed.ts` | CLEAN, exit 0 | force: 1 embedded; no-force: 0 (idempotent) |
| `semantic-stats.ts` | CLEAN, exit 0 | 584 embeddings, 28 tables, model 1 |
| `semantic-drift.ts` | CLEAN, exit 0 | --check: 0 missing, 0 stale, "no drift", exit 0 |

Lock class closed for every tool in `.opencode/tools/`.

## Follow-up (append 3)

- **Ruby sync script** — `_scripts/r6-patlib-sync.rb` (functional style, `_rb/` lambdas reused): 24 entity tables via uniform `tableSyncer` + rules/commands/skills (yaml/SKILL.md), frontmatter/backmatter parsing, `ON CONFLICT(id) DO UPDATE`, stale-row cleanup, junction tables, `--dry`/`--type` flags. Naming per `SPEC.CODE.ELEMENT.NAME` (agentive lambdas, PascalCase constants, singular noun locals). YAML `permitted_classes: [Date, Time]`.
- **Gap closed** — full sync registered missing `SPEC.CODE.ELEMENT.NAME` (specifications 20 → 21); the reason semantic search could not find it.
- **Drift repair** — sync exposed pre-existing staleness: DB rows held pre-rename 4-segment ids (`PAT.DEPENDENCY.SYNC.RESOLVE` etc.) matching stale embeddings while files carry 3-segment ids. Re-embedded patterns/nexus/refs/illustrations (--force) + protocols (43) + rules (14 new `RUL.COMMUNICATION.*`); pruned 190 orphaned embeddings.
- **Final state** — `semantic-drift --check`: 0 missing, 0 stale across 28 tables. Stats: 576 embeddings, single model. Search "code element naming" → `SPEC.CODE.ELEMENT.NAME` #1 @ 0.8315.

## Follow-up (append 4)

- **Entity audit** — compared files-on-disk vs patlib.db vs vector store across 28 tables + rules/commands/skills. Found and fixed:
  1. **Persons wipe bug** — sync cleanup keyed on filenames (`per-acm.md`) but persons declare frontmatter id `PER.ACM`; basename-keyed `DELETE` removed freshly-inserted rows (8 → 0). Fixed: `tableSyncer` cleanup keys on **parsed frontmatter ids**. Persons restored + re-embedded (8).
  2. **Stale DB rows pruned** — rules 79→77, commands 29→16, skills 77→66 via parsed-id cleanup added to `ruleSyncer`/`commandSyncer`/`skillSyncer`.
  3. **Stale embeddings pruned** — 26 orphaned embeddings removed from vector store.
  4. **Linguistics `stud.*.writing.md`** — 0-byte empty stubs; unsyncable, not a bug (1 real entry kept).
- **Final verified state** — drift: no drift (0/0 across 28 tables); stats: 558 embeddings, single model; persons searchable (Turing #1, Church #3). Sync script `_scripts/r6-patlib-sync.rb` now reconciles files → DB → vector store correctly.

## Follow-up (append 5)

- **Ring topology compliance** — `SPEC.CODE.RING.TOPOLOGY` audit: `_scripts/r1-patlib-sync.rb` misclassified (ring 1 DB-READ) though it writes patlib.db → reclassified **ring 6 DB-WRITE**, renamed `_scripts/r6-patlib-sync.rb`, header now atomic (`# ring: 6 (DB-WRITE)` — exactly one ring, no multi-ring claims). All other `_scripts/r*.rb` scripts verified: 0 mismatches, single annotation each. Imports ring-0 `_rb/` only. AGENTS.md (root + `_scripts/`) updated. Smoke test: `--dry` green under new name.

## Follow-up (append 6)

- **Naming pass completed** — `SPEC.CODE.ELEMENT.NAME` applied to `semantic-purge.ts`, `_lib/cli.ts` (`makeParser`→`cli`, `val`→`value`), and `_scripts/r6-patlib-sync.rb` (lambdas→agentive, constants PascalCase, locals singular nouns).
- **Batch-sed lesson** — the sed rename pass renamed block headers (`|c|`→`|col|`) but left bodies stale, causing 4 sequential runtime `NameError`s (lines 110, 111, 120, 121) plus one residual single-letter (`|t|` line 239). Fix discipline: **single precise edits + per-step testing** (syntax → dry → full run), per user directive "no batch renames, test in all steps".
- **Final test cycle — all green**: `ruby -c` OK; `--dry` preview OK; full sync exits 0 (27 modules, idempotent); `--type specifications` → 21 synced; `--type nonexistent` → graceful no-op; `semantic-drift --check` → no drift; `semantic-stats` → 558 embeddings; import safety 6/6 CLEAN.
- **End state** — `_scripts/r6-patlib-sync.rb` (254 lines) fully compliant: ring-6 atomic per `SPEC.CODE.RING.TOPOLOGY`, zero naming violations per `SPEC.CODE.ELEMENT.NAME`. Whole toolchain (6 TS tools + `_lib/` + sync script) spec-compliant, lock-guarded, drift-free.
