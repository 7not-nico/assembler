# repurpose codex templates for knowledge

Timestamp: 2026-08-02 20260802-193153

## What was done

- Surveyed `_codex/_templates/` vs `_knowledge/_templates/` — diffed every shared file; isolated the exact gap: 2 of 37 files differed (`AGENTS.md` knowledge-canonical, `dive-agents-template.md` stale) and `report/` was missing from knowledge (git-tracked files deleted from the working tree)
- Copied `_codex/_templates/report/` → `_knowledge/_templates/report/` — 12 files: `report-template.md` + 11 session reports (10 restored git deletions + `20260802-063345.md`); the improvement loop now lives in knowledge per root AGENTS.md
- Synced `dive-agents-template.md` from `_codex/_templates/` → `_knowledge/_templates/` — the Identity-grounded version (per `IDENTITY.AGENT`, `RUL.AGENTS.STATE`, `SPEC.AGENTS.SELF.CONTAINED`)
- Verified: re-diff shows only intentional differences remain; `scaffold-knowledge.sh` and `copy-skills.sh` confirmed byte-identical to codex `shell/` copies; `_codex/` read-only throughout

## Decisions

- `_codex/` untouched — copies flowed one direction (codex → knowledge); the pre-existing ` M _codex/_templates/dive-agents-template.md` predates this task (codex-templates-update session)
- `_knowledge/_templates/AGENTS.md` unchanged — its inventory already declares the required set (bootstrap, layers, conventions, infrastructure incl. `report-template.md`); no codex dive lines belong
- Schema DBs (`templates.db`, `templates-vector.db`) not copied — derived registry artifacts, not templates; each template set keeps its own
- Codex `shell/` organization not adopted — knowledge documents tooling at root (`scaffold-knowledge.sh`, `copy-skills.sh`) and root AGENTS.md references the root paths
- Dive templates stay in knowledge as shared substrate; only the stale one was brought current

## Open edges

- Knowledge `schema/templates.db` registry may lag the restored report set — `script/push-registry.rb` re-run refreshes it
- The two template sets remain mirrors by convention, not by automation — `copy-templates.sh` in codex `shell/` is the sync point

## Todo state

- [x] Survey `_codex/_templates/` vs `_knowledge/_templates/` — diff all shared files, map gaps
- [x] Copy `report/` from `_codex/_templates/` → `_knowledge/_templates/` (report-template.md + session history)
- [x] Sync `dive-agents-template.md` from `_codex/_templates/` → `_knowledge/_templates/` (Identity-grounded version)
- [x] Verify — re-diff; knowledge set current except intended AGENTS.md + schema DBs
- [x] Write the session report `.opencode/_bitacora/task-report/20260802-193153-repurpose-codex-templates-for-knowledge.md`

## Logs

- `task-stdout/20260802-193127-repurpose-copy-report.log` — report/ copy
- `task-stdout/20260802-193127-repurpose-sync-dive-agents.log` — dive-agents sync
- `task-stdout/20260802-193134-repurpose-verify.log` — post-copy diff + counts
