# Skills format standardization

Session scope: standardize `.opencode/skills/*/SKILL.md` files onto one canonical format; archive stale skills pointing at disabled/archived files.

## Metadata (phase 1 — COMPLETE)

- [x] Decide canonical frontmatter field set — `name` + `description` + `state-profile` + `nexus` (optional); drop `type`/`related`/`patterns`/`terms`
- [x] Survey built + run (`_shell/survey/skills-metadata-survey/`, s01 scan + s02 nexus map, bitacora-logged)
- [x] Align governing docs — PROT.SKILL.SCHEMA Rule 9, refactor-skill, propose-tool, propose-mcp, guide-architecture, `_disabled/audit-skills.ts`
- [x] Batch-convert all 43 skill frontmatters (`_scripts/migrate-skill-metadata.sh`)
- [x] Verify — nexus audit `TOTAL=43 BAD_FIELDS=0 BAD_NEXUS=0 RESULT=pass`
- [x] Canonical template written to `.opencode/skills/.template/SKILL.md` (dot-prefixed, excluded from discovery)

## Stale-skill archive (COMPLETE — policy: skill → disabled/archived file ⇒ stale ⇒ archive)

- [x] Ground truth: live MCP set from opencode.json (exa, context7, parallel-search, mcp-semantic, playwright, mcp-findings, mcp-arxiv, mcp-biorxiv, mcp-rom-acquire)
- [x] Stale scan — 24 skills reference disabled tools (read-selection/read-projection/write-sync/mcp-log-search/patlib_*/audit-*/arxiv-search/verify-deps/entity_audit) or orphan SKL.*
- [x] Archive 24 → `.backups/20260802-120722-stale-disabled-refs/`
- [x] vet-proposal archived (delegates to archived judge-semantic) — 25 total archived
- [x] guide-reasoning archived (routes through disabled RUL.QUERY.PATLIB.CONTEXT + CMD.ANCHOR.WORKFLOW) — 26 total archived
- [x] Re-verify: 17 live skills, stale scan zero flags, nexus audit `TOTAL=17 RESULT=pass`, s01 scan clean

## Anchor workflow (COMPLETE — rewritten for live set)

- [x] `CMD.ANCHOR.WORKFLOW` found stale: 5 of 7 anchored skills archived, patlib MCP disabled
- [x] Command rewritten (22 → 14 lines, imperative register, live anchors, `semantic_search` via mcp-semantic)
- [x] YAML registry updated (description, tags, related, modified stamp)

## Body (phase 2 — COMPLETE for canonical body set)

- [x] Confirmed conventions: bold headings only (no `##`) — verified 17/17 live skills compliant
- [x] Canonical body section set decided: **Trigger, Procedure, Gotchas** only — Rules and See also removed per user directive
- [x] `.template/SKILL.md` updated — three body sections, imperative/affirmative prose guidance
- [x] `refactor-skill` rewritten to canonical body (Rules section removed; format constraints folded into Gotchas as positive redirects)
- [x] Rules sections stripped from 4 live skills, content folded into Gotchas (reason-quantitative, reason-verbal, study-foundations, survey-scripts)
- [x] `_disabled/audit-skills.ts` SECTION_REQUIREMENTS updated — `full` = [Trigger, Procedure, Gotchas]
- [x] Imperative register verified 17/17 — knowledge-ruby step 0 fixed (verb leads: "Read the relevant atomic file...")
- [x] Gotchas positive-redirect pairing — audited all skills; use-context-seven reframed affirmative (resolve-library-id first)
- [x] Tables → code blocks conversion (knowledge-ruby, survey-scripts, use-playwright-ai-mode, use-playwright-core, use-playwright-debug, use-playwright-network-storage, use-playwright-vision) — 7 skills, 175 table lines → aligned fences; residual-table grep clean, fence parity even, structural checks hold
- [x] Final audit + write-sync + re-embed — DB reconciled (54 purged, 7 inserted → 19 rows = 19 live), vector store purged 54 stale → VEC 19, MISS 0, STALE 0

## Restructure alignment (user-driven — COMPLETE)

- [x] User restructured live set: knowledge-ruby → knowledge-languages (ref/{bash,go,ruby,rust,typescript}.md); five use-playwright-* → playwright-dispatcher (ref/ + nested skill/); bitacora-workflow added
- [x] Live set settled at 14 dirs + 5 nested skills = 19 SKILL.md files — full sweep 19/19 OK (frontmatter, nexus, tables, fences, Rules/See-also/##)
- [x] bitacora-workflow, knowledge-languages, playwright-dispatcher aligned to canonical Trigger/Procedure/Gotchas; playwright-dispatcher gained nexus NEX.BROWSER.STACK
- [x] CMD.ANCHOR.WORKFLOW step 2 rewired: use-playwright-* → playwright-dispatcher

## Template updates (COMPLETE)

- [x] `.template/SKILL.md` — dispatcher/ref variant notes added to comment block
- [x] `.template/dispatcher/SKILL.md` — dispatcher canonical format (Trigger/Procedure/Gotchas, routes via ref/{mode}.md to nested skills)
- [x] `.template/dispatcher/ref/mode.md` — ref-file template, two shapes: mode refs (Route/Target/Notes) + language refs (Role/Ring/Style/Naming/Home/Select/Escalate)
- [x] PROT.SKILL.SCHEMA Rules 9/10 dispatcher-aware (nested skill/SKILL.md per dispatcher; each SKILL.md → one entry); gotcha added for dispatcher without ref/nested files
- [x] refactor-skill step 2 references dispatcher template variant

## Dispatcher expansion (semantic + search — COMPLETE)

- [x] `semantic-dispatcher` created — SKILL.md (nexus NEX.TOOL.CHOICE) + ref/{search,stats,drift,embed,purge,eval}.md + skill/use-semantic-{mode}/SKILL.md ×6
- [x] `search-dispatcher` created — SKILL.md (nexus NEX.INVESTIGATION.STAGE) + ref/{exa,parallel}.md + skill/{use-exa,use-parallel-search}/SKILL.md (moved from top-level, expanded with Tools blocks)
- [x] CMD.ANCHOR.WORKFLOW steps 1-2 rewired: semantic_search → semantic-dispatcher; use-exa/use-parallel-search → search-dispatcher; YAML registry updated
- [x] Structural sweep 27/27 OK (frontmatter, nexus, tables, fences, Rules/See-also/##); ref files table-free
- [x] DB reconciled: 8 inserted (search-dispatcher, semantic-dispatcher, 6 use-semantic-*) → 27 rows = 27 live; vector embedded 27, purge 0 stale, drift 27=27

## Dispatcher expansion (workflow — COMPLETE)

- [x] `workflow-dispatcher` created — SKILL.md (nexus NEX.META.ORCHESTRATION) + ref/{bash-flows,stdout,surveys,context-seven,bitacora}.md + skill/ ×5 moved nested (manage-bash-flows, structure-stdout, survey-scripts, use-context-seven, bitacora-workflow)
- [x] CMD.ANCHOR.WORKFLOW rewired: use-context-seven + workflow modes → workflow-dispatcher; YAML registry updated (modified 2026-08-02T20:15)
- [x] Structural sweep 28/28 OK; DB reconciled: 1 insert (SKL.WORKFLOW.DISPATCHER) → 28 rows = 28 live; vector embedded 28, drift 28=28; reconcile script fixed (related column drop)

## Stale removals (user-driven — COMPLETE)

- [x] `related` column dropped from skills table (ALTER TABLE ... DROP COLUMN, logged)
- [x] audit-skills tool removed (`.opencode/tools/_disabled/audit-skills.ts` deleted)
- [x] mcp-spec-audit confirmed archived (`_disabled/`); mentions removed from PROT.LLM.SPECIFICATION, PROT.MCP.TRANSPORT, PROT.META.DOMAIN, PROT.META.IDENTITY (partial)
- [x] LLM spec family archived → `entity-backups/20260802T185412/`: PROT.LLM.SPECIFICATION, PAT.LLM.ADVANCED, PAT.LLM.CONTENT, spec-audit-case-sensitive.md
- [x] Semantic cross-check + patterns reconciliation: 2 stale PAT.LLM rows/embeddings purged, PAT.EMBEDDING.BATCH inserted + embedded → patterns 6=6, 0/0/0 drift

## Open edges

- [x] DB: reconciled via `/tmp/opencode/reconcile-skills.py` (user-approved direct pass) — 54 orphan rows purged, 7 missing inserted → 19 rows = 19 live; sync lib still disabled
- [x] `skills.related` DB column dropped (no source field — column removed)
- [x] `_disabled/audit-skills.ts` removed (stale — archived tool deleted per user directive)
- [ ] 5 reference files still mention PROT.LLM.SPECIFICATION (ABS.ALPHA.EQUIVALENCE, ABS.BETA.REDUCTION, TERM.AUDIT.PATTERNS, CON.ABSTRACTION, COG.LOGICAL.OPERATORS)
- [ ] `_knowledge/code-semantics/` (doc/reference.md + AGENTS.md) reference archived use-spec-audit / PROT.LLM entities
- [ ] `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — candidate for rule-level rewrite

## Close-out

- [x] Session report in `_bitacora/task-report/`
