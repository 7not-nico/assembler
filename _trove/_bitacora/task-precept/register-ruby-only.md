# register-ruby-only.md

**Layer:** precept/
**Naming:** `{action}-{domain}.md` — declarative, atomic.
**Composes with:** `_scripts/register-invariants.rb`, `task-invariant/invariants.md` (I4).

## Rule

All findings.db interaction runs in functional Ruby (`.rb`). Bash never writes the DB; sqlite3 CLI reads for verification only.

## Scope

DB-level. Applies to every catalog write: register, upsert, prune, migrate.

## Why

The project convention splits the pipeline by language: bash acquires (binary imperative shells), Ruby persists (pure lambdas, bind parameters, upsert via `ON CONFLICT(id) DO UPDATE`). Ruby gives the write path one shape and one audit point.

## Practice

```
- writes:  ruby _scripts/register-invariants.rb (reads meta.json)
- reads:   sqlite3 SELECT allowed for verification (F5)
- never:   sqlite3 INSERT/UPDATE/DELETE from bash
```

## Instance

2026-07-31 — register-invariants.rb performs the 9-paper upsert; bash scripts verify only.
