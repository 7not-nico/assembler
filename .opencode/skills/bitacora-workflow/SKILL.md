---
name: bitacora-workflow
description: Use this skill at session or task start — it creates the todo first, logs every command, and writes the report after, per the workspace bitacora convention
state-profile: stateful-writer
nexus: NEX.META.ORCHESTRATION
---

**Trigger**

Every session or task start — a todo precedes work, every command logs, a report follows. `IDENTITY.BITACORA`, `RUL.TODO.TRACK`, `RUL.REPORT.WRITE`, `RUL.WORKFLOW.BITACORA.STDOUT` govern. Two contexts differ:

- Root — `.opencode/_bitacora/`, `bitacora-log.sh`, todo `{YYYY-MM-DD}--{slug}.md`
- Dive — `_codex/_bitacora/`, `run-logged.sh`, todo `{YYYYMMDD}-{HHMMSS}-{slug}.md`

**Procedure**

1. Create the todo: `bitacora-log.sh {name}-instantiate -- bitacora-create.sh todo "{topic}"`; list real tasks.
2. Log every command through the wrapper; cite the `task-stdout/` log.
3. Check items as they complete; one in flight at a time.
4. Sequence aspects: atomic first, then distinct batches; parallel independent calls.
5. Verify quantities with `qalc -t "{claim}"` before recording.
6. Append precept Instance records on rule touches.
7. Close: `bitacora-close.sh {todo} "{topic}"`; fill the report — done, decisions, edges, todo state; cite logs.
8. Verify with `bitacora-find.sh {topic}`.

**Gotchas**

- Write the plan before any command — the todo precedes execution
- Log every command through the wrapper — each carries a `task-stdout/` record
- Mark items complete or cancelled at close — one in flight at a time
- Fill every report section — done, decisions, edges, todo state
- Verify quantities with `qalc` before recording
- Match the context's naming convention — `{YYYY-MM-DD}--{slug}.md` at root, `{YYYYMMDD}-{HHMMSS}-{slug}.md` in dive
