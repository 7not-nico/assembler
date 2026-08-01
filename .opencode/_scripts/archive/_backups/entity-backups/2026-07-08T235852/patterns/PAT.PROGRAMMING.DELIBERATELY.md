---
id: PAT.PROGRAMMING.DELIBERATELY
title: Programming Deliberately — Know What Should Happen Before It Does
source: INSP.PRAGMATIC
summary: Know what should happen before it does. Explain why it happened. No coincidences.
principle: Know what should happen before writing code; explain why it works after; never accept code that works for unknown reasons.
enforcement: Review
tags: [quality, discipline, review, debugging, convention, pragmatic]
status: active
priority: 3
---

**Programming Deliberately** — know what should happen before it does; explain why it happened; no coincidences.

## Rules

- Know what the code should do before writing it
- After code runs, explain why it worked or failed — in your own words
- Never accept code that passes tests but you cannot explain
- If you cannot explain why it failed, don't change it at random — debug deliberately
- Block any PR where the author cannot explain the implementation

## Applicability

Any code review or AI-generated code workflow where "it works" is accepted without understanding.

## See also

- PAT.DRY
- PAT.TRACER.BULLETS
- RUL.PRAGMATIC
