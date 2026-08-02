---
id: TEMPLATE.PRECEPT.ATOMIC.DOCUMENTS
title: Atomic-Documents Precept Template — One Concern Per File
layer: precept/
purpose: "Every document carries one atomic concern."
naming: atomic-documents.md
tags: [template, precept, atomic, structure]
status: active
---
# atomic-documents.md

**Layer:** precept/
**Naming:** `atomic-documents.md` — declarative action-domain, atomic, one rule per file.
**Composes with:** study (per-concern), concept (per-concept), fixture (per-harness).

## Rule

Every document carries one atomic concern.

## Scope

File-level; study, concept, fixture, and report files.

## Order / Practice

1. Study files split per concern: `{domain}-cpu.md`, `{domain}-memory.md`, `{domain}-ppu.md` — one concern per file.
2. Concept files split per concept; fixture files per harness; reports per task.
3. Each study file grounds with file:line anchors and a Grounding block.
4. The change inventory lives in AGENTS.md; study docs stay inventory-free.

## Example

```text
study/  {n} files, one concern each, all grounded
concept/ {n} files, one concept each
fixture/ {n} harnesses + {m} source suites
```

## Instance

{date, project, outcome — the first split of a bundled architecture doc into per-concern files}
