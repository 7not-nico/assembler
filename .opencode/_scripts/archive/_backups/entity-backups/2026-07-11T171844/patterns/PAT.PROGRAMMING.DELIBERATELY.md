---
id: PAT.PROGRAMMING.DELIBERATELY
title: Programming Deliberately — Know What Should Happen Before It Does
source: INSP.PRAGMATIC
summary: Know what should happen before it does. Explain why it happened. Coincidences are unacceptable.
principle: Know what should happen before writing code; explain why it works after; accept only code you can explain.
enforcement: Review
tags: [quality, discipline, review, debugging, convention, pragmatic]
patterns: [PAT.DRY, PAT.TRACER.BULLETS]
terms: []
status: active
priority: 3
---

**Programming Deliberately** — know what should happen before it does; explain why it happened; coincidences are unacceptable.

## Rules

- Know what the code should do before writing it
- After code runs, explain why it worked or failed — in your own words
- Accept only code you can explain — tests alone are insufficient
- Debug deliberately — explain the failure before applying any change
- Block any PR where the author cannot explain the implementation

## Applicability

Any code review or AI-generated code workflow where "it works" is accepted without understanding.

## See also

- PAT.DRY
- PAT.TRACER.BULLETS
- RUL.PRAGMATIC
