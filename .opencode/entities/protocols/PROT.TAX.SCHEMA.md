---
id: PROT.TAX.SCHEMA
title: Taxonomy Identity — Biological Classification Entity
source: NEX.META.PROPOSAL
summary: "Defines the taxonomy/ directory and TAX.* entity type — schema, body convention, enforcement, and relationship to the Encyclopedic ring hierarchy."
protocol: "A taxonomy entity defines a biological classification rank at Ring 2 of the Encyclopedic group. source points to the parent taxon (same ring) or to a COG.* cognition (inner ring) when the chain ends. related connects to other TAX.* entities horizontally."
enforcement: Sealed
tags: [taxonomy, classification, biology, entity-type, hierarchy, rank]
status: active
priority: 2
---

The taxonomy domain holds biological classification entities (domain, kingdom, phylum, class, order, family, genus) that organize the tree of life. Taxonomy entities answer *what group*. Cognitions answer *what domain*. Concepts answer *what idea*. Definitions answer *what thing*. Terms answer *what label*.

## Protocol

### Schema

Every taxonomy file requires seven backmatter fields: `id` (required, `TAX.{NAME}` uppercase dot-separated), `title` (required, human-readable name), `source` (required, parent TAX.* ID (same ring) or COG.* ID (inner ring)), `rank` (required, classification rank: domain, kingdom, phylum, class, order, family, genus), `related` (optional, entity ID array — other TAX.* IDs only), `tags` (required, comma-separated, no spaces), `reference` (required, array of `{title, url}`; minimum 3).

### Body convention

First line: `**{Title}** — {1-3 sentence description}`. Optional subsections follow.

### Content rules

- `source` points to the closest preceding entity — same ring (parent taxon) when the chain continues, inner ring (COG.* cognition) when the chain ends
- `rank` documents the taxonomic rank in the biological classification hierarchy
- `precedes` lists child taxa or BIO.* entities within this rank
- Tags: comma-separated — spaces excluded
- References: minimum 3 authoritative sources with URL+title
- Related: limited to other TAX.* IDs — horizontal layer only
- Sync: name-to-name into `taxonomy` table — DB cache, file is source of truth

### Source chain examples

```
TAX.MAMMALIA           source: COG.BIOLOGY        (Ring 2 → Ring 1, chain ends)
TAX.CARNIVORA          source: TAX.MAMMALIA       (same Ring 2, chain continues)
TAX.URSIDAE            source: TAX.CARNIVORA      (same Ring 2, chain continues)
BIO.GRIZZLY.BEAR       source: TAX.URSIDAE        (Ring 3 → Ring 2, chain continues)
```

## Gotchas

- source absent or invalid: Taxonomy requires source pointing to a parent taxon or cognition (source field missing or contains invalid ID)
- source points to non-COG/TAX entity: source must be TAX.* (same ring) or COG.* (inner ring) (source field contains CON.* or DEF.* or TERM.* ID)
- related links to non-TAX entities: related is horizontal only — link only to other TAX.* IDs (related array contains non-TAX IDs)
- rank missing or invalid: Add valid rank: domain, kingdom, phylum, class, order, family, genus (rank field absent or contains non-standard value)
- Less than 3 references: Add authoritative sources — textbooks, papers, taxonomic databases (`reference:` array length < 3)
- Tags contain spaces: Replace with hyphenated form: `mammal,vertebrate` (`tags: mammal, vertebrate` with space)
- ID field mismatches filename: Match filename prefix to id value (File named `TAX.FOO.md`; id field value: `TAX.BAR`)

## Enforcement

`read-validate` verifies every taxonomy file against this protocol: backmatter fields present and correctly formatted, minimum 3 references, tag format compliance, body starts with bold-title convention.

## Applicability

All taxonomy entities in `.opencode/taxonomy/`. The protocol applies to root-level entities only.

## See also

- `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` — groups, layers, vector rules; Taxonomy at Ring 2
- `PROT.COGNITION.SCHEMA` — cognition entity protocol
- `PROT.DEFINITION.SCHEMA` — definition entity protocol
- `PROT.TERM.SCHEMA` — term entity protocol
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention for all entity types
- `REF.META.REFERENCE.AUTHORITY` — reference source hierarchy by entity type
