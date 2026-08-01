---
id: PROT.CONCEPT.SCHEMA
title: Concept Identity — Non-Physical Encyclopedic Entity
source: NEX.META.PROPOSAL
summary: "Defines the concepts/ directory and CON.* entity type — schema, body convention, enforcement, and relationship to other entity types."
protocol: "A concept defines a non-physical idea — second layer of the Encyclopedic group. source points to a COG.* cognition. related connects to other CON.* entities horizontally."
enforcement: Sealed
tags: [concept, knowledge, classification, entity-type]
status: active
priority: 2
---

The concept domain holds universal non-physical ideas that exist independently of the project. Concepts answer *what idea*. Cognitions answer *what domain*. Definitions answer *what thing*. Terms answer *what label*.

## Protocol

### Schema

Every concept file requires six backmatter fields: `id` (required, `CON.{NAME}` uppercase dot-separated), `title` (required, human-readable name), `source` (required, COG.* ID — the cognition this concept belongs to), `related` (optional, entity ID array — other CON.* IDs only), `tags` (required, comma-separated, no spaces), `reference` (required, array of `{title, url}`; minimum 3).

### Body convention

First line: `**{Title}** — {1-3 sentence description}`. Optional subsections follow.

### Content rules

- Tags: comma-separated — spaces excluded
- References: minimum 3 authoritative sources with URL+title
- Related: limited to other CON.* IDs — horizontal layer only
- source: a valid COG.* ID — the vector points upward to the containing cognition
- Concepts describe non-physical ideas — no chemical properties. If an entity describes something with chemical properties, it belongs in definitions/
- Sync: name-to-name into `concepts` table — DB cache, file is source of truth

## Gotchas

- source absent or invalid: Concepts require source pointing to a valid cognition (source field missing or contains non-COG value)
- source points to non-COG entity: source must be a COG.* ID — the layer above (source field contains CON.* or DEF.* or TERM.* ID)
- related links to non-CON entities: related is horizontal only — link only to other CON.* IDs (related array contains COG.* or DEF.* or TERM.* IDs)
- Body describes physical properties: Entity describes a physical thing — move to definitions/ (Body mentions chemical composition, mass, or material structure)
- Less than 3 references: Add authoritative sources — textbooks, papers, official docs (`reference:` array length < 3)
- Tags contain spaces: Replace with hyphenated form: `abstract-algebra` (`tags: abstract, algebra` with space)
- ID field mismatches filename: Match filename prefix to id value (File named `CON.FOO.md`; id field value: `CON.BAR`)

## Enforcement

`read-validate` verifies every concept file against this protocol: backmatter fields present and correctly formatted, minimum 3 references, tag format compliance, body starts with bold-title convention.

## Applicability

All concept entities in `.opencode/concepts/`. The protocol applies to root-level entities only.

## See also

- `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` — groups, layers, vector rules
- `PROT.COGNITION.SCHEMA` — cognition entity protocol
- `PROT.DEFINITION.SCHEMA` — definition entity protocol
- `PROT.TERM.SCHEMA` — term entity protocol
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention for all entity types
- `REF.META.REFERENCE.AUTHORITY` — reference source hierarchy by entity type
