---
id: PAT.TRACER.PRACTICE
title: Tracer Bullets — Build Thin End-to-End First, Grow Later
source: NEX.TOOL.CHOICE
summary: Build thinnest end-to-end version first; it grows into the final system, retained and evolved.
morphism: GENR — build the thinnest end-to-end version before adding detail; the tracer bullet grows into the final system, distinct from a throwaway prototype.
enforcement: Convention
tags: [workflow, prototyping, architecture, iteration, validation, pragmatic]
status: active
priority: 3
---

Build the thinnest working line from input to output first, validate the path, then layer.

## Rules

- Establish a single end-to-end path before adding detail
- The tracer bullet grows into the final system — it is retained and evolved
- Add authentication, validation, error handling only after the path works
- Every new feature starts with a tracer bullet path first

## Applicability

Any multi-step workflow where the end-to-end path is uncertain — tools, pipelines, feature development.

## See also

- `ILL.TRACER.BULLETS.PATH` — tracer bullet walkthrough — read-game tool build
- MAX.CODE.DRY.PRINCIPLE
- MAX.PROGRAMMING.DELIBERATELY.PRACTICE
- RUL.PRAGMATIC
