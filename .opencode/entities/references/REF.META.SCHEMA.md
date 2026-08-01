---
id: REF.META.SCHEMA
title: "Entity Naming Schema — Segment Rules"
source: PROT.META.IDENTITY
related: [PROT.META.NAMING.SCHEMA, PROT.META.DOMAIN, PROT.META.RENAME.REGISTRY]
summary: "Naming rules for all entity types — segment constraints, prefix assignments, and application sequence."
ref: "Every entity ID follows PREFIX.DOMAIN.SUBJECT.ASPECT with all segments as singular nouns."
tags: [meta, naming, convention, examples]
---

Naming rules for all entity types. Segment constraints, prefix assignments, and validation sequence. Rename mappings in PAT.META.RENAME.REGISTRY.

## Rules

1. First segment (PREFIX) must be a valid entity type — `COG`, `CON`, `DEF`, `MAX`, `NEX`, `PAT`, `PER`, `PROT`, `REF`, `RUL`, `SKL`, `TERM`
2. Second segment (DOMAIN) must be in the canonical domain set
3. SUBJECT and ASPECT must be singular nouns
4. Verb compounds, abbreviations, slang, and adjectives excluded
5. ASPECT must be specific to the subject — generic terms like `STRATEGY`, `MANAGEMENT`, `INITIALIZATION` are excluded
6. Advice and mantra entities use `MAX.` prefix; `PAT.` excluded for advice
7. Illustration entities use `ILL.` prefix — walkthroughs of patterns or protocols

## Application sequence

1. Check PREFIX is valid per entity type set
2. Check DOMAIN is valid per canonical set (only for IDs with 3+ segments)
3. Check SUBJECT is a singular noun (or omitted for two-segment exception)
4. Check ASPECT is a singular noun
5. If any check fails: consult `PROT.META.RENAME.REGISTRY` for the canonical renamed ID

## See also

- `ILL.META.NAMING.SCHEMA` — naming validation walkthrough — segment-by-segment check
- `PROT.META.NAMING.SCHEMA` — the naming protocol
- `PROT.META.DOMAIN` — canonical domain set
- `PROT.META.RENAME.REGISTRY` — historical record of all entity renames
