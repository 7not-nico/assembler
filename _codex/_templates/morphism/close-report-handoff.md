---
id: PATTERN.CLOSE.REPORT.HANDOFF
title: Close-Report Handoff — Complete the Todo, Scaffold the Report
layer: pattern/
purpose: "Closing a todo completes every pending item, stamps the status, and scaffolds the report in one atomic handoff — done state flows into the close-out."
naming: close-report-handoff.md
tags: [pattern, morphism, close, report, handoff, todo, bitacora]
status: active
---
# CLOSE-REPORT-HANDOFF.md

**Layer:** pattern/
**Naming:** `close-report-handoff.md` — code morphism, reusable structure.
**Composes with:** `pattern/record-lifecycle.md`; derived from `study/` + `fixture/` proof.

## Morphism

Closing a todo completes every pending item (`- [ ]` → `- [x]`), stamps the status line, and scaffolds the report in one atomic handoff — the done state flows directly into the close-out record.

## Structure

```text
close {todo} {topic} →
    sed -i 's/^- \[ \]/- [x]/' $FILE          # complete all pending
    Status: completed ({date})                 # stamp the todo
    report = create report {topic}             # scaffold the close-out
    TODO={path}  REPORT={path}  NEXT=fill it
```

Invariant: closing is atomic — no item left pending, status always stamped, the report always scaffolded; the handoff prints both paths and the next action; a report is never opened without its todo being completed.

## Verification

Close a todo with pending items — every `- [ ]` becomes `- [x]`, the Status line reads `completed (date)`, the report file exists; close a todo without a Status line — one is appended; the handoff prints TODO + REPORT + NEXT.

## Instance

Root `.opencode/_bitacora/bitacora-close.sh` (2026-08-05) — the sed-complete + status-stamp + create-report handoff; the codex flow's `bitacora-report.sh` opens a report directly without the close handoff — an open edge.
