---
id: PAT.TRACER.BULLETS
title: Tracer Bullets — Build Thin End-to-End First, Grow Later
source: INSP.PRAGMATIC
summary: Build thinnest end-to-end version first; it grows into the final system — not discarded.
principle: Build the thinnest end-to-end version before adding detail; the tracer bullet grows into the final system, not a throwaway prototype.
enforcement: Convention
tags: [workflow, prototyping, architecture, iteration, validation, pragmatic]
status: active
priority: 3
---

**Tracer Bullets** — build the thinnest working line from input to output first, validate the path, then layer.

## Rules

- Establish a single end-to-end path before adding detail
- The tracer bullet is never discarded — it grows into the final system
- Add authentication, validation, error handling only after the path works
- No new feature starts without a tracer bullet path first

## Applicability

Any multi-step workflow where the end-to-end path is uncertain — tools, pipelines, feature development.

## See also

- PAT.DRY
- PAT.PROGRAMMING.DELIBERATELY
- RUL.PRAGMATIC
