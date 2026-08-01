# catalog-architecture.md — how the catalog works

**Layer:** task-study/
**Naming:** `{topic}.md` — architecture documents for the catalog and its pipeline.
**Composes with:** `task-backup/` (diff anchor), `task-fixture/fixtures.md`, `_trove/AGENTS.md`.

## Architecture

The trove catalog runs a two-phase pipeline: acquisition then registration. Bash scripts download and validate PDFs; a Playwright crawl captures metadata into `meta.json`; functional Ruby upserts into `findings.db`; the `.opencode/` TS toolchain searches and serves the catalog. The arxiv export API rate-limits bursts (1 req/3s), so metadata capture routes through the browser when the API stalls.

## Diagrams / Flow

```
arxiv search (MCP) → core selection
  → download-invariants.sh  (curl + %PDF magic, exit 1 on failure)
  → {domain}/{subdomain}/*.pdf
  → Playwright crawl → meta.json (citation_title/author/date, primary-subject)
  → register-invariants.rb (sqlite3 upsert, ON CONFLICT DO UPDATE)
  → findings.db (papers + arxiv_metadata)
  → toolchain query (papers-query, semantic-search, mcp-findings)
```

## Change inventory — files and code lines

Authoritative diff anchor: `_backup/findings-{date}.db` (first migration or bulk edit). Every edited line listed:

| File | Lines | Change |
|------|-------|--------|
| `_scripts/download-invariants.sh` | 1–60 | acquisition: curl + validation, 1112.6290 v3→v2 pin |
| `_scripts/register-invariants.rb` | 1–98 | registration: meta.json → findings.db upsert, Ruby-only |
| `math/invariant-theory/meta.json` | 1–64 | metadata capture for 8 papers |

The change inventory is the authoritative list — the fixtures derive from it.

## Verification

`file` sweep on the catalog (all `%PDF`), `sqlite3` SELECT by subdomain (8 rows, populated fields), harness reruns F1–F5 after any change.

## Instance

invariant-theory acquisition (2026-07-31) — first pipeline run: 8 papers acquired, validated, registered; verified via F3 + F5.
