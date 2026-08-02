# playwright-dispatcher-ref

Timestamp: 2026-08-02 20260802-160738

## What was done

- Renamed `knowledge-languages/reference/` → `knowledge-languages/ref/`; updated the dispatcher description and procedure paths.
- Updated 5 stale `knowledge-ruby` references to `knowledge-languages`: `commands/anchor-workflow.md`, `entities/protocols/PROT.KNOWLEDGE.SCHEMA.md`, `_scripts/guides/operational-procedure.md`, `_shell/survey/skills-metadata-survey/s02-nexus-map.sh`, `_scripts/migrate-skill-metadata.sh`.
- Built the playwright dispatcher at `skills/playwright-dispatcher/` — dispatcher `SKILL.md` plus `ref/` mode files: core, ai-mode, debug, network-storage, vision. Routes per `PRE.PLAYWRIGHT.STANDARD.ROUTE`.
- Housed all five `use-playwright-*` skills under `skills/playwright-dispatcher/skill/` (the `skill/` folder replaces the earlier `module/` folder).
- Verified no stale live references — only historical bitacora logs name old paths; skill names stay intact for `anchor-workflow.md` and `operational-procedure.md`.
- Followed the bitacora workflow through: todo, logged commands, close, report.

## Decisions

- **`skill/` + `ref/` at the dispatcher root** — the user pivoted from `module/` to `skill/`; the dispatcher root `playwright-dispatcher/` holds both folders.
- **Skill names unchanged** — the moved `use-playwright-*` skills keep their names; the loader scans `**/SKILL.md` recursively, so nesting registers them.
- **Form per the communication rules** — imperative register, verb-led routes, root nouns (no action nouns), affirmative framing, condensed, no tables.
- **Governing spec** — `PRE.PLAYWRIGHT.STANDARD.ROUTE` cited in the dispatcher; `SPEC.LANGUAGE.*` + `SPEC.CODE.ELEMENT.NAME` cited in the language dispatcher.

## Open edges

- All new/restructured skills register at restart — opencode loads skills at start; this session's list reflects the old layout.
- The `ref/` rename in `knowledge-languages` — check nothing else hardcodes `reference/` (grep clean for live files).

## Todo state

- `task-todo/2026-08-02--playwright-dispatcher-ref.md` — completed; this report closes the record.
