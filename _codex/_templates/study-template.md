---
id: TEMPLATE.STUDY
title: Study Template — Architecture Document Form
layer: study/
purpose: "Per-concern architecture document: grounded, file:line anchored, one concern per file."
naming: domain-architecture.md
tags: [template, study, architecture]
status: active
---
# {Domain} — architecture document

**Layer:** study/
**Naming:** `{domain}-architecture.md` or `{topic}.md` — how the codebase and its extensions work.
**Concern:** {the one atomic concern this file covers}.
**Composes with:** `backup/` (pre-edit restore point referenced), `concept/{concept}.md`, `morphism/{morphism}.md`, `procedure/{action}-{domain}.md`.

## Grounding

```
{file}:{line}                  {what lives there}
include/mgba/internal/{domain}.h:{n}-{n}   {constants — dimensions, rates, priorities}
```

Every claim anchors to file:line. A study file with an unanchored claim marks the record incomplete.

## Architecture

{one paragraph: the system or subsystem under study — components, data flow, key design decisions}

## Diagrams / Flow

{code-block diagram or flow showing the composition — components and their connections}

## Verified math (qalc)

Every quantitative claim passes `qalc -t` before recording (precept `verify-qalc.md`). The table carries the expression, the result, and the verdict:

| Claim | qalc | Verdict |
|-------|------|---------|
| {n} × {m} | {result} | = constant ✓ |

## Verification

{how the architecture proves correct — measurements, qalc-verified math, runtime checks}

## Instance

{date, project, outcome}

## Change inventory — located in AGENTS.md

The authoritative edited-lines table lives in the dive's AGENTS.md (precept `atomic-documents.md`), keyed by the diff anchor `backup/{repo}-src/`. Study docs stay inventory-free; this file references the anchor without restating it.
