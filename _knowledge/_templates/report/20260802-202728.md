# Templates refactor — coherence pass

**Date:** 2026-08-02
**Project:** `_knowledge/_templates/` — bootstrap system

## What was done

- Audited the template set (3 surveys): found 6 orphaned precepts, typo `write-reportare`, extensionless `fixtures-template`, failed `_rustlib` ANN experiment, binary DBs tracked in git, 13-layer scaffold chain matching no live project.
- Archived 12 dead-weight items to `_knowledge/.archive/templates-legacy/`: `_rustlib/`, 6 orphaned precepts, both stale report templates, `fixtures-template`, 2 dive templates.
- Rewrote `scaffold-knowledge.sh` — lean chain (`precept/ concept/ reference/ fixture/` + `script/` parallel) matching rust-docs; report copy points at live `report/report-template.md`; `--with-skills` copies 10 live skills (find-skills dropped — home-sourced).
- Created `run-logged-template.sh` — generalized `_knowledge/{project}/script/` logger.
- Rewrote `AGENTS.template.md` + `_templates/AGENTS.md` — lean chain, updated inventory, archive location documented.
- Fixed `bench.ts` (dead Rust BIN ref, Go label, report path) + `semantic-search.ts` comment.
- Untracked `schema/templates.db` + `templates-vector.db`; added re-ignore rules after the substrate un-ignore.
- Dry-ran scaffold twice — lean dirs, AGENTS.md, templates, run-logged.sh, 10 skills verified.

## Decisions

- Lean chain as scaffold default; 13-layer topology stays in `precedence-chain.md` as reference.
- Archive over delete — nothing lost, `templates-legacy/` consultable.
- Go ANN (`_golib/ann`) stays the semantic backend; Rust experiment archived with its lesson documented.
- Binary DBs untracked per root convention (only `.sql` is source).

## Open edges

- `copy-skills.sh` resolves only `.opencode/skills/` — home-sourced skills (find-skills, omarchy) need manual mirroring.
- Codex-side templates (`_codex/_templates/`) still carry the old 13-layer set — read-only, intentionally untouched.

## Todo state

- `2026-08-02--refactor-knowledge-templates-for-coherence.md` — all tasks complete.

## Logs

- task-stdout: templates-survey, templates-coherence-audit, templates-detail-audit, templates-archive, write-report-archive, ann-wiring-check, templates-db-untrack, scaffold-dry-run, fixes-verify, templates-refactor-close, templates-refactor-report
