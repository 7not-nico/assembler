# Semantic Drift Tooling — Task Report

Timestamp: 2026-07-31T04:38 (UTC)
Task: index gaps, DB topology cleanup, new drift tool

## What was done

1. **Gap analysis** — compared `patlib.db` entity tables against `patlib-vector.db` embeddings. Initial manual scan found 51 rows in the root DB absent from the vector store; the canonical `.opencode/patlib.db` was fully aligned (584 embeddings, 28 tables).

2. **Two-DB divergence resolved** — discovered root `patlib.db` (Jul 27, 1.6MB) coexisting with `.opencode/patlib.db` (Jul 30, 1.9MB). The semantic engine (`_lib/paths.ts`) reads only `.opencode/patlib.db`; root was a stale leftover. Its 51 unique rows (MAX.DRY, TERM.COMMAND, PAT.DEPENDENCY.SYNC, PROT.COMMAND, etc.) have zero matching `.md` files — all pre-rename IDs superseded by current names. Files are the source of truth (`REF.META.TOPOLOGY`); DB is a derived cache.

3. **Root `patlib.db` removed** — backed up to `/tmp/opencode/patlib.root-backup-20260730.db`. Now only `.opencode/` hosts DBs: `patlib.db`, `patlib-vector.db`, `mcp-search.db`, `sessions.db`. Policy per user directive: DB lives in hidden opencode only.

4. **`semantic-drift.ts` created** — `.opencode/tools/semantic-drift.ts` (RECG, read-only CLI). Detects MISSING (DB row without embedding) and STALE (embedding without DB row) per table against `.opencode/patlib.db`; `--check` exits 1 on drift. Family conventions: `// @toolclass RECG` line 1, imports from `_lib/` only, `import.meta.main` guard, main() wrapper. Audit-tool pass (CLI-only family documented exception in AGENTS.md).

5. **AGENTS.md updated** — line 7: `patlib.db` location clarified to `.opencode/` only. Line 22: `semantic-drift` registered with CLI tools.

6. **AGENTS.md root tool list reconciled** — line 14/18 rewritten: active root tools are semantic engine only; former sync/read/MCP toolchain (`write-sync`, `sync-watch`, `read-selection`, `read-projection`, `read-validate`, `mcp-*`) documented as disabled, archived under `.opencode/tools/_disabled/` with matching `_lib/_disabled/` modules.

7. **`semantic-purge.ts` created** — `.opencode/tools/semantic-purge.ts` (TRNS, write CLI). Deletes vector-store rows whose entity no longer exists in patlib.db. Dry-run default, `--apply` performs delete. Verified: 0 stale (nothing deleted), drift still clean, stats stable at 584. Registered in AGENTS.md line 22.

## Decisions

- Root `patlib.db` was stale, not canonical — removed with backup, no migration needed (51 unique rows had no backing files).
- `semantic-drift.ts` targets `.opencode/patlib.db` (paths.ts `Database` const) — consistent with all other semantic tools.
- Drift tool is read-only per `MAX.ORTHOGONALITY`; purge of stale embeddings stays a manual/separate step (embed's `--force` upsert path).

## Open edges

- Stale-row purge now has a dedicated write tool (`semantic-purge.ts`) — dry-run default, `--apply` deletes. Verified 0 stale at creation.
- Consider wiring `semantic-drift --check` into post-sync maintenance once sync tools return.
- AGENTS.md entities naming table (lines 32-37) lists `.opencode/patterns/`, `.opencode/terms/`, `.opencode/commands/`, `.opencode/maxims/` — actual entity files live under `.opencode/entities/` subdirectories; the naming table may warrant reconciliation.

## Todo state

- Verify semantic-stats alignment post-cleanup: done (584, clean)
- Audit semantic-drift.ts: done (pass)
- Register semantic-drift in AGENTS.md: done
- Write task report: done
- Reconcile AGENTS.md root tool list: done
- semantic-purge.ts created + verified: done (0 stale, no deletion)
