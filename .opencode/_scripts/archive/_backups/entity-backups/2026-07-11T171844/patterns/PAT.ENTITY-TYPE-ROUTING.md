---
id: PAT.ENTITY-TYPE-ROUTING
title: "Entity-Type Routing — First ID segment maps entity type to directory and DB table"
source: "AMANDA cross-project"
summary: "The first segment of a dot-separated ID routes entities to their storage directory and DB table, with validation enforcing the mapping."
principle: "Every entity type has a controlled prefix (first ID segment) that determines its file directory and DB table. Each prefix maps to exactly one table; multiple prefixes may share a table within an abstraction plane."
enforcement: Tool
tags: [convention, naming, data-flow, architecture, routing]
patterns: []
terms: []
status: active
priority: 2
---

Projects managing multiple entity types need deterministic routing from entity identity to storage location and validation rules. Encoding the entity type as the first ID segment makes this routing explicit, automatable, and verifiable.

## Examples

| Project | Prefix → Directory → DB table |
|---------|-------------------------------|
| ludoteca | `GAME.*` → `games/` → `games`, `HACK.*` → `hacks/` → `hackroms`, `EMU.*` → `emulators/` → `emulators`, `ARCH.*` → `architectures/` → `architectures` |
| palestra | `SRC.*` → `sources/` → `sources`, `CONC.*` → `concepts/` → file-only, `INSP.*` → `inspirations/` → file-only |
| nerdfont | `NF.*` → `sets/` → `sets`, `NF.FONT.*` → `fonts/` → `fonts` |
| bitacora | `FIX.*` → `fixes/` → `fixes`, `STUDY.*` → `studies/` → `studies`, `IMPR.*` → `impressions/` → `impressions` |
| thoughtlog | `TERM.*` → `terms/` → `terms`, `THOUGHT.*` → `thoughts/` → `thoughts` |
| medcodes | `CS.*` → `systems/` → `codesystems`, `SRC.*` → `sources/` → `sources`, `IMPR.*` → `impressions/` → `impressions` |
| CR-news-outlets | `OUT.*` → `outlets/` → `outlets`, `CONC.*` → `concepts/` → `concepts`, `REF.*` → `references/` → `references` |
| constructive-drawing | `BONE.*` → `structural-planes/` → `bones` (shared: `JOINT`, `LANDMARK` also → `bones`), `MUSCLE.*` → `form-planes/` → `muscles` (shared: `TENDON`, `LIGAMENT`, `FASCIA`), `FAT.*` → `surface-planes/` → `surface_structures` (shared: `SKIN`, `FOLD`) |

## Rules

1. **Controlled prefix vocabulary** — every prefix maps to exactly one DB table and one directory. Unknown prefixes fail validation.
2. **Prefix-to-table is one-to-one** — a single prefix never routes to multiple tables. Multiple prefixes may share a table if they share the same schema and abstraction plane (e.g., `BONE`, `JOINT`, `LANDMARK` → `bones` table).
3. **Tool enforcement** — a validate tool checks every file: prefix matches directory, ID matches regex, required fields present, no orphan DB records.
4. **Frontmatter is source of truth** — constants in YAML frontmatter. DB is derived cache, never written back.
5. **ID is sole cross-reference** — entities reference each other via full ID (`BONE.FEMUR`, `MUSCLE.TRICEPS`), never by title or filename.

## Applicability

Use when a project manages two or more entity types that share a database and need consistent lookup, type-based validation, and automated integrity checks.

Not applicable when a project has a single entity type or uses no database.

## See also

- `constructive-drawing/AGENTS.md` — anatomy naming conventions
- `ludoteca/AGENTS.md` — game catalog ID formats
- `palestra/AGENTS.md` — study source ID format
- `PAT.DRY` — single authoritative representation (related principle)
