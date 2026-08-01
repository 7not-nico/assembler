# 001 — Ring Naming Convention

**Date:** 2026-07-25T21:15:59-06:00
**Status:** Accepted

## Context

Script filenames use `r*` prefix. Earlier scripts used sequential numbering (r1, r2, r3, r4) with no clear mapping. New scripts extended this to r5–r9. No convention defined what the number meant.

## Decision

`r{ring}` maps to MAX.CODE.LAYERS verification model:

| Ring | Name | What scripts verify |
|------|------|---------------------|
| r1 | PURE | Foundational data integrity, counting, raw dumps |
| r2 | DB-READ | Entity metadata, attributes, relationships, structure |
| r3 | LOCAL-READ | Cross-file reference resolution |
| r4 | REMOTE-READ | (no scripts yet) |
| r5 | LOCAL-WRITE | (no scripts yet) |
| r6 | REMOTE-WRITE | (no scripts yet) |
| r7 | DB-WRITE | (no scripts yet) |

The ring number indicates what layer the script **verifies**, not what I/O level it operates at.

## Consequences

- Existing r1–r4 scripts audited: `entity-count` and `frontmatter-dump` moved from r4→r1
- New scripts use code ring numbers (1–7), not knowledge classification rings (0–6)
- `r` in filename is sufficient — "ring" dropped from descriptive names
