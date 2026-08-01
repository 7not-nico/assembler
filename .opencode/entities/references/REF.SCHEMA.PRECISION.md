---
id: REF.SCHEMA.PRECISION
title: "Temporal Precision — Three-Nullable-Int Event Dates"
source: PROT.SCHEMA.AUGMENT
related: [PROT.PERSON.SCHEMA, PROT.SCHEMA.FOLDER, PROT.LIB.MUTATION.STRATEGY]
summary: "Event dates use three nullable integers (year, month, day) aligned with ISO 8601-1 reduced precision (Level 0 EDTF). NULL represents unknown. ORDER BY sorts precise events ahead of vague ones within the same year."
ref: "Entity event dates use year, month, day as separate nullable integer columns. Month and day are INTEGER DEFAULT NULL. NULL = component unknown; zero excluded. Sort by year ASC, month ASC NULLS LAST, day ASC NULLS LAST."
tags: [temporal, schema, event, data]
---

Dates stored as three nullable ints: year, month, day. NULL for unknown components. Event data lives in seed files; frontmatter excluded.

## Protocol

1. Store temporal components as separate nullable INTEGER columns — year required integer, month optional integer, day optional integer
2. Use NULL for unknown components — zero and placeholder sentinels excluded. Use NULL instead to represent unrecorded or inapplicable values
3. Sort by `year ASC, month ASC NULLS LAST, day ASC NULLS LAST` — more-precise events cluster ahead of less-precise within the same year
4. Derive sub-year groupings (semester, quarter, season, decade) from month — no separate columns. Month 1-3 = Q1, 4-6 = Q2, 7-9 = Q3, 10-12 = Q4

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| month/day as TEXT | Schema shows month TEXT or day TEXT | Use INTEGER — enables numeric sorting and arithmetic |
| NULL used as value 0 | month=0 or day=0 in data | Use NULL for unknown; month range 1-12, day range 1-31 |
| EXPECT NULLS FIRST sort | Query orders by month ASC without NULLS LAST | Use `ORDER BY month ASC NULLS LAST` — unknown components belong after known |
| Non-Gregorian calendar dates | month > 12 or day > 31 | Gregorian only per ISO 8601-1. Non-Gregorian calendars excluded from scope |
| month/day without year | month or day provided with year=NULL | Year required; month/day optional refinements |

## Enforcement

`initDB()` loads seed files from `_schemas/seeds/*.sql`, which populate the `events` table and `person_events` links. `read-validate` checks person entity fields at file level. Sort ordering enforced at query layer — both `_lib/mcp-query.ts` and `tools/read-projection.ts` use `ORDER BY year, month NULLS LAST, day NULLS LAST`.

## Applicability

All entity types with event timelines — persons, projects, organizations, or any entity with year-based events. Excluded from non-temporal entity metadata (creation/modified timestamps use ISO 8601 text).

## See also

- `PROT.PERSON.SCHEMA` — first consumer: implements temporal precision for person events with month/day
- `PROT.SCHEMA.FOLDER` — DDL for temporal columns follows schema folder conventions; seed data in `seeds/02-events.sql`
- `PROT.LIB.MUTATION.STRATEGY` — additive ALTER TABLE ADD COLUMN pattern for schema evolution
