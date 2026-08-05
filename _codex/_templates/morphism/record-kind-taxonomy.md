---
id: PATTERN.RECORD.KIND.TAXONOMY
title: Record Kind Taxonomy — Six Kinds, One Naming Rule
layer: morphism/
purpose: "A bitacora classifies records into kinds — todo, report, audit, plan, survey, reference — one naming rule per kind, seven folders in the record root."
naming: record-kind-taxonomy.md
tags: [pattern, morphism, record, kind, taxonomy, bitacora]
status: active
---
# RECORD-KIND-TAXONOMY.md

**Layer:** morphism/
**Naming:** `record-kind-taxonomy.md` — code morphism, reusable structure.
**Composes with:** `morphism/record-lifecycle.md`; derived from `study/` + `fixture/` proof.

## Morphism

A bitacora classifies records into kinds — todo, report, audit, plan, survey, reference — each with its own `task-{kind}/` folder and one naming rule; the todo names by date-slug, the others by timestamp-slug.

## Structure

```text
task-todo/     {YYYY-MM-DD}--{slug}.md          (date-slug — opens first)
task-report/   {YYYYMMDD}-{HHMMSS}-{slug}.md    (timestamp-slug — closes last)
task-audit/    {YYYYMMDD}-{HHMMSS}-{slug}.md
task-plan/     {YYYYMMDD}-{HHMMSS}-{slug}.md
task-survey/   {YYYYMMDD}-{HHMMSS}-{slug}.md
task-reference/{YYYYMMDD}-{HHMMSS}-{slug}.md
task-stdout/   {YYYYMMDD}-{HHMMSS}-{name}.log   (command logs, not records)
```

Invariant: the kind selects the folder and the name; the todo is the only date-named record (one per day); every other kind carries a timestamp; a record's kind is readable from its path alone.

## Verification

Create one of each kind — the file lands in the matching `task-{kind}/` with the kind's naming rule; a same-kind same-slug re-create fails (no-clobber); `ls task-*/` groups records by kind for the find tool.

## Instance

Root `.opencode/_bitacora/` — all 7 folders, `bitacora-create.sh` `{kind}` dispatch (2026-08-05); `_codex/_bitacora/` runs the reduced set (todo/report/stdout) — an open edge to adopt the full taxonomy.
