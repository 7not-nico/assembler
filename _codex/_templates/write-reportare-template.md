---
id: TEMPLATE.WRITE.REPORTARE
title: Write-Reportare Template — Metrics-Led Report Form
layer: precept/
purpose: "Metrics-led report template: quantitative values before narrative."
naming: YYYYMMDD-HHMMSS-topic.md
tags: [template, report, metrics]
status: active
---
# write-informe.md

**Layer:** precept/
**Naming:** `action-domain.md` — declarative, atomic, one rule per file.
**Composes with:** `_templates/informes/informe-template.md` (report shape).

## Rule

Write an informe into `_knowledge/_templates/informes/` after EVERY session on a bootstrapped knowledge project. Always — no exceptions, no session too small.

## Scope

Task-level, session-level. Triggers on every session end across all `_knowledge/` projects.

## Content

```
1. What was done — deliverables per chain layer, DB state
2. Decisions — choices made + rationale
3. Errors found — bug + fix, every one
4. Findings — what the session revealed, impact
5. Open edges — unresolved items
6. Todo state — completed + pending
```

## Why

The informes directory is the improvement loop. Errors and findings written there feed template fixes — each session makes the next session's templates better. Skipping the informe loses that improvement.

## Practice

```
- filename: {YYYYMMDD}-{HHMMSS}.md
- copy _templates/informes/informe-template.md as the shape
- write errors + findings explicitly — they drive template evolution
```
