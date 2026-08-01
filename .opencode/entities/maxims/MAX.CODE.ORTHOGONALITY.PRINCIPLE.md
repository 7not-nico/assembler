---
id: MAX.CODE.ORTHOGONALITY.PRINCIPLE
title: Orthogonality — One Thing Per Tool
source: INSP.PRAGMATIC
summary: Changes to one component should not affect unrelated components.
principle: Changes to one component should not affect unrelated components.
enforcement: Convention
tags: [architecture, tooling, separation, design, maintainability]
status: active
priority: 2
---

**Orthogonality** — changes to one component should not affect unrelated components.

## Axes

- **Concerns** — each concern independent, change to one leaves others unchanged
- **Operations** — one operation per unit, one direction per unit
- **Shared logic** — common logic extracted, cross-unit routing goes through shared layer

## Rules

- Each unit does exactly one thing
- Units import from shared layer only — cross-unit logic routes through shared layer
- Adding a unit is adding one file — no cascade
- A change to one unit never requires a change to another unit with the same interface
- Read and write: separate units — one direction per unit

## Applicability

Any project with multiple components or scripts — the orthogonality check is the number of files touched per feature.
