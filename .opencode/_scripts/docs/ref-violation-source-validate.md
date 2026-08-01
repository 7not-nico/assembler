# r2-source-validate — Violation Output

Checks: source direction follows SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY rules.

Columns: `ID | Type | Source | EntityRing | SourceRing | Violation`

Rules:
- Encyclopedic source → same or inner ring only.
- Encyclopedic never sources architectonic, chronicle, or other groups.
- No self-referencing source.
- Chronicle may source any group.
- Axiomatic sources point to inner ring or same-ring entities.
- Composition sources follow the morphism pipeline (protocol → pattern → nexus).
