# Backup convention — catalog restore points

**Layer:** task-backup/
**Naming:** `_trove/_backup/findings-{YYYYMMDD}-{HHMMSS}.db` (+ `meta-{YYYYMMDD}-{HHMMSS}.json` when metadata is mid-crawl).
**Composes with:** `task-study/catalog-architecture.md` (change inventory references the anchor), schema migrations and bulk edits (backup precedes them).

## Convention

1. Backup precedes any schema migration or bulk catalog edit — a restore point exists before the first change.
2. `_trove/_backup/findings-{YYYYMMDD}-{HHMMSS}.db` holds the pre-change registry (VACUUM INTO copy, WAL checkpointed).
3. `meta-{YYYYMMDD}-{HHMMSS}.json` captures pre-edit metadata state when a crawl is mid-flight.
4. Every change inventory lists its diff anchor: `_backup/findings-{date}.db` vs `findings.db`.
5. A new backup is taken when a new migration/edit phase begins; the inventory points at the phase's anchor.

## Verification

A restore of the anchor reproduces the pre-change catalog exactly — row count, latest ids, and arxiv_metadata rows match the recorded pre-change state.

## Instance

{date, project, outcome — the phase whose backup anchored the change inventory}
