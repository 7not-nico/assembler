# 006 — Schema-Driven Audits

**Date:** 2026-07-25
**Status:** Accepted

## Context

Audit scripts (maxim, protocol, pattern) hardcoded validation rules — field names, types, enums, patterns all embedded in Ruby code. Adding a field required editing the script.

## Decision

Replace hardcoded validation with schema-driven audits:

1. Entity field definitions stored in SQL `schema/{NN}-{type}.sql` seed files
2. `SeedDB` runs DDL + seeds to populate `entity_types` + `fields` tables
3. `QueryFields` reads field rules from DB
4. `CheckField` / `CheckRequired` from `_rb/validate.rb` apply rules generically
5. `LogRun` records each audit run in `schema_runs` for traceability

## Consequences

1. Adding a field = editing `.sql` seed file, not Ruby code
2. All 7 entity audit scripts now follow the same pattern (SeedDB → QueryFields → CheckField → LogRun)
3. 9 `_rb/` modules at ring 1 (PURE) shared across 14 `r*.rb` scripts
4. Schema DB provides run history via `schema_runs` table
