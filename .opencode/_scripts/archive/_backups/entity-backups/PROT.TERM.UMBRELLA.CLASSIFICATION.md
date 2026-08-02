---
id: PROT.TERM.UMBRELLA.CLASSIFICATION
title: Umbrella Terms — hierarchical grouping via related links
source: AMANDA cross-project
summary: A broad term (umbrella) encompasses narrower sub-types (children), linked bidirectionally via the related field.
protocol: Every term hierarchy uses a single umbrella term whose related field lists all children, and every child links back to the umbrella via its related field.
enforcement: Convention
related: []
tags: [convention, taxonomy, naming, cross-reference, architecture, hierarchy]
status: active
priority: 3
---

A broad term (umbrella) encompasses narrower sub-types (children), linked bidirectionally via `related`. Children contrast with siblings in their body text; the umbrella enumerates all children.

## Rules

1. **Umbrella exists first** — create the umbrella term before any child term. Children reference the umbrella by ID.
2. **Bidirectional linking** — umbrella's `related` lists every child. Each child's `related` includes the umbrella.
3. **Shared ID prefix** — umbrella and children share an initial ID segment sequence e.g. `TERM.PHYSICS.DEFINED.NEURAL.NETWORKS` umbrella → `TERM.PHYSICAL.NEURAL.NETWORKS` and `TERM.PHYSICS.INFORMED.NEURAL.NETWORKS` children.
4. **Body contrast** — each child body distinguishes itself from siblings. Umbrella body enumerates all children in one sentence.
5. **Max one level** — umbrella terms are flat. No nested hierarchies.

## Applicability

Use when three or more term variants share a conceptual parent and need consistent cross-referencing.

Not applicable for pairs (use direct `related` link) or unrelated clusters.

## See also

- `ILL.TERM.UMBRELLA.GROUP` — umbrella term walkthrough — PNN hierarchy setup
- TERM.PHYSICS.DEFINED.NEURAL.NETWORKS — example umbrella (PNN, PINN, HPN)
- SPEC.ENTITY.ROUTING.TABLE — related naming convention for entity IDs
