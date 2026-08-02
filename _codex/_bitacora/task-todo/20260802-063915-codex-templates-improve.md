# Codex templates improvement — from mgba-repo realization

## Plan (this session)

- [x] Survey mgba-repo dive — identify doctrine beyond current templates
- [x] Update `_templates/precedence-chain.md` — ring 0-3 ordinal structure + `concept/` layer
- [x] Extend `_templates/dive-agents-template.md` — Build flow, Test suite, qalc doctrine, Change inventory sections
- [x] Add six precept templates (verify-qalc, record-metrics, run-fixtures, atomic-documents, use-ripgrep, use-shared-browser)
- [x] Apply communication rules (RUL.COMMUNICATION.*) to all templates — SOV, declarative, affirmative
- [x] Align `study-template.md` — inventory out, Grounding + qalc table in
- [x] Enrich `guideline-template.md` — four-axis categories, kinds, strengths, non-invariants
- [x] Update `backup-template.md` — `study-monoliths/` documented
- [x] Register precepts in `copy-templates.sh` CODEX_FILES + `_templates/AGENTS.md` inventory
- [x] Propagate via `copy-templates.sh` → `mgba-repo/template/` — verify sync (15/15)
- [x] Write session report `_templates/report/20260802-063345.md`

## Open edges (future todos)

- [x] snes9x-repo `template/` — run `copy-templates.sh` for consistency (RESOLVED: snes9x uses shared `_templates/` directly, no local `template/` copy — edge moot)
- [x] `naming-conventions-template.md` — list codex dive precept naming (`precept-{action}-domain`) (DONE: new `dive-naming-conventions-template.md` — codex-owned, communication-compliant, propagated)
- [x] `templates.db` — rerun `push-registry.rb` for the six new precept templates (DONE: 31 templates; reports-glob bug `reports/` → `report/` fixed; 11 reports registered; semantic-embed 44 current)
- [ ] `mgba-repo/AGENTS.md` — align wording with new `dive-agents-template.md` sections (optional, dive content not template)
