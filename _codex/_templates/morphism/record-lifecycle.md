---
id: PATTERN.RECORD.LIFECYCLE
title: Record Lifecycle — Todo, Log, Report, One Topic
layer: morphism/
purpose: "A task's record opens as todo, grows with command logs, closes as report — timestamped names, no-clobber per topic, one lifecycle."
naming: record-lifecycle.md
tags: [pattern, morphism, record, lifecycle, bitacora, no-clobber]
status: active
---
# RECORD-LIFECYCLE.md

**Layer:** morphism/
**Naming:** `record-lifecycle.md` — code morphism, reusable structure.
**Composes with:** `morphism/atomic-tool-contract.md`; derived from `study/` + `fixture/` proof.

## Morphism

A task's record follows one lifecycle: open as todo before work, grow with every command's framed log, close as report at completion — timestamped `{YYYYMMDD}-{HHMMSS}-{topic}.md` names, no-clobber per topic.

## Structure

```text
todo   → _codex/_bitacora/task-todo/{ts}-{topic}.md    (opened first)
run    → _codex/_bitacora/task-stdout/{ts}-{name}.log  (every command)
report → _codex/_bitacora/task-report/{ts}-{topic}.md  (closed last)
```

No-clobber: a re-open of the same topic fails with the existing record's name — the record never forks. All three writes resolve the `_codex` root the same way (walk-up), so canonical and dive copies record identically.

## Verification

Open a todo, run commands through the frame, close the report; re-open the todo — the no-clobber guard names the existing file and exits 1; the lifecycle spans all three `_bitacora/` subdirs with the shared topic.

## Instance

`shell/bitacora-todo.sh` + `shell/bitacora-run.sh` + `shell/bitacora-report.sh` + `_shared/cmd/bitacora` (2026-08-05) — the melonDS dive's todo opened, builds logged, report pending; all through one topic.
