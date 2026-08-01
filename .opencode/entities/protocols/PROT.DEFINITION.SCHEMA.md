---
id: PROT.DEFINITION.SCHEMA
title: Definition Identity — Physical Encyclopedic Entity
source: NEX.META.PROPOSAL
summary: "Defines the definitions/ directory and DEF.* entity type — schema, body convention, enforcement, and relationship to other entity types."
protocol: "A definition describes a physical thing — second layer of the Encyclopedic group. source points to a COG.* cognition. related connects to other DEF.* entities horizontally."
enforcement: Sealed
tags: [definition, knowledge, classification, entity-type]
status: active
priority: 2
---

The definition domain holds physical things that exist in space-time with chemical properties. Definitions answer *what thing*. Cognitions answer *what domain*. Concepts answer *what idea*. Terms answer *what label*.

## Protocol

### Schema

Every definition file requires six backmatter fields: `id` (required, `DEF.{NAME}` uppercase dot-separated), `title` (required, human-readable name), `source` (required, COG.* ID — the cognition this definition belongs to), `related` (optional, entity ID array — other DEF.* IDs only), `tags` (required, comma-separated, no spaces), `reference` (required, array of `{title, url}`; minimum 3).

### Body convention

First line: `**{Title}** — {1-3 sentence description}`. Optional subsections follow.

### Content rules

- Tags: comma-separated — spaces excluded
- References: minimum 3 authoritative sources with URL+title
- Related: limited to other DEF.* IDs — horizontal layer only
- source: a valid COG.* ID — the vector points upward to the containing cognition
- Definitions describe physical things with chemical properties. If an entity describes a non-physical idea, it belongs in concepts/
- Sync: name-to-name into `definitions` table — DB cache, file is source of truth

## Gotchas

- source absent or invalid: Definitions require source pointing to a valid cognition (source field missing or contains non-COG value)
- source points to non-COG entity: source must be a COG.* ID — the layer above (source field contains CON.* or DEF.* or TERM.* ID)
- related links to non-DEF entities: related is horizontal only — link only to other DEF.* IDs (related array contains COG.* or CON.* or TERM.* IDs)
- Body describes pure abstraction: Entity describes a non-physical idea — move to concepts/ (Body mentions only mathematical or logical properties with no physical referent)
- Less than 3 references: Add authoritative sources — textbooks, papers, official docs (`reference:` array length < 3)
- Tags contain spaces: Replace with hyphenated form: `cell-biology` (`tags: cell, biology` with space)
- ID field mismatches filename: Match filename prefix to id value (File named `DEF.FOO.md`; id field value: `DEF.BAR`)

## Enforcement

`read-validate` verifies every definition file against this protocol: backmatter fields present and correctly formatted, minimum 3 references, tag format compliance, body starts with bold-title convention.

## Applicability

All definition entities in `.opencode/definitions/`. The protocol applies to root-level entities only.

## See also

- `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` — groups, layers, vector rules
- `PROT.COGNITION.SCHEMA` — cognition entity protocol
- `PROT.CONCEPT.SCHEMA` — concept entity protocol
- `PROT.TERM.SCHEMA` — term entity protocol
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention for all entity types
- `REF.META.REFERENCE.AUTHORITY` — reference source hierarchy by entity type
