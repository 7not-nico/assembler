---
id: MAX.REFACTOR.EARLY.OFTEN
title: Refactor Early, Refactor Often — Fix Structure Before It Hardens
source: INSP.PRAGMATIC
summary: Refactor continuously. Fix structural debt while the code is still fresh — cost grows exponentially with time.
principle: Refactor code as soon as you identify structural decay; the cost of refactoring grows exponentially with time.
enforcement: Convention
tags: [refactoring, quality, maintenance, discipline, iteration, pragmatic]
status: active
priority: 3
---

**Refactor Early, Refactor Often** — fix structure before it hardens; refactoring cost grows exponentially with time.

## Debt

- **Detection** — first sign of duplication, coupling, or awkward abstraction triggers refactor
- **Action** — refactor within the current session or PR, deferral compounds cost
- **Scale** — split large refactors into smaller ones, schedule dedicated time when regular work misses the opportunity

## Rules

- Refactor at the first sign of duplication, coupling, or awkward abstraction
- Refactor within the current session or PR — deferral compounds cost
- If a refactor takes longer than the feature, split it into smaller refactors
- A refactor that improves clarity without changing behavior: auto-approved — just do it
- Schedule dedicated refactoring time if regular work doesn't create the opportunity

## Applicability

Any codebase where structural debt accumulates between features — especially AI-generated code that repeats patterns across files.
