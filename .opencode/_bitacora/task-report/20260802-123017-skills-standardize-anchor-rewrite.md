# 20260802-123017 — Skills standardization: archive close-out + anchor rewrite

## What was done

### 1. Metadata standardization (43 → canonical frontmatter) — carried from prior session

Canonical frontmatter `name` + `description` + `state-profile` + `nexus` (optional). Dropped `type`/`related`/`patterns`/`terms`. Survey + migration + verification complete in the previous session (report `20260802-120900-skills-format-standardize.md`).

### 2. guide-reasoning archived (26th skill)

**Verdict: stale.** Its procedure "consult patlib for MAX/SPEC/IDENTITY/PROT/RUL" routes through `RUL.QUERY.PATLIB.CONTEXT` — which mandates `mcp-patlib` + `mcp-patlib-vector` + `read-selection`/`read-projection`, all disabled. Step 6 cross-references `CMD.ANCHOR.WORKFLOW`, whose body routed to 5 archived skills.

### 3. CMD.ANCHOR.WORKFLOW audit → rewrite

**Found stale**: 5 of 7 anchored skills archived (compose-web, report-outcomes, read-maxims-protocols, acquire-assets, declare-grounded-entity); the unconditional patlib query targeted disabled MCP. Only use-playwright-core + knowledge-ruby remained live.

**Rewritten** (imperative register per communication rules):
- `.opencode/commands/anchor-workflow.md` — 22 → 14 lines; 7 steps over the 17 live skills; `semantic_search` (mcp-semantic) replaces patlib MCP; `RUL.CAPTCHA.GATE` retained
- `.opencode/commands/yamls/anchor-workflow.yaml` — description/tags/related updated; `modified` stamped

### 4. Live-skill verification (17)

All 17 live skills audited against the stale policy — referenced files, commands, MCP servers, knowledge paths checked. All live. Remaining live set:

knowledge-ruby, manage-bash-flows, reason-invariants, reason-quantitative, reason-verbal, refactor-skill, structure-stdout, study-foundations, survey-scripts, use-context-seven, use-exa, use-parallel-search, use-playwright-ai-mode, use-playwright-core, use-playwright-debug, use-playwright-network-storage, use-playwright-vision

## Decisions

- Stale policy extended to commands: a command that anchors archived skills or disabled tools is stale → rewrite or archive
- `CMD.ANCHOR.WORKFLOW` rewritten (not archived) — its anchoring role remains valid, the anchor set changed
- knowledge-ruby kept live — its `knowledge/ruby/` path (86 files) and `CMD.ANCHOR.WORKFLOW` reference resolve to live files

## Errors found / fixed

- guide-reasoning missed by the first stale scan — the scan matched disabled tool *names*; guide-reasoning routed indirectly via `RUL.QUERY.PATLIB.CONTEXT`. Lesson: check rule-routed tool paths, not just literal tool names
- `CMD.ANCHOR.WORKFLOW` body names archived skills with no direct tool-name match — command-level staleness requires reference-chain audit

## Open edges

- DB: 66 skill rows vs 17 live dirs — 49 orphan rows + 4 live skills missing rows (manage-bash-flows, reason-invariants, structure-stdout, survey-scripts). Sync lib disabled → `r6-patlib-sync.rb` (sqlite3 gem) or direct pass
- `skills.related` DB column stale (source field removed)
- `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — rule-level rewrite candidate
- `_disabled/audit-skills.ts` updated for nexus; server not reactivated
- Body standardization pending for 17 live skills (phase 2): tables → code blocks (knowledge-ruby, use-playwright-*), gotcha pairing, `##` headers

## Logs

- `task-stdout/20260802-115343-skills-metadata-survey.log`
- `task-stdout/20260802-115650-skills-metadata-migrate.log`
- `task-stdout/20260802-skills-metadata-verify.log` (verify pass)

## Todo state

Metadata: complete. Stale archive: complete (26 archived, 17 live). Anchor rewrite: complete. Body phase 2: pending. DB reconciliation: open.
