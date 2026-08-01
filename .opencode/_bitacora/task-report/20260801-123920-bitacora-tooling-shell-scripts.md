# Bitacora Tooling Shell Scripts

Timestamp: 2026-08-01 123920

## What was done

Repurposed 4 shell templates from `_codex/_templates/shell/` into `.opencode/_bitacora/`, adapting the codex dive-tooling patterns to the root bitacora record workflow.

| Script | Source template | Function |
|--------|-----------------|----------|
| `bitacora-init.sh` | `copy-templates.sh` | Ensures skeleton: task-audit/plan/reference/report/survey/todo/stdout + README |
| `bitacora-slugify.sh` | `slugify.sh` | Topic → lowercase dash-slug for record names |
| `bitacora-create.sh` | `scaffold-knowledge.sh` | Scaffolds records with convention naming + template body |
| `bitacora-log.sh` | `run-logged.sh` | Runs command → `task-stdout/{stamp}-{name}.log` with CMD/DATE/CWD header + exit status |

All four chmod +x and tested:

- `bitacora-init.sh` — created `task-stdout/` + `README.md` (7 folders total)
- `bitacora-slugify.sh` — `"Scripts Health Audit & 2026 Report!"` → `scripts-health-audit-2026-report`
- `bitacora-create.sh todo "Bitacora Tooling"` → `task-todo/2026-08-01--bitacora-tooling.md`
- `bitacora-log.sh smoke` — wrote `task-stdout/{stamp}-smoke.log`, streamed live, propagated exit 3; smoke log removed after verification

Records produced by the tools themselves (dogfood): the todo above and this report, both created via `bitacora-create.sh`.

## Decisions

- **Placement** — scripts live directly in `.opencode/_bitacora/` per user instruction; root AGENTS.md places tools in `.opencode/tools/` — user-directed override, flagged as open edge
- **Naming conventions** — todo → `task-todo/{YYYY-MM-DD}--{slug}.md` (per task-todo README); other records → `task-{kind}/{YYYYMMDD}-{HHMMSS}-{slug}.md` (per root AGENTS.md + codex precedent)
- **task-stdout added** — codex `_bitacora/` precedent includes it; `{?}-{concrete noun}` convention holds
- **Kind set** — todo|report|audit|plan|survey|reference, one script per record type via template body switch
- **Repurposed 4 of 8 templates** — skipped `copy-skills.sh`, `fetch-repo.sh`, `start-browser*.sh` (domain-specific, no bitacora analog)

## Open edges

- Report body authoring remains manual after scaffold — no auto-fill from live command output
- `task-stdout/` naming diverges slightly from root AGENTS.md's six-folder list (extension, not violation)
- Placement in `_bitacora/` vs `.opencode/tools/` — confirm with user before more tooling lands
- Prior scripts-health audit still open: 6 audit wrappers (`r1-*-audit.rb`) call nonexistent `rs audit` subcommand — exit 2 at runtime

## Todo state

- `task-todo/2026-08-01--bitacora-tooling.md` — completed (2026-08-01)
- `task-todo/2026-08-01--scripts-health-audit.md` — in progress (prior session, superseded by this task)
