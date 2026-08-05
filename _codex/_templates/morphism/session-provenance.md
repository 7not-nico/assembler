---
id: PATTERN.SESSION.PROVENANCE
title: Session Provenance — Run-Local ID, Rich Header, Trace-Opt-In
layer: pattern/
purpose: "A logged run carries a run-local session id plus the full provenance header — ENV, TOOLS, PID, GIT, BRANCH — and trace opts in only when asked."
naming: session-provenance.md
tags: [pattern, morphism, provenance, session, bitacora, header]
status: active
---
# SESSION-PROVENANCE.md

**Layer:** pattern/
**Naming:** `session-provenance.md` — code morphism, reusable structure.
**Composes with:** `pattern/bitacora-log-framing.md`; derived from `study/` + `fixture/` proof.

## Morphism

A logged run carries a run-local session id and the full provenance header — ENV, TOOLS, DATE, PID, GIT, BRANCH, SCOPE, TASK, CLI, ARGS, CWD — with trace enrichment opt-in, never default.

## Structure

```text
header: CMD, ENV, TOOLS, DATE, PID | DUR, exit, GIT, BRANCH,
        SCOPE, SESSION, TASK, CLI, ARGS, OUT, IN, CWD
SESSION: $BITACORA_SESSION env when set; else run-local 8-hex id
         (date +%s%N | sha256sum | cut -c1-8)
trace:   opt-in via --trace → tracexec log (never default)
```

Invariant: every run is addressable by its session id; the header records the environment and identity at run time; trace enriches only on request; the frame opens before and closes after the stream.

## Verification

Two runs of the same command produce different session ids; setting `BITACORA_SESSION` pins the id; the header carries ENV/TOOLS/PID/GIT/BRANCH; without `--trace` the log holds plain output only.

## Instance

Root `.opencode/_bitacora/bitacora-log.sh` (reference) — the full provenance contract; the codex `shell/bitacora-run.sh` simplifies to CMD/DATE/CWD + DUR/exit (2026-08-05) — the reduced frame the dive flow uses.
