---
name: manage-bash-flows
description: Use this skill when a workflow runs as manual, repeated, or ad-hoc steps — detect the flow, generate atomic bash scripts per the atomic-script contract, compose them into orchestrators, and pipe every command through bitacora stdout logging. Reference NEX.META.ORCHESTRATION for phase separation and NEX.ACQUIRE.PIPELINE for stage composition
state-profile: stateful-writer
related: ["NEX.META.ORCHESTRATION", "NEX.ACQUIRE.PIPELINE"]
---

**Purpose**

Turn manual or repeated workflow steps into atomic, programmatically managed bash flows. Make every flow step one script; compose scripts into orchestrators; pipe orchestrator output through the bitacora log wrapper. Separate phases and compose stages per `NEX.META.ORCHESTRATION` and `NEX.ACQUIRE.PIPELINE`.

**Detection triggers**

Activate this skill when any of these hold:

- A task repeats the same manual sequence (download → verify → prepare → launch)
- A workflow relies on ad-hoc commands per run
- A multi-step flow needs one entry point
- A step's output feeds the next step's input and humans relay it by hand

**Atomic unit contract**

Follow the template `_templates/atomic-script-template.sh` and the atomic-composition contract for every generated script:

- Give one script one responsibility
- Pass args in; emit a keyed result line (`KEY=value`) out; write diagnostics to stderr
- Exit non-zero on any failure
- Attach to shared daemons, including the browser on CDP 9222
- Guard shared resources before work
- Open each script with `set -uo pipefail`

**Script naming**

- Name files `{action}-{subject}.sh` — lowercase dash-slug, e.g. `fetch-rom.sh`, `verify-rom.sh`
- Write a header comment naming one task, the usage line, and the atomic contract note
- Use one singular PascalCase descriptor word for a constant; one singular concrete lowercase word for a function; two camelCase words for a method

**Procedure**

1. **Detect the flow** — list the manual steps in order. Make each step one atomic script candidate, named `{action}-{subject}.sh`.

2. **Self-audit** — check `scripts/` for existing coverage. Extend an existing script; surface duplicate scripts for extraction.

3. **Separate phases** — split the flow into read phases and write phases per `NEX.META.ORCHESTRATION`. Complete all reads before any write executes; pass the intermediate artifact between phases.

4. **Scaffold each atomic script** — copy `_templates/atomic-script-template.sh`; keep the contract header; fill the guard and the work section; emit one keyed result line.

5. **Wire the guard** — check shared resources (browser on CDP 9222, DB, service) before work; on failure print a diagnostic to stderr and exit non-zero.

6. **Compose the orchestrator** — build the top-level conductor to run the atomic steps in stage sequence per `NEX.ACQUIRE.PIPELINE`:
   ```bash
   bash scripts/{step1}.sh "$ARG" || exit 1
   key="$(bash scripts/{step2}.sh "$ARG" | tail -1 | cut -d= -f2)" || exit 1
   bash scripts/{step3}.sh "$key" || exit 1
   ```
   Feed each step's keyed line into the next step's arg; stop the chain on failure.

7. **Wire bitacora logging** — pipe every command the agent runs through the log wrapper:
   ```bash
   bash run-logged.sh {name} -- bash scripts/{step}.sh "{arg}"
   ```
   The wrapper writes `_bitacora/task-stdout/{timestamp}-{name}.log` with a `# CMD:` header, streams live, and appends the exit status.

8. **Verify** — run each atomic script standalone (exit code + keyed line); run the orchestrator end-to-end; confirm the log file landed in `_bitacora/task-stdout/`.

9. **Record** — write the todo before the flow; write the report after; reference each log file in both.

**Verification checklist**

- [ ] Each step = one script, one responsibility
- [ ] Each script: `set -uo pipefail`, guard, keyed output, non-zero on failure
- [ ] Reads complete before writes; the artifact hands between phases
- [ ] The orchestrator feeds keyed lines forward and stops on failure
- [ ] Every command pipes through the bitacora log wrapper
- [ ] Log files sit in `_bitacora/task-stdout/`
- [ ] Scripts sit in `scripts/`, one per step

**Gotchas**

- Attach scripts to shared daemons; let the shared browser and services carry all sessions
- Keep the orchestrator the single entry point; run one command and let the chain follow
- Treat keyed result lines as the contract between steps; extract each key with `tail -1 | cut -d= -f2`
- Note the log wrapper per project: `run-logged.sh` (codex) or `bitacora-log.sh` (assembler root)
