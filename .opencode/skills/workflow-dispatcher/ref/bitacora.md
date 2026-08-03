# Bitacora

**Route** — run the bitacora workflow at session or task start: create the todo first, log every command, write the report after.

**Target** — load `bitacora-workflow` before bitacora bookkeeping.

**Notes**

- Create the todo before work — the plan precedes any command.
- Log every command through the wrapper — each carries a `task-stdout/` record.
- Sequence aspects — atomic first, then distinct batches; parallel independent calls.
- Verify quantities with `qalc` before recording.
- Match the context's naming convention — `{YYYY-MM-DD}--{slug}.md` at root, `{YYYYMMDD}-{HHMMSS}-{slug}.md` in dive.
