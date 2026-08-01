# Taxonomy & Derivation Maxims — Entity Classification Expansion

2026-07-25T05:45:00Z

## Timeline

| Timestamp | Event |
|-----------|-------|
| 2026-07-25T04:15:00Z | Started: `BIO.BACTERIA` creation |
| 2026-07-25T04:20:00Z | Started: `DEF.ORGANELLE` `source` fix |
| 2026-07-25T04:30:00Z | Classified organisation as project candidate; created `MAX.PROJECTION.DERIVATION` |
| 2026-07-25T04:35:00Z | Migrated `DEF.ORGANELLE` → `BIO.ORGANELLE` |
| 2026-07-25T04:45:00Z | Derived `BIO.CACTUS` as project candidate |
| 2026-07-25T04:50:00Z | Traced grizzly bear precedence chain; identified taxonomy gap |
| 2026-07-25T05:00:00Z | Updated `MAX.KNOWLEDGE.CLASSIFICATION` — added Taxonomy to Ring 2, updated source vector rule to "closest preceding entity" |
| 2026-07-25T05:05:00Z | Added composition direction rule to `MAX.ENTITY.ONTOLOGY` |
| 2026-07-25T05:15:00Z | Created `X` protocol |
| 2026-07-25T05:20:00Z | Created `TAX.MAMMALIA`, `TAX.CARNIVORA`, `TAX.URSIDAE` |
| 2026-07-25T05:25:00Z | Created `BIO.GRIZZLY.BEAR` linking to `TAX.URSIDAE` |
| 2026-07-25T05:30:00Z | Wired taxonomy sync pipeline (paths, sync, schema, mcp-query) |
| 2026-07-25T05:40:00Z | Full sync verified — 3 taxons, 4 bios, 21 maxims, 37 protocols |

## Decisions

- `MAX.PROJECTION.DERIVATION` created as separate maxim (not merged into `MAX.PRECEDENCE.DERIVATION`) — inward-gaze vs backward-gaze are orthogonal principles
- Composition direction rule added to `MAX.ENTITY.ONTOLOGY` — outer entity cites inner, never reverse
- `TAX.*` entities at Ring 2 — source follows "closest preceding entity" (same ring when chain continues, inner ring when chain ends)
- Entity waste table avoided in maxim — uses ring layer reference instead of hardcoded prefixes

## Errors

- `write-sync --type taxonomy` failed via plugin tool (schema validation rejected type not in description string) — worked via direct `bun -e` calling `syncAll`. Fix: update write-sync.ts tool's arg description to include `taxonomy`.
- `precedes` null in initial taxonomy sync — parser omitted the field. Fixed by adding to `parseTaxFile` and column list.
- `parseTaxFile` originally omitted `rank` — added after first dry-run.
- Taxonomy excluded from `--type all` in original write-sync tool description — but works via direct `syncAll(db, 'all')`. Description needs update.

## Open Edges

- `BIO.CACTUS` discussed but not yet declared — want to proceed?
- Taxonomy entities currently use `precedes` and `source` but no dedicated MCP server for chain traversal queries — the `mcp-patlib` server supports taxonomy type but chain walkthrough requires manual SQL
- `BIO.TARDIGRADA` and `BIO.BACTERIA` still source directly to `COG.BIOLOGY` — no TAX ancestors declared for them yet
- `write-sync` tool arg description needs update to list taxonomy

## Todo State Summary

- `MAX.PROJECTION.DERIVATION` → created
- `MAX.KNOWLEDGE.CLASSIFICATION` → updated (Ring 2, source rule)
- `MAX.ENTITY.ONTOLOGY` → updated (composition direction)
- `X` → created
- `TAX.MAMMALIA`, `TAX.CARNIVORA`, `TAX.URSIDAE` → created
- `BIO.GRIZZLY.BEAR` → created
- `BIO.CACTUS` → pending
- Sync pipeline → wired and verified
