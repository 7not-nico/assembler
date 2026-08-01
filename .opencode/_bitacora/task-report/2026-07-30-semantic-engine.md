# Task Report — Root Semantic Engine: Fix, Rebuild, Disable

Timestamp: 2026-07-30
Project: assembler root `.opencode/` — semantic engine
Task: implement/repair the root semantic engine in `.opencode/tools/`; stabilize DB journal modes; deactivate error-causing components

## What was done

1. **Engine audit** — existing partial engine located: IPC `embed-entity.ts` (TRNS), `search-semantic.ts` (RECG), `_lib/embed.ts` (model `Xenova/bge-small-en-v1.5`, 384-dim), `_lib/paths.ts`, Rust ANN `_rustlib/target/release/assemble` (`score|hit|unit`).

2. **Bug fixes**:
   - `search-semantic.ts`: `proc.stdin.getWriter()` on Bun `FileSink` → `.write()`/`.end()` (stdin bug).
   - Column discovery via `pragma_table_info` replaced with first-row keys (`SELECT * LIMIT 1` filter `MetaCols`) in `embed-entity.ts` + `semantic-embed.ts` — pragma path caused errors.
   - All `PRAGMA journal_mode = WAL` removed from active engine files — no WAL, no sidecars.

3. **Schema drift resolved** — `patlib-vector.db` real schema (`entity_type, entity_id, seq, field, vector, content_hash, model_version, source_file, source_mtime, updated`, UNIQUE per `(entity_type, entity_id, seq, field)`). IPC embedder's `model`/`dimension` INSERT was schema-broken.

4. **NAPI fatal error resolved** — all three DBs persisted `wal` journal mode; bun:sqlite crashed after sidecar removal.
   - `patlib-vector.db` archived → `patlib-vector.db.2026-07-30.napi-fatal` (1,323 old embeddings preserved).
   - `patlib.db` + `mcp-search.db` converted to `DELETE` journal mode (verified `delete`).

5. **CLI suite built** (testable without server restart):
   - `semantic-embed.ts` — real-schema upsert (`seq=0`, `field='full'`, sha256 `content_hash`, `ON CONFLICT DO UPDATE`), `--type`/`--force`.
   - `semantic-search.ts` — query → embedding → top-k → title join.
   - `semantic-stats.ts` — per-table counts/models/dim.
   - `_lib/cli.ts` — shared `makeParser`.

6. **Store rebuilt** — 584 unique entities, 25 entity types, all 384-dim, single model. Search verified: `SPEC.TOOL.CLASSIFICATION.AUTOMATON` 0.8232 top for "tool classification automaton I/O model"; no duplicate rows (each entity one `seq=0/field='full'` row).

7. **Search tools disabled** — `search-semantic.ts` (IPC) + `semantic-search.ts` (CLI) moved to `tools/_disabled/`. Cause: Rust-pipe spawn path locked opencode. Re-enable path: in-process `_lib/score.ts` (pure `score`/`unit`/`hit`, written, unused).

8. **Plugins deactivated + archived** — all 8 plugin files moved to `plugins/_disabled/`: `audit-events`, `auto-sync`, `bash-guard`, `burst-alert`, `cmd-audit`, `log-mcp`, `ref-integrity`, `session-saver`. No plugin registrations in any `opencode.json` (directory-discovered).

9. **`embed-entity.ts` repaired** (3 bugs after schema migration):
   - INSERT referenced nonexistent `model`/`dimension` columns.
   - INSERT omitted NOT NULL `content_hash`.
   - `c.name` access on `string[]` column list → `"undefined"` columns in SQL.
   - Now mirrors tested `semantic-embed.ts`: real-schema upsert + sha256 hash.

10. **AGENTS.md updated** — semantic engine block: active tools, disabled search tools, shared libs, vector store schema, journal-mode rule, ANN backend.

## Decisions made

- In-process pure cosine (`_lib/score.ts`) as the search re-enable path — no spawn, no lock. Rust binary retained for `score`/`unit` verbs.
- `DELETE` journal mode everywhere — no WAL, no sidecars (user directive).
- `_disabled/` convention for deactivated tools and plugins (matches existing `tools/_disabled/`, `_lib/_disabled/`).
- Archive (rename) over deletion for the NAPI-fatal vector DB — data preserved, rebuild from `patlib.db` + markdown.
- Combined full-text per entity (`id + title + body…`) at `seq=0/field='full'` — one row per entity.

## Open edges

- **Disabled `search-semantic.ts` residual**: result loop still `for (let h of hit)` where `hit` is now the imported function → must become `hitList` before re-enable.
- **Parse check**: `bun build --target=bun .opencode/tools/embed-entity.ts` pending (earlier check failed on missing target flag, not code).
- **Restart required**: opencode must restart to load repaired `embed-entity.ts` and drop the stale live `search-semantic`.
- **Plugins deactivated**: `auto-sync`, `session-saver`, `bash-guard`, etc. no longer run — decide whether any restore is needed.
- **Archived artifacts**: `patlib-vector.db.2026-07-30.napi-fatal` retained as backup; `plugins/_disabled/` holds 8 archived plugins.

## Todo state summary

- [x] Audit existing engine (IPC + CLI + Rust + vector DB)
- [x] Fix search stdin bug; pragma-free column discovery; WAL removal
- [x] Resolve schema drift + NAPI fatal (archive, DELETE mode)
- [x] Build + verify CLI suite (embed 584 / stats / search)
- [x] Disable search tools (lock source) into `tools/_disabled/`
- [x] Archive plugins into `plugins/_disabled/`
- [x] Repair `embed-entity.ts` (3 schema bugs)
- [x] Update AGENTS.md
- [x] Write report
- [ ] Restart opencode; re-run parse check; re-enable path (in-process `_lib/score.ts`) when desired

## Follow-up (append)

Later passes superseded parts of this report. Cross-references: `2026-07-30-semantic-search-rewire.md`, `2026-07-30-semantic-search-lock-fix.md`.

- **Search re-enabled, CLI-only** — `semantic-search.ts` rewired to `_lib/ann.ts` (Rust ANN `score|hit|unit` endpoints, spawn-safe in standalone processes); IPC variant `search-semantic.ts` deleted. `_lib/score.ts` (pure in-process) reserved for IPC use — spawn in the server process locks opencode.
- **Real lock mechanism identified** — opencode session-start discovery `import()`s every `.ts` in `tools/`; CLI top-level `process.exit(1)` (missing `--query`) terminated the server. Fix: `import.meta.main` guard — zero side effects at import.
- **Guards applied** — `semantic-search.ts` (rewire pass), then `semantic-embed.ts` + `semantic-stats.ts` (this session; also fixed latent `c.name`-on-`string[]` column mapping in `semantic-embed.ts`).
- **Verified** — import side-effect checks: all 3 CLI tools `clean`, exit 0; `bun build --target=bun embed-entity.ts`: 185 modules, exit 0; CLI smoke: `semantic-embed --type apologias --force` → `embedded 1 apologias`; `semantic-stats` → 584 embeddings, 25 types, single model.
- **AGENTS.md** — updated by rewire/lock-fix passes; confirmed accurate (CLI search via `_lib/ann.ts`, IPC via `_lib/score.ts`, DELETE journal mode, no WAL).
- **Open edges** — restart opencode to load repaired `embed-entity.ts`; decide restoration of archived plugins (`plugins/_disabled/`, 8 files); `patlib-vector.db.2026-07-30.napi-fatal` retained as backup.
