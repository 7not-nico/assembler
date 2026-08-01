**Knowledge Immutability Gradient** — the inner the ring, the more immutable its entities. Immutability determines change policy per topological group.

## Gradient

- R0 across all groups is immutable. Entities change by deprecation only — a new entity supersedes the old, the old is marked `status: deprecated` with `precedes:` pointing to the replacement.
- R1 is stable. Entities change by addition only — new fields, new sections, new entities may be added; existing content is never removed or renamed.
- R2 is stable. Same policy as R1 — additive only, no removal.
- R3 (where it exists) is mutable. Entities may be created, edited, or removed without deprecation.

## Derivation

Immutability follows ring direction. Inner rings (R0) are foundational — maxims, specifications, persons, etymologies — they ground meaning for all outer rings. Outer rings (R3, R6) are surface — illustrations, references, terms, notes — they describe instances and may be rewritten as understanding evolves.

When an inner-ring entity must change:

1. Create a new entity at the same ring that supersedes the old
2. Mark the old entity `status: deprecated` and move into archives/ folde in entities/
3. Update outer-ring references to point to the new entity
4. Remove outer-ring references to the deprecated entity over time

## Applicability

All entities across all groups. The gradient applies by ring number within each group.

---
id: SPEC.KNOWLEDGE.IMMUTABILITY.GRADIENT
title: Knowledge Immutability Gradient — Inner Ring Stability
source: assembler
summary: "Immutability follows ring direction: R0 immutable (deprecation only), R1–R2 stable (additive only), R3 mutable (free). Inner rings ground meaning for all outer rings."
specifies: Immutability gradient by ring number (R0→R3)
tags: [knowledge, immutability, gradient, ring, stability, specification]
status: active
---
