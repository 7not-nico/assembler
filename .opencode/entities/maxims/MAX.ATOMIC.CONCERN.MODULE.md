---
id: MAX.ATOMIC.CONCERN.MODULE
title: "Atomic Concern — One Change Reason Per Module"
source: Parnas, D.L. (1972) — On the Criteria to Be Used in Decomposing Systems into Modules
summary: "Every module boundary isolates exactly one reason for change."
principle: "Every module has exactly one reason to change. A module that changes for two independent causes is non-atomic."
enforcement: Convention
tags: [architecture, module, decomposition, orthogonality, modularity, boundary]
status: active
priority: 1
---

**Atomic Concern** — one change reason per module.

## Change-Reasons

- **Design decisions** — list decisions likely to change, each module hides one per Parnas (1972)
- **Domain operations** — each module encapsulates one operation rather than a step in a process
- **Boundary test** — ask "what would force this module to change", multiple independent answers signal a split

## Rules

- Every module has exactly one reason to change — two independent causes = non-atomic
- Decompose by listing design decisions likely to change; assign each to exactly one module
- Module size is independent of atomicity — a pure function and a DB client are both atomic if each changes for one reason
- Atomic modules may import from same or inward layers

## Applicability

All module boundary decisions across all language layers.
