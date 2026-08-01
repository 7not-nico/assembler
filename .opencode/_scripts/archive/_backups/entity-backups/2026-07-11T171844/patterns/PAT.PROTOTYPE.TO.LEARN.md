---
id: PAT.PROTOTYPE.TO.LEARN
title: Prototype to Learn — Write Throwaway Code to Explore, Discard After Learning
source: INSP.PRAGMATIC
summary: Prototypes are written to be discarded. The value is in the learning, the code is disposable.
principle: Write prototypes to explore unknowns and throw them away; rewrite any prototype that survives into production code.
enforcement: Convention
tags: [prototyping, exploration, learning, risk, iteration, pragmatic]
patterns: [PAT.TRACER.BULLETS, PAT.PROGRAMMING.DELIBERATELY, PAT.CATALYST.FOR.CHANGE]
terms: []
status: active
priority: 4
---

**Prototype to Learn** — write throwaway code to explore unknowns; the value is in the learning, the code is disposable.

## Rules

- A prototype is written with the assumption it will be discarded
- Rewrite prototypes as production code before evolving them
- Prototype to test a hypothesis only
- If the prototype survived, rewrite it properly using tracer bullets
- Distinguish prototype (throwaway) from tracer bullet (grows) — know which you're building

## Applicability

Any exploration phase where unknowns exist — technology choice, architecture validation, API design.

## See also

- PAT.TRACER.BULLETS
- PAT.PROGRAMMING.DELIBERATELY
- PAT.CATALYST.FOR.CHANGE
- RUL.PRAGMATIC
