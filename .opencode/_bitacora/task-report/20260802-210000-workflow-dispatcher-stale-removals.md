# 20260802-210000 — Workflow dispatcher + stale removals session

## What was done

### 1. `workflow-dispatcher` created

Dispatcher for the five workflow skills, mirroring the playwright/semantic/search dispatcher pattern.

- **SKILL.md** — `name: workflow-dispatcher`, `state-profile: stateless`, `nexus: NEX.META.ORCHESTRATION`; Trigger/Procedure/Gotchas; `NEX.META.ORCHESTRATION` governs
- **ref/ ×5** — bash-flows, stdout, surveys, context-seven, bitacora (Route/Target/Notes, imperative style)
- **skill/ ×5 moved nested** — manage-bash-flows, structure-stdout, survey-scripts, use-context-seven, bitacora-workflow (content preserved; old top-level dirs removed)

### 2. Wired in

- CMD.ANCHOR.WORKFLOW: step 2 routes use-context-seven via workflow-dispatcher; step 5 consolidates bash flows/stdout/surveys/bitacora under it; old surveys step merged; step count 7 → 6
- YAML registry: description + modified stamp (2026-08-02T20:15)

### 3. Verification — PASS

- Structural sweep **28/28 SKILL.md files OK** — 10 top-level dirs (4 dispatchers + knowledge-languages + 5 reasoning/study/refactor) + 18 nested skills; frontmatter fields, nexus, zero tables, even fence parity, no Rules/See-also/##
- **DB reconciled:** 1 insert (SKL.WORKFLOW.DISPATCHER), 0 purges → **28 rows = 28 live**, 0 missing, 0 orphans
- **Vector reconciled:** embed 28, drift → **DB 28, VEC 28, MISS 0, STALE 0**

### 4. Reconcile script fix

`/tmp/opencode/reconcile-skills.py` INSERT still referenced the dropped `related` column → fixed to 10-column form (id, title, description, trigger, procedure, gotchas, rules, body, skill, state_profile).

## Session recap (this task chain)

| Item | State |
|------|-------|
| related column drop | complete (logged) |
| audit-skills removal | complete |
| mcp-spec-audit mention cleanup | complete (partial — META.IDENTITY done this pass) |
| LLM spec family archive | complete (4 entities → 20260802T185412) |
| patterns reconcile (cross-check) | complete (6=6, 0/0/0) |
| workflow-dispatcher | complete (28=28) |

## Decisions

- Workflow dispatcher consolidates five workflow-mode skills under one route — one home per skill per RUL.CODE.SHARED.CODE
- Nexus NEX.META.ORCHESTRATION for the workflow dispatcher (orchestration governs all five modes)
- Moves preserve content verbatim — no body edits during relocation

## Open edges

- 5 reference files still mention PROT.LLM.SPECIFICATION (ABS.ALPHA.EQUIVALENCE, ABS.BETA.REDUCTION, TERM.AUDIT.PATTERNS, CON.ABSTRACTION, COG.LOGICAL.OPERATORS)
- `_knowledge/code-semantics/` (doc/reference.md + AGENTS.md) reference archived use-spec-audit / PROT.LLM entities
- `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — rule-level rewrite candidate
- survey-scripts references Ruby (`r*-*.rb`, `_rb/`) — stale-language candidate per bash-first direction

## Logs

- `task-stdout/20260802-{time}-skills-db-reconcile-workflow.log` — reconcile apply (1 inserted, exit 0)

## Todo state

Metadata: complete. Stale archive: complete. Anchor rewrite: complete. Body canonical set: complete. Tables → code blocks: complete. Restructure alignment: complete. Template updates: complete. Dispatcher expansion: complete (playwright + semantic + search + workflow = 28 skills). Stale removals: complete (related, audit-skills, mcp-spec-audit mentions, LLM-spec family). Remaining: 5 PROT.LLM reference rephrases, _knowledge/code-semantics pair, rule cleanup, survey-scripts language.
