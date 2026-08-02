**Metadata Stratum** — metadata has two strata: superior and hidden. Superior comes from YAML that people write; hidden comes from DDL and system registries. Superior is entity-specific — people write it; it never shapes structure. Hidden is type-wide — the machine derives it; it never appears in YAML. The boundary is architectural — a cross of the boundary duplicates invariants.

## Rules

- Superior metadata never duplicates schema-level invariants (column names, types, constraints — those live in DDL).
- Hidden metadata never migrates to YAML — two representations of the same invariant violate the single-source principle.
- YAML position (frontmatter/backmatter) is a presentation convention that entity type determines, not a metadata stratum concern.
- When schema changes, all entities of that type implicitly inherit the change — no YAML edits needed.
- Scripts that verify derive hidden metadata from canonical sources; if superior YAML contradicts hidden schema, schema prevails.

## Applicability

All entity types with both YAML and DDL.

---
id: SPEC.METADATA.STRATUM.BOUNDARY
title: Metadata Stratum — Superior vs Hidden
source: assembler
summary: "Metadata has two strata: superior (YAML that people write) and hidden (from DDL and system registries). Superior is entity-specific; hidden is type-wide. The boundary is architectural."
specifies: Superior vs hidden metadata strata boundary
tags: [metadata, schema, derivation, stratum, specification]
status: active
---
