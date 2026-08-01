# Task Report — Root Semantic Engine: Final State

Timestamp: 2026-07-30
Project: assembler root `.opencode/`
Task: complete the root semantic engine — fixes, stable store, guard all CLI tools, verify end-to-end
Supersedes: `2026-07-30-semantic-engine.md` (session log), `2026-07-30-semantic-search-rewire.md`, `2026-07-30-semantic-search-lock-fix.md`

## What was done

1. **Search lock eliminated** — root cause: opencode session-start discovery `import()`s every `.ts` in `tools/`; CLI top-level `process.exit(1)` (missing `--query`) terminated the server. Fix: `import.meta.main` guard on all three CLI tools (`semantic-search` by rewire pass; `semantic-embed` + `semantic-stats` here).

2. **Embed pipeline repaired** — `embed-entity.ts` (IPC): 3 schema bugs fixed (INSERT `model`/`dimension` → real-schema upsert; missing NOT NULL `content_hash`; `c.name` on `string[]` → string keys). `semantic-embed.ts`: same `c.name` latent bug fixed.

3. **DB stability** — `patlib-vector.db` archived (`patlib-vector.db.2026-07-30.napi-fatal`) after NAPI fatal from persisted WAL; `patlib.db` + `mcp-search.db` converted to DELETE journal mode. All active tools free of `PRAGMA journal_mode` — no WAL, no sidecars.

4. **Store rebuilt** — 584 unique entities, 25 entity types, 384-dim, model `Xenova/bge-small-en-v1.5`, one row per entity (`seq=0`, `field='full'`), `content_hash` sha256, upsert-idempotent.

5. **Search re-enabled (CLI-only)** — `semantic-search.ts` at `tools/` uses `_lib/ann.ts` (Rust ANN `score|hit|unit`, spawn-safe in standalone guarded processes). IPC variant `search-semantic.ts` deleted. `_lib/score.ts` (pure) reserved for IPC — spawn in the server process locks opencode.

6. **Plugins deactivated + archived** — 8 plugins → `plugins/_disabled/` (audit-events, auto-sync, bash-guard, burst-alert, cmd-audit, log-mcp, ref-integrity, session-saver). No config registrations (directory-discovered).

7. **AGENTS.md** — semantic engine block current: IPC `embed-entity`, CLI `semantic-embed`/`semantic-search`/`semantic-stats`, `_lib/ann` vs `_lib/score` safety boundary, vector store schema, DELETE journal rule, Rust backend.

## Verification (all green)

| Check | Result |
|-------|--------|
| Import side-effects — 3 CLI tools | `clean`, exit 0 ×3 |
| `bun build --target=bun embed-entity.ts` | 185 modules, exit 0 |
| `semantic-embed --type apologias --force` | `embedded 1 apologias` |
| `semantic-stats` | 584 embeddings, 25 types, single model |
| `semantic-search --query` (rewire pass) | top hit `PRE.PRECEDENCE.DERIVATION.CHAIN` 0.7738 |
| Sidecars after runs | none (`-wal`/`-shm` absent) |

## Decisions made

- `import.meta.main` guard over file moves — keeps AGENTS.md CLI-path contract, kills discovery-import side effects.
- CLI search via Rust ANN (`_lib/ann.ts`) — standalone spawn safe; IPC stays pure (`_lib/score.ts`).
- DELETE journal mode everywhere — no WAL, no sidecars (user directive).
- Archive over delete for NAPI-fatal DB; `_disabled/` convention for deactivated plugins/tools.
- Combined full-text per entity at `seq=0/field='full'` — one row per entity, no duplicate hits.

## Open edges

- **Restart opencode** (user action) — loads repaired `embed-entity.ts`, confirms no discovery-import locks.
- **Plugin restoration** — decide which archived plugins (`plugins/_disabled/`) return to service.
- **Archived backup** — `patlib-vector.db.2026-07-30.napi-fatal` (1,323 old embeddings) retained; rebuild verified, may be pruned.
- **Subproject docs** — `_knowledge/rust-coding/reference/exception.md` still cites `.opencode/tools/search-semantic.ts` (deleted); update on next visit (subproject delegation applies).

## Todo state summary

- [x] Fix search lock (discovery-import + `import.meta.main` guard)
- [x] Repair IPC embedder + CLI embedder (schema, hash, column bugs)
- [x] Stabilize DBs (archive NAPI-fatal vector DB; DELETE journal mode)
- [x] Rebuild store (584 entities, verified)
- [x] Re-enable CLI search (Rust ANN via `_lib/ann.ts`, guarded)
- [x] Deactivate + archive plugins
- [x] Update AGENTS.md
- [x] Verify end-to-end (imports, parse, embed, stats, search)
- [x] Write report
- [ ] Restart opencode; decide plugin restorations; prune archived backup when confirmed
