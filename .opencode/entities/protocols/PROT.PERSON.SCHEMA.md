---
id: PROT.PERSON.SCHEMA
title: "Person Entity — Physical and Jurisdictional Identity"
source: NEX.META.PROPOSAL
related: []
summary: "Persons (PER.*) are entities with two subtypes: physical (human) and jurisdictional (organization, institution). Identity and metadata in frontmatter; events managed by REF.PERSON.EVENT.TIMELINE."
protocol: "Every person entity follows the PER.* ID prefix convention. Files live in .opencode/entities/persons/ with identity and metadata only — no inline events. subtype field discriminates physical vs jurisdictional. Events governed by REF.PERSON.EVENT.TIMELINE."
enforcement: Sealed
status: active
priority: 2
tags: [entity, person, timeline, event, schema, data]
---

Entities with a year-based timeline. Events stored in seed data, linked via person_events junction table. Two subtypes: physical and jurisdictional.

## Protocol

1. **Use PER.* ID prefix** — person IDs follow `PER.{NAMESPACE}.{NAME}`. Examples: `PER.EDSGER.W.DIJKSTRA`, `PER.ACM`. Registered in `SPEC.ENTITY.ROUTING.TABLE`.

2. **Store files in .opencode/entities/persons/** — one file per person. File name matches kebab-case of last ID segment: `PER.EDSGER.W.DIJKSTRA` → `edsger-w-dijkstra.md`.

3. **Frontmatter stores identity and metadata only** — no inline events. Person events are defined separately in seed data (`_schemas/seeds/02-events.sql`) and linked via `person_events` junction table.

   ```yaml
   ---
   id: PER.EDSGER.W.DIJKSTRA
   title: "Edsger W. Dijkstra"
   subtype: physical
   source: dijkstra-vector
   tags: [mathematics, computer-science]
   ---
   ```

4. **Two subtypes** — `subtype` field must be one of:
   - `physical` — individual human (e.g., Dijkstra, Turing)
   - `jurisdictional` — organization, institution, collective (e.g., ACM, IEEE)
5. **Body text follows frontmatter** — after the closing `---`, markdown body provides biography, description, narrative, or further detail.

## Schema

### persons table

Eight columns: `id` (TEXT PRIMARY KEY, PER.* ID), `title` (TEXT REQUIRED, display name), `subtype` (TEXT REQUIRED, CHECK physically or jurisdictional), `source` (TEXT, origin), `tags` (TEXT, comma-separated), `body` (TEXT REQUIRED, markdown after frontmatter), `created` (TEXT REQUIRED, ISO timestamp), `modified` (TEXT REQUIRED, ISO timestamp).

## Gotchas

- Missing subtype field: Add `subtype: physical` or `subtype: jurisdictional` (Frontmatter has no `subtype` key)
- Invalid subtype value: Correct to one of the allowed values (subtype is neither 'physical' nor 'jurisdictional')
- Person entity used as an executable: Persons are passive data entities (like terms/patterns), distinct from executable types (tools/skills/commands) (PER.* entity registered in REF.META.ENTITY.FRAMEWORK)

## Applicability

All person entities in `.opencode/entities/persons/`. The protocol applies to root and subproject-level persons directories.

## Enforcement

`read-validate` verifies person frontmatter fields (subtype, source). `read-selection` lists persons by subtype, source, or tag. Events governed by REF.PERSON.EVENT.TIMELINE.

## See also

- `REF.PERSON.EVENT.TIMELINE` — event definition and junction schema
- `SPEC.ENTITY.ROUTING.TABLE` — PER.* prefix registered in entity routing
- `REF.SCHEMA.DATABASE.OWNERSHIP` — additive-only migration pattern
- `PER.EDSGER.W.DIJKSTRA` — first physical person entity
- `PER.ACM` — first jurisdictional person entity
