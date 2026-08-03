---
id: TEMPLATE.REPORT
title: Bitacora Report Template — Completion Record
layer: bitacora
purpose: "Bootstraps any bitacora task report: factual record of work, decisions, verification, edges, todo state."
naming: "task-report/{YYYYMMDD}-{HHMMSS}-{slug}.md in .opencode/_bitacora/"
tags: [template, bitacora, report, record, completion]
status: active
---
<!-- Bitacora report template — one file per completed task, written at close per bitacora-workflow.
     Destination: .opencode/_bitacora/task-report/{YYYYMMDD}-{HHMMSS}-{slug}.md.
     Trigger: bitacora-close.sh scaffolds the file; the agent fills it at completion.
     Ground source of truth: this template lives in _templates/.
     Governing rules: RUL.REPORT.WRITE, RUL.WORKFLOW.BITACORA.STDOUT.
     Register: BULLET.template.md — junction bullets, one fact per line, subject opens.
     Every command pipes through `bitacora-log.sh {name} -- {command}` → task-stdout/. -->

# {YYYYMMDD}-{slug}

Date: {YYYY-MM-DD}
Status: completed

## What was done

- {completed work — junction bullet, factual, declarative}
- {completed work — junction bullet}
- {completed work — junction bullet}

## Decisions

- {decision made — junction bullet, declarative}
- {decision made — junction bullet}

## Verification

- {check performed and its result — quantity or rule citation}
- {check performed and its result}

## Open edges

- {unresolved item — deferred, blocked, or pending}
- {unresolved item}

## Todo state

- {todo file: path; items completed, cancelled, or carried forward}
- {log references: task-stdout/{YYYYMMDD}-{HHMMSS}-{name}.log for each command}
