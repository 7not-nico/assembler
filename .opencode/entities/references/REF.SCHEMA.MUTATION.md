---
id: REF.SCHEMA.MUTATION
title: "Seed File Mutation Convention — Prefix Declares Strategy"
source: PROT.SCHEMA.FORMAT
related: []
summary: "Seed file prefix range declares mutation strategy: `00-*` appends, `01-*` and higher upserts. The prefix IS the declaration — no need to inspect the SQL verb."
ref: "00-* prefix seeds use append (INSERT OR IGNORE). 01-* and higher prefixes use upsert (INSERT OR REPLACE or ON CONFLICT DO UPDATE). The prefix range declares the mutation strategy without inspecting the SQL."
tags: [schema, seed, mutation, convention, naming]
---

Every seed file's numeric prefix range declares its mutation strategy. The prefix IS the contract.

## Protocol

1. **`00-*` prefix = append** — `INSERT OR IGNORE`. New lines add rows; existing rows (matched by UNIQUE or PK) remain intact. For reference data where history is fixed, every row is independently meaningful, and re-running adds new entries without altering past ones.
2. **`01-*` and higher prefix = upsert** — `INSERT OR REPLACE` or `ON CONFLICT(id) DO UPDATE SET ...`. Re-running overwrites with latest state. For entity data where the seed file is the authoritative source, stale rows have no value, and re-running overwrites with the latest state.
3. **The prefix range is the declaration** — no need to inspect the SQL verb to understand mutation behavior. A `00-*` file using `INSERT OR REPLACE` violates the convention. A `01-*` file using `INSERT OR IGNORE` violates the convention.
4. **Dependencies resolve by prefix order** — `00-*` runs first, `01-*` second, `02-*` third. The execution order matches the mutation strategy: append-first, upsert-after.
5. **Change prefix when mutation strategy changes** — if a seed set grows beyond its original scope such that the data should shift from append to upsert (or vice versa), renumber it to the correct range. Keep prefix and SQL verb aligned.
6. **Table-level mutation semantics override file-level convention** — the file-level upsert convention governs entity tables only. Tables whose schema specifies append semantics retain `INSERT OR IGNORE` within any seed file prefix.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| `00-*` file using `INSERT OR REPLACE` | 00-prefix with upsert SQL | Change to `INSERT OR IGNORE` — reference data is append |
| `01-*` file using `INSERT OR IGNORE` | 01-prefix with append SQL | Change to `INSERT OR REPLACE` — entity data is upsert |
| Same prefix used by two files | Prefix collision in seed directory | Assign unique prefix per domain |
| Prefix and SQL verb disagree | Mixed signal — filename says one thing, SQL does another | Align one to the other — change the verb OR renumber the file |

## Enforcement

Code review. The prefix range is checked against the SQL verb in each seed file. Matching conventions pass; mismatches require correction. Audit tools may scan seed directories and flag prefix-verb mismatches automatically.

Format conventions are enforced by `file.edited` hooks on opencode editor saves. Agent Write/Bash tool edits to seed files are covered by `tool.execute.after` handlers. Seed files that violate format rules are auto-corrected: redundant INSERT statements merge into one per table and columns group, tuple indent normalizes to a uniform width, and field values normalize to canonical form per column scope. Each correction is available as an invocable tool with batch and dry-run flags.

## Applicability

All schema-driven projects using seed files with numeric prefixes — every `.opencode/` project within the AMANDA assembler ecosystem.

## See also

- `PROT.SCHEMA.FOLDER` — schema folder structure and seed file layout
- `PROT.LIB.MUTATION.STRATEGY` — append vs upsert SQL mechanism at the table level
- `PROT.SCHEMA.SEED.MUTATION` — this protocol (prefix declares mutation strategy)
- `PROT.PLUGIN.LIFECYCLE` — hook matrix with trigger source disambiguation
