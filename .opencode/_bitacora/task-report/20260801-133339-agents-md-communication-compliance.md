# AGENTS.md Communication Compliance

Timestamp: 2026-08-01 133339

## What was done

Applied three compliance passes to `/home/eddyr/assembler/AGENTS.md`:

1. **Mandate added** — `task-stdout/` joined the record-folder list; every command now passes through `bitacora-log.sh {name} -- {command}`; the script writes `{YYYYMMDD}-{HHMMSS}-{name}.log` with a `# CMD:` header, streams output live, appends the exit status.
2. **Communication rules applied (full file)** — every sentence now leads with its subject (SOV), verbs act in active voice, nouns stay simple, statements declare. Imperatives converted to declarative register (`"restart after edits"` → `"edits require a restart"`; `"See ... for details"` → `"...holds query flags"`). CLI tool section converted from dense inline chains to a 4-item structured list.
3. **Negation removal (full file)** — zero lexical negators remain. Positive replacements: `"no build step/tsconfig"` → `"build steps and tsconfig stay out of the workflow"`; `"they drop nothing"` → `"destructive changes stay excluded"`; `"no git repository"` → `"Git repositories stay out of this directory"`; `"no IPC variant"` → `"CLI-only usage applies"`; `"locks opencode"` → `"stays CLI-only"`; `"not afterthoughts"` → `"first-class outputs"`. State labels retained per `RUL.WRITING.AVOID.NEGATION.PRIMING`: `rests disabled`, `deactivated`, `stay excluded`, `CLI-only`, `empty`.

## Decisions

- State labels (disabled, excluded, empty, CLI-only) count as positive forms — the desired state names the rule.
- Command strings and notation stay verbatim; prose around them complies.
- Negation scan scope: lexical negators (`no|not|never|none|nothing|neither|nor|without|lacks|absent`); compound state labels exempt.
- `semantic-search` bullet: `"no IPC variant"` replaced by `"CLI-only usage applies"`, removing the redundant `(CLI only ...)` parenthetical.

## Open edges

- ~~State labels (disabled, excluded, empty) — user confirm whether they satisfy the "no negation" intent~~ **CLOSED 2026-08-01** — state labels removed; file now fully affirmative (`sits archived`, `skips version control`, `skips WAL and sidecar files`, `carries plugin registrations when present`, `runs from the CLI`). Extended scan: zero negators, zero state labels. `_disabled/` survives as literal path notation only.
- The 6 audit wrappers + exec-bit defects remain parked (`task-todo/2026-08-01--audit-wrappers-fix.md`).
- `_scripts/.git` holds zero commits — toolchain unprotected.

## Todo state

- `task-todo/2026-08-01--bitacora-tooling.md` — completed
- `task-todo/2026-08-01--audit-wrappers-fix.md` — in progress (paused)
- `task-todo/2026-08-01--scripts-health-audit.md` — in progress (paused)

## Verification logs

- `task-stdout/{stamp}-agents-md-compliance.log` — token scan 16/16 OK, imperative scan clean (prior pass)
- `task-stdout/20260801-133334-agents-md-negation-verify.log` — negation scan zero, token scan 16/16 OK, imperative scan clean
- `task-stdout/20260801-134741-agents-md-fully-affirmative-verify.log` — extended scan (negators + state labels) clean, token scan 16/16 OK
