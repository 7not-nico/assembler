# 20260731-204900-template-repurposing.md

**Date:** 2026-07-31
**Project:** `_trove/` — template repurposing from `_codex/_templates/` + bitacora layer seeding

## What was done

```
Templates:  6 dive-layer templates copied from _codex/_templates/ and repurposed:
            invariant-template.md (task-invariant predicates)
            fixture-template.md   (catalog harnesses)
            backup-template.md    (findings.db restore points)
            guideline-template.md (task-invariant constitution)
            study-template.md     (catalog architecture)
            domain-agents-template.md (renamed from dive-agents; trove-domain AGENTS
            scaffold — chain verbatim, catalog layer roles, delegation)
Scripts:    run-logged.sh, slugify.sh, start-browser-headless.sh copied verbatim
            (shared infra); atomic-script-template.sh repurposed in _scripts/
            (guard path fixed, Ruby-only DB rule in header)
Bitacora:   task-stdout/ created (run-logged target); smoke-test logged
            task-backup/ seeded (backup.md — restore convention)
            task-study/ seeded (catalog-architecture.md — pipeline + change inventory)
AGENTS.md:  tooling table 3→7 scripts; bitacora layer list; template inventory section
```

## Decisions

```
- Shared infra copied verbatim (run-logged, slugify, browsers) — no forks, per codex
  reusable-infrastructure convention
- atomic-script-template repurposed in _scripts/ — it is the new-script shape for
  this project, not a _templates/ artifact
- domain-agents-template renamed over dive-agents — trove holds domains, not dives
- task-backup/ + task-study/ seeded as records, not just folders — conventions
  documented before first use
```

## Errors found

```
1. dive-agents-template copy still carried codex content after rename — repurposed
   content not written in the prior session; fixed now
2. atomic-script-template guard path `../../_templates/start-browser.sh` resolves to
   assembler root from _trove/_scripts/ — wrong; fixed to same-dir start-browser.sh
```

## Findings

```
1. run-logged.sh path logic (`../_bitacora/task-stdout`) resolves correctly from
   _trove/_scripts/ — the shared-infra copy needs no trove-specific edits
2. slugify.sh matches catalog naming convention — the exact tool the download
   pipeline should use for filename generation
3. headless browser (9223) enables scripted crawls without touching the headed
   session (9222) — the Playwright crawl pattern generalizes
4. template parity with _codex/_templates now complete except _golib/_rustlib/lib
   (bootstrap infra, not catalog layers)
```

## Open edges

```
- fixtures F3/F5 reruns now flow through run-logged.sh (2026-07-31, logs in
  task-stdout/) — convention adopted
- registry push ran: 22 templates + 10 reports → _templates/schema/templates.db;
  push-registry.rb repurposed (report/ singular glob); trove bitacora reports
  (task-report/) not registered — script scoped to _templates/report/, decide
  whether to extend
- first real backup + change inventory at the first schema migration or bulk edit
```

## Todo state

```
Completed: template copies + repurposes (6 md + 4 scripts), task-stdout/backup/study
           seeding, AGENTS.md updates, todo close, infra triage (keep decision),
           registry push, run-logged adoption (F3 + F5 logged reruns)
Pending:   bitacora-report registration decision, first real backup at migration
```
