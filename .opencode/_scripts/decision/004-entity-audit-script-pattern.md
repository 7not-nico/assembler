# 004 — Entity Audit Script Pattern

**Date:** 2026-07-25T21:16:06-06:00
**Status:** Accepted

## Context

Need to validate entity-specific structure (required fields, ID patterns, valid enumerations) beyond generic cross-entity checks. Three entity types have distinct schemas: maxims (`principle:`), protocols (`protocol:`), and patterns (`principle:`).

## Decision

Create one `r2-{type}-audit.rb` per entity type at code ring 2 (DB-READ — entity attribute validation). Each audit checks:

1. All required frontmatter fields present
2. ID matches entity type pattern (`MAX.*`, `PROT.*`, `PAT.*`)
3. Status is valid set (`active`, `draft`)
4. Priority is positive integer
5. Enforcement is valid set for that entity type
6. Tags are array format
7. Summary, principle (or protocol), title, source non-blank
8. Optional fields (reference, related) have correct types when present

## Consequences

- 3 audit scripts created: `r2-maxim-audit.rb`, `r2-protocol-audit.rb`, `r2-pattern-audit.rb`
- All 67 files (22+38+7) pass with 0 violations
- Pattern extensible to other entity types (terms, persons, nexus) if needed
