**Metadata Stratum** — metadata has two strata: superior (authored YAML) and hidden (derived from DDL and system registries). Superior is entity-specific, human-written, never structural. Hidden is type-wide, machine-derived, never in YAML. The boundary is architectural — crossing it duplicates invariants.

## Rules

- Superior metadata never duplicates schema-level invariants (column names, types, constraints — those live in DDL).
- Hidden metadata never migrates to YAML — two representations of the same invariant violate the single-source principle.
- YAML position (frontmatter/backmatter) is a presentation convention determined by entity type, not a metadata stratum concern.
- When schema changes, all entities of that type implicitly inherit the change — no YAML edits needed.
- Verification scripts derive hidden metadata from canonical sources; if superior YAML contradicts hidden schema, schema prevails.

## Applicability

All entity types with both YAML and DDL.

---
id: SPEC.METADATA.STRATUM.BOUNDARY
title: Metadata Stratum — Superior vs Hidden
source: assembler
summary: "Metadata has two strata: superior (authored YAML) and hidden (derived from DDL and system registries). Superior is entity-specific; hidden is type-wide. The boundary is architectural."
specifies: Superior vs hidden metadata strata boundary
tags: [metadata, schema, derivation, stratum, specification]
status: active
---
