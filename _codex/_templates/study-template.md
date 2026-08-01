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
**Composes with:** `backup/` (pre-edit restore point referenced), `pattern/{morphism}.md`, `procedure/{action}-{domain}.md`.

## Architecture

{one paragraph: the system or subsystem under study — components, data flow, key design decisions}

## Diagrams / Flow

{code-block diagram or flow showing the composition — components and their connections}

## Change inventory — files and code lines

Authoritative diff anchor: {backup restore point}. Every edited line listed:

| File | Lines | Change |
|------|-------|--------|
| `{file}` | {lines} | {what changed and why} |

The change inventory is the authoritative list — the fixture and patterns derive from it.

## Verification

{how the architecture proves correct — measurements, qalc-verified math, runtime checks}

## Instance

{date, project, outcome}
