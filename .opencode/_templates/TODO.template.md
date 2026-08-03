---
id: TEMPLATE.TODO
title: Bitacora Todo Template — Task Plan Record
layer: bitacora
purpose: "Bootstraps any bitacora todo: task plan with goals, checkbox tasks, decisions, report reference."
naming: "task-todo/{YYYY-MM-DD}--{slug}.md in .opencode/_bitacora/"
tags: [template, bitacora, todo, task, plan]
status: active
---
<!-- Bitacora todo template — one file per task, created BEFORE work per bitacora-workflow.
     Destination: .opencode/_bitacora/task-todo/{YYYY-MM-DD}--{slug}.md.
     Lifecycle: created in progress → checked as tasks complete → closed at report.
     Ground source of truth: this template lives in _templates/.
     Governing rules: RUL.TODO.TRACK, RUL.REPORT.WRITE, RUL.WORKFLOW.BITACORA.STDOUT.
     Register: BULLET.template.md — junction bullets, one fact per line, subject opens.
     Every command pipes through `bitacora-log.sh {name} -- {command}` → task-stdout/. -->

# {topic}

Status: in progress ({YYYY-MM-DD})
Created: {YYYY-MM-DD}

## Goal

{one-sentence goal: what the task completes and under which conventions}

## Tasks

- [ ] {task one — atomic unit, one responsibility}
- [ ] {task two — atomic unit, one responsibility}
- [ ] {task three — atomic unit, one responsibility}

## Decisions

- {decision one — junction, declarative}
- {decision two — junction, declarative}

## Reports

- {task-report} to be written at completion
- {log references} to be cited at completion
