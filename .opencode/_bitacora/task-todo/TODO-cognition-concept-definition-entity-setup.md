## TODO-cognition-concept-definition-entity-setup

Create three new entity types — COGNITION, CONCEPT, DEFINITION — with vector-based metadata. Update TERM schema with type field. Register in route table and patlib DB.

### Completed

- [x] MAX.KNOWLEDGE.CLASSIFICATION — declared groups (Encyclopedic, Architectonic, Chronicle), ordinal layers, vector rules, acyclic constraint
- [x] audit-maxim skill — creates and validates maxim format compliance (spec-audit 100/100)
- [x] PROT.COGNITION.SCHEMA — identity protocol for COG.* entities (spec-audit 100/100)
- [x] X — identity protocol for CON.* entities (spec-audit 100/100)
- [x] X — identity protocol for DEF.* entities (spec-audit 100/100)
- [x] PROT.TERM.SCHEMA — updated with type field (internal/external), vector source rules, horizontal related (spec-audit 100/100)
- [x] REF.META.ENTITY.ROUTING — added COG, CON, DEF prefixes with directory and table mappings
- [x] patlib.sql — added cognitions, concepts, definitions tables; ALTER terms ADD COLUMN type
- [x] stud.md stubs — one per new directory (cognitions/, concepts/, definitions/) with correct backmatter metadata
- [x] TODO — this file

### Checklist

- [ ] **Term migration** — move ~40 universal terms from terms/ to cognitions/ and concepts/ and definitions/; update source and type fields per MAX.KNOWLEDGE.CLASSIFICATION vector rules.

### Verification

- read-validate passes all new entity files.
- patlib_get resolves each new prefix.
- spec-audit passes all new protocols.
- All migrated terms have correct source, type, and related fields per layer rules.

### Notes

- TERM `type: internal` + `source: assembler` = project-invented label. TERM `type: external` + `source: CON.*/DEF.*` = labels a universal thing.
- CONCEPT/DEFINITION `source` = COG.* ID (points up to cognition). No separate `cognition` field needed.
- COGNITION `source: general` (top layer, nothing above).
- Vectors: `source` points earlier; `related` horizontal same layer and group. No cycles.
- All entities follow backmatter YAML format (like existing terms).
