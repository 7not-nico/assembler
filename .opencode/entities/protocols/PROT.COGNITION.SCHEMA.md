---
id: PROT.COGNITION.SCHEMA
title: Cognition Identity — Encyclopedic Domain Entity
source: NEX.META.PROPOSAL
summary: "Defines the cognitions/ directory and COG.* entity type — schema, body convention, enforcement, and relationship to other entity types."
protocol: "A cognition defines a domain of knowing — first layer of the Encyclopedic group. Location: cognitions/COG.*.md with COG.* ID prefix. source points to general (top layer). related connects to other COG.* entities horizontally."
enforcement: Sealed
tags: [cognition, knowledge, classification, entity-type]
status: active
priority: 2
---

The cognition domain holds knowledge domain entries that define broad fields of study. Cognitions answer *what domain*. Concepts answer *what idea*. Definitions answer *what thing*. Terms answer *what label*.

## Protocol

### Schema

Every cognition file requires six backmatter fields: `id` (required, `COG.{NAME}` uppercase dot-separated), `title` (required, human-readable name), `source` (required, `general` for first-layer entities), `related` (optional, entity ID array — other COG.* IDs only), `tags` (required, comma-separated, no spaces), `reference` (required, array of `{title, url}`; minimum 3).

### Body convention

First line: `**{Title}** — {1-3 sentence description}`. Optional subsections follow.

### Content rules

- Tags: comma-separated — spaces excluded
- References: minimum 3 authoritative sources with URL+title
- Related: limited to other COG.* IDs — horizontal layer only
- source: `general` — cognition is the top layer, nothing above
- Hierarchical IDs: sub-domains use dot-segmentation (e.g., `COG.CHEMISTRY.ORGANIC`, `COG.CHEMISTRY.INORGANIC`)
- Sync: name-to-name into `cognitions` table — DB cache, file is source of truth

## Gotchas

- source missing or invalid: Cognitions are top layer — source requires `general` (source field absent or contains non-general value)
- related links to non-COG entities: related is horizontal only — link only to other COG.* IDs (related array contains CON.* or DEF.* or TERM.* IDs)
- Less than 3 references: Add authoritative sources — textbooks, papers, official docs (`reference:` array length < 3)
- Tags contain spaces: Replace with hyphenated form: `computer-science` (`tags: computer, science` with space)
- ID field mismatches filename: Match filename prefix to id value (File named `COG.FOO.md`; id field value: `COG.BAR`)

## Enforcement

`read-validate` verifies every cognition file against this protocol: backmatter fields present and correctly formatted, minimum 3 references, tag format compliance, body starts with bold-title convention.

## Applicability

All cognition entities in `.opencode/cognitions/`. The protocol applies to root-level entities only — subproject cognitions excluded.

## See also

- `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` — groups, layers, vector rules
- `PROT.CONCEPT.SCHEMA` — concept entity protocol
- `PROT.DEFINITION.SCHEMA` — definition entity protocol
- `PROT.TERM.SCHEMA` — term entity protocol
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention for all entity types
- `REF.META.REFERENCE.AUTHORITY` — reference source hierarchy by entity type
