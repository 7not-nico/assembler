---
id: PROT.METADATA.BOUNDARY
title: "Metadata Stratum — Superior vs Hidden"
source: assembler
summary: "Entity metadata has two strata: superior (authored YAML) and hidden (derived schema). Superior YAML is entity-specific, human-written, never structural. Hidden schema is type-wide, machine-derived, never in YAML."
protocol: "Metadata has two strata: superior (authored YAML in any position) and hidden (derived from DDL and system registries). Superior is entity-specific, human-written, never structural. Hidden is type-wide, machine-derived, never in YAML. The boundary is architectural — crossing it duplicates invariants."
enforcement: Formality
tags: [metadata, schema, derivation, identity, yaml, protocol]
status: active
priority: 2
---

The metadata stratum protocol defines the boundary between authored and derived metadata.

## Protocol

### Stratum

**Superior metadata** is authored YAML — frontmatter, backmatter, or standalone `.yaml`. Entity-specific, never structural. Fields: id, title, source, tags, related, reference.

**Hidden metadata** is derived from DDL (`_schemas/*.sql`) and system registries (`PrefixToType`, `RingGroups`, `ENTITY_FIELD_SPECS`). Never in YAML. Shared across all entities of a type. Type-wide, not entity-specific.

### Rules

- Superior metadata never duplicates schema-level invariants (column names, types, constraints — those live in DDL)
- Hidden metadata never migrates to YAML — two representations of the same invariant violate MAX.CODE.DRY.PRINCIPLE
- YAML position (frontmatter/backmatter) is a presentation convention determined by entity type, not a metadata stratum concern
- When schema changes, all entities of that type implicitly inherit the change — no YAML edits needed
- Verification scripts derive hidden metadata from canonical sources; if superior YAML contradicts hidden schema, schema prevails

## Gotchas

- Schema field in YAML: Remove — those belong in DDL alone (YAML contains column names or type info)
- YAML position mismatch: Change to match entity type convention (Entity uses frontmatter when type convention is backmatter)
- Missing required field: Add required field to YAML (Entity missing id, title, or source)
- Stale schema: Run write-sync; schema migration may be needed (Entity file references field not in DDL)

## Enforcement

Survey scripts (`identities-audit/a01-verify-completeness`) check that superior metadata doesn't contradict schema. `write-sync` validates required fields per `ENTITY_FIELD_SPECS`.

## Applicability

All entity types with both YAML and DDL. The boundary applies whenever authored metadata and schema-level structure coexist.

## See also

- `IDENTITY.YAML` — superior metadata stratum identity
- `IDENTITY.SCHEMA` — hidden metadata stratum identity
- `MAX.CODE.DRY.PRINCIPLE` — single source of truth (hidden metadata cannot be duplicated in YAML)
- `PROT.META.IDENTITY` — entity identity protocol pattern
