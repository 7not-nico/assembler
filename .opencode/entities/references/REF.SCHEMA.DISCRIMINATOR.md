---
id: REF.SCHEMA.DISCRIMINATOR
title: "Polymorphic Junction — One Junction Table for All Entity References"
source: PROT.SCHEMA.AUGMENT
summary: A single junction table with a discriminator column replaces per-entity junction tables when multiple entity types reference a shared registry. Controlled vocabularies use seed tables, not SQL CHECK constraints, for extensibility.
ref: When N entity types reference the same target table (sources, URLs, tags), use one polymorphic junction table with an entity_type discriminator instead of N separate junction tables. Seed-populated tables are preferred over CHECK enums when the allowed value set may grow without schema changes.
tags: [data-flow, database, schema, architecture, junction, polymorphism, controlled-vocabulary]
related:
  - PROT.META.ENTITY.ROUTING
  - PROT.LIB.MUTATION.STRATEGY
  - MAX.CODE.DRY.PRINCIPLE
---

When designing cross-references between entity types and a shared registry (sources, URLs, tags), two naive approaches emerge:

- **One junction table per entity** — conceptually clean but proliferates tables. N entities × 1 shared registry = N junction tables. Schema grows linearly.
- **Comma-joined TEXT column** — no FK enforcement, requires `LIKE` queries, no referential integrity at the database level.

The polymorphic junction solves both: one table with `(entity_id, ref_id)` composite PK plus an `entity_type` discriminator column. The entity type maps to a table via either the ID prefix (`PAT`→`patterns`) or full table name (`patterns`), following `PROT.META.ENTITY.ROUTING` and `PROT.ILLUSTRATION.SCHEMA`. The `illustration_entities` table at root scope uses this pattern to link every illustration to the patterns and protocols it walks through.

## Examples

| Project | Pattern | Notes |
|---------|---------|-------|
| linguistic | `entity_sources(entity_id, source_id, entity_type)` | All 5 entity types share one sources junction |
| CR-news-outlets | `concept_refs(concept_id, ref_id)` — per-entity | Type-specific semantics for concept→outlet links |
| nerdfont (historic) | Separate `set_notes`, `font_notes`, `note_refs` | Three tables when one polymorphic would suffice |
| assembler | `illustration_entities(illustration_id, entity_id, entity_type)` | Junction from illustrations to patterns/protocols — illustrates links via ID prefix routing |

The same principle applies to controlled vocabularies. Instead of:

```sql
category TEXT CHECK(category IN ('phonology', 'morphology', 'syntax'))
```

Use a seed-populated lookup table:

```sql
CREATE TABLE feature_categories (code TEXT PRIMARY KEY, name TEXT);
INSERT OR IGNORE INTO feature_categories VALUES ('phonology', 'Phonology');
```

Adding a new category becomes a seed INSERT instead of an ALTER TABLE.

## Rules

1. **Discriminator column** — the `entity_type` value maps to the entity table. Two conventions are valid: (a) the ID prefix from `PROT.META.ENTITY.ROUTING` (e.g. `LNG`, `FAM`, `FEAT`), or (b) the full table name (`patterns`, `protocols`). Use prefix when the junction references external projects; use table name when all routes are local. The mapping must be consistent within a single junction. `read-validate` supports both via `ID_PREFIX_TO_ENTITY_TYPE` (prefix→table) and `ENTITY_TABLE` (name→table) maps.

2. **One polymorphic junction per shared target** — if entities reference both sources and tags, that's two tables (`entity_sources`, `entity_tags`). Polymorphism applies per target, not globally.

3. **Validate at the gate** — `read-validate` checks every `(entity_id, entity_type)` pair resolves to a real entity. Orphans are reported as broken FK references.

4. **Seed tables over CHECK enums** — if a controlled vocabulary may grow, model it as a seeded table. Use CHECK only when values are fixed by external standard (ISO codes, mathematical constants).

5. **Use per-entity junctions when semantics differ** — if a language→source link carries metadata that a feature→source link doesn't (e.g., `page_number`), separate tables are correct. Polymorphism is for structurally identical references.

## Applicability

Use when two or more entity types reference the same target table with identical semantics (same FK, no extra metadata per entity type).

Use per-entity junctions when each entity type needs different metadata on the link (extra columns per entity type).

## See also

- `ILL.SCHEMA.JUNCTION.MAP` — polymorphic junction walkthrough
- `PROT.META.ENTITY.ROUTING` — entity→directory mapping, the discriminator foundation
- `PROT.LIB.MUTATION.STRATEGY` — upsert vs append for the junction rows
- `MAX.CODE.DRY.PRINCIPLE` — single authoritative representation per reference
- `linguistic/AGENTS.md` — canonical implementation
- `PROT.ILLUSTRATION.SCHEMA` — protocol for illustration entities whose `illustrates:` field populates an `illustration_entities` junction
