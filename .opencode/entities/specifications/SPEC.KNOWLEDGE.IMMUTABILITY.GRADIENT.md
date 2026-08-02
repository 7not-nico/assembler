**Knowledge Immutability Gradient** — the inner the ring, the more immutable its entities. Immutability determines change policy per topological group.

## Gradient

- R0 across all groups is immutable. An entity changes only when a new entity supersedes it — the old entity marks `status: deprecated` and points `precedes:` at the replacement.
- R1 is stable. An entity changes only by addition — new fields, new sections, and new entities may appear; existing content never changes.
- R2 is stable. Same policy as R1 — additive only, nothing removes.
- R3 (where it exists) is mutable. Entities change freely without deprecation.

## Derivation

Immutability follows ring direction. Inner rings (R0) are foundational — maxims, specifications, persons, etymologies — they ground meaning for all outer rings. Outer rings (R3, R6) are surface — illustrations, references, terms, notes — they describe instances and may change as understanding evolves.

When an inner-ring entity must change:

1. Create a new entity at the same ring that supersedes the old
2. Mark the old entity `status: deprecated` and move it into archives/ folder in entities/
3. Update outer-ring references to point to the new entity
4. Remove outer-ring references to the deprecated entity over time

## Applicability

All entities across all groups. The gradient applies by ring number within each group.

---
id: SPEC.KNOWLEDGE.IMMUTABILITY.GRADIENT
title: Knowledge Immutability Gradient — Inner Ring Stability
source: assembler
summary: "Immutability follows ring direction: R0 immutable (supersession only), R1–R2 stable (addition only), R3 mutable (free). Inner rings ground meaning for all outer rings."
specifies: Immutability gradient by ring number (R0→R3)
tags: [knowledge, immutability, gradient, ring, stability, specification]
status: active
---
