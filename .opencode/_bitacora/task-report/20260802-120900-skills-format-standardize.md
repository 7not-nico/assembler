# 20260802-120900 — Skills format standardization: metadata + stale archive

## What was done

### 1. Metadata standardization (43 → 43 canonical frontmatter)

**Canonical frontmatter set** — `name` + `description` + `state-profile` + `nexus` (optional, one NEX.* ID). Dropped as stale: `type` (18 skills), `related` (33), `patterns` (19), `terms` (7).

**Survey** — `.opencode/_shell/survey/skills-metadata-survey/` (s01 frontmatter scan, s02 nexus map, run-survey orchestrator; bash-first per `_shell/AGENTS.md`). Logged via bitacora.

**Migration** — `.opencode/_scripts/migrate-skill-metadata.sh` rewrote all 43 frontmatters. Nexus mapped from existing refs + family heuristics, with corrections:
- propose-* family → NEX.META.PROPOSAL; reason-* + guide-reasoning → NEX.META.CANVAS; research/search → NEX.INVESTIGATION.STAGE; use-playwright-* → NEX.BROWSER.STACK; audit/classify/refactor → NEX.TOOL.SEQUENCE; manage-bash-flows/structure-stdout/search-papers → NEX.ACQUIRE.PIPELINE; stage-create → NEX.META.ORCHESTRATION; guide-architecture → NEX.TOOL.CHOICE
- 5 reference/query skills kept no nexus (knowledge-ruby, search-maxims/nexus/patterns/protocols)

**Verification** — `TOTAL=43 BAD_FIELDS=0 BAD_NEXUS=0 RESULT=pass` (nexus values resolve to live NEX.* files).

**Doc alignment** — PROT.SKILL.SCHEMA Rule 9 (related/patterns/terms → nexus); refactor-skill step 9 + Rules; propose-tool/propose-mcp frontmatter rules; guide-architecture (2 phantom `PROT.SKILL.STATECLASS` → `PROT.SKILL.PROFILE`); legacy `_scripts/survey/entity-segment-count/s02-crossref-audit.rb`; `_disabled/audit-skills.ts` (nexus format check + stale-field flag).

### 2. Stale-skill archive (policy: skill → disabled/archived file ⇒ stale ⇒ archive)

**Ground truth** — live MCP servers from opencode.json: exa, context7, parallel-search, mcp-semantic, playwright, mcp-findings, mcp-arxiv, mcp-biorxiv, mcp-rom-acquire. Everything else (patlib MCP servers, spec/entity audit, read-selection/read-projection/write-sync/mcp-log-search IPC, audit-* CLIs, arxiv-search, verify-deps) sits in `tools/_disabled/`.

**Scan** — body-reference scan flagged 24 skills referencing disabled tools or orphan SKL.* IDs.

**Archived 25** → `.opencode/skills/.backups/20260802-120722-stale-disabled-refs/`:
bootstrap-db, classify-tool, compose-web, declare-grounded-entity, guide-architecture, judge-semantic, orchestrate-research, propose-command/investigation/mcp/pattern/protocol/rule/term/tool, scaffold-tools, search-geo/maxims/nexus/papers/patterns/protocols, stage-create, use-entity-audit, vet-proposal (archived second — delegates to archived judge-semantic).

**Remaining live (18)**: guide-reasoning, knowledge-ruby, manage-bash-flows, reason-invariants, reason-quantitative, reason-verbal, refactor-skill, structure-stdout, study-foundations, survey-scripts, use-context-seven, use-exa, use-parallel-search, use-playwright-ai-mode/core/debug/network-storage/vision.

**Post-archive verification** — stale scan zero flags; nexus audit `TOTAL=18 BAD_FIELDS=0 BAD_NEXUS=0 RESULT=pass`; s01 frontmatter scan clean (all canonical, no `type`/`related`/`patterns`/`terms`).

## Decisions

- Canonical frontmatter = name/description/state-profile/nexus; `type` dropped (no DB column, from disabled audit tool)
- Nexus is a single optional field; skills without composition fit omit it
- Stale policy is binary: any disabled/archived reference ⇒ archive the skill (no body rewriting)
- Archive destination: `.backups/{stamp}-stale-disabled-refs/` (dot-prefixed → excluded from discovery + audit)

## Errors found / fixed

- Migration script ROOT path bug (`..` → `../..`) — first run `MIGRATED=0`, fixed and rerun `MIGRATED=43`
- Nexus audit case patterns assumed name-first; fields sort alphabetically — corrected
- Stale scan false positives (SKL.JUDGE.SEMANTIC trailing dot) — cleaned with explicit live-dir mapping

## Open edges

- **DB 66 skill rows vs 18 live dirs**: 48 orphan rows (archived) + 4 live skills missing rows (manage-bash-flows, reason-invariants, structure-stdout, survey-scripts — never synced). Sync lib disabled; needs `r6-patlib-sync.rb` (sqlite3 gem) or direct pass
- `skills.related` DB column stale (source field removed)
- `_disabled/audit-skills.ts` updated but server not reactivated
- Body standardization pending for the 18 live skills (phase 2): `##` headers in some, tables in knowledge-ruby/use-playwright-*, gotcha pairing, canonical template

## Logs

- `task-stdout/20260802-114151-skills-metadata-probe.log`
- `task-stdout/20260802-115343-skills-metadata-survey.log`
- `task-stdout/20260802-115650-skills-metadata-migrate.log`
- `task-stdout/20260802-skills-metadata-verify.log` (verify pass)

## Todo state

Metadata: complete. Stale archive: complete. Body phase 2: pending (18 live skills). DB reconciliation: open.
