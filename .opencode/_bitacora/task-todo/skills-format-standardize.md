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
- [ ] Gotchas positive-redirect pairing where missing
- [ ] Tables → code blocks conversion (knowledge-ruby, use-playwright-* still carry tables)
- [ ] Final audit + write-sync + re-embed

## Open edges

- [ ] DB: 66 skill rows vs 17 live dirs — 49 orphan rows (archived skills) + 4 live skills missing rows (manage-bash-flows, reason-invariants, structure-stdout, survey-scripts); sync lib disabled → needs `r6-patlib-sync.rb` or direct pass
- [ ] `skills.related` DB column now stale (no source field) — drop or keep empty
- [ ] `_disabled/audit-skills.ts` updated for nexus but server not reactivated
- [ ] `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — candidate for rule-level rewrite

## Close-out

- [x] Session report in `_bitacora/task-report/`
