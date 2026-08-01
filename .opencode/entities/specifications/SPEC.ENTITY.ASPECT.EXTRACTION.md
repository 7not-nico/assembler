**Aspect Extraction** — when ≥2 entity files declare inline variants of the same aspect, extract that aspect to its own entity type with its own prefix. The inline variant STOPS being inline and BECOMES a first-class entity.

## Trigger

≥2 entity files share a structurally repeated aspect (field, section, concept, relation) that each defines inline with its own variant.

## Extraction

The shared aspect becomes a first-class entity with:

1. **Prefix** — `ASPECT.*` (e.g., `IDENTITY.*`), distinct from all existing prefixes
2. **Directory** — `.opencode/entities/aspect/` (e.g., `.opencode/entities/identities/`)
3. **Persistence** — `CREATE TABLE IF NOT EXISTS aspects (...)` in `_schemas/`
4. **Parser** — `parseAspectFile` is added to `_lib/parse.ts`
5. **Sync** — a `syncTable(...)` block is added to `sync.ts`
6. **Registration** — `ENTITY_TYPES` and `ID_PREFIX_TO_ENTITY_TYPE` in `mcp-types.ts`; `PrefixToType` in `patlib.rb`; ring mapping in `rings.rb`
7. **Enum** — the `type` enum in `patlib_search` and `patlib_get` is extended with the new type

## After

- Original entity files reference the extracted entity by ID only — no inline content
- Source entity files remain; the extracted entity is a deduplication, not a deletion

## Scope

Entity system topology only — data extraction (e.g., extracting a shared field value to a lookup table) is not aspect extraction.

---
id: SPEC.ENTITY.ASPECT.EXTRACTION
title: Aspect Extraction — Repeated Inline Aspect → First-Class Entity Prefix
source: assembler
summary: "When ≥2 entity files declare inline variants of the same aspect, extract that aspect to its own entity type with its own prefix, directory, DB table, parser, sync block, and registration."
specifies: Aspect extraction trigger and process (≥2 files share an aspect)
tags: [entity-type, aspect, extraction, refactoring, prefix, specification]
status: active
---
