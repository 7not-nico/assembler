---
id: PAT.REFACTOR.EARLY.OFTEN
title: Refactor Early, Refactor Often — Fix Structure Before It Hardens
source: INSP.PRAGMATIC
summary: Refactor continuously. Don't let structural debt accumulate — fix it while the code is still fresh.
principle: Refactor code as soon as you identify structural decay; the cost of refactoring grows exponentially with time.
enforcement: Convention
tags: [refactoring, quality, maintenance, discipline, iteration, pragmatic]
patterns: [PAT.BROKEN.WINDOW, PAT.DRY, PAT.ORTHOGONALITY, PAT.CATALYST.FOR.CHANGE]
terms: []
status: active
priority: 3
---

**Refactor Early, Refactor Often** — fix structure before it hardens; refactoring cost grows exponentially with time.

## Rules

- Refactor at the first sign of duplication, coupling, or awkward abstraction
- Never defer a refactor past the current session or PR
- If a refactor takes longer than the feature, split it into smaller refactors
- A refactor that improves clarity without changing behavior never needs approval — just do it
- Schedule dedicated refactoring time if regular work doesn't create the opportunity

## Applicability

Any codebase where structural debt accumulates between features — especially AI-generated code that repeats patterns across files.

## See also

- PAT.BROKEN.WINDOW
- PAT.DRY
- PAT.ORTHOGONALITY
- PAT.CATALYST.FOR.CHANGE
- RUL.PRAGMATIC
