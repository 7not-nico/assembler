# 20260802-201500 — Dispatcher expansion: semantic-dispatcher + search-dispatcher

## What was done

### 1. `semantic-dispatcher` created

Dispatcher for the semantic MCP (mcp-semantic), mirroring the playwright-dispatcher pattern.

- **SKILL.md** — `name: semantic-dispatcher`, `state-profile: stateless`, `nexus: NEX.TOOL.CHOICE`; Trigger/Procedure/Gotchas; `PROT.SEMANTIC.WORKFLOW` governs
- **ref/ ×6** — search, stats, drift, embed, purge, eval (Route/Target/Notes, imperative style)
- **skill/ ×6** — use-semantic-search, use-semantic-stats, use-semantic-drift, use-semantic-embed, use-semantic-purge, use-semantic-eval (canonical: frontmatter, Tools code block, Gotchas)

### 2. `search-dispatcher` created

Combined dispatcher for Exa + Parallel Search MCPs.

- **SKILL.md** — `name: search-dispatcher`, `state-profile: stateless`, `nexus: NEX.INVESTIGATION.STAGE`; Trigger/Procedure/Gotchas
- **ref/ ×2** — exa, parallel (Route/Target/Notes, imperative style)
- **skill/ ×2** — use-exa, use-parallel-search — **moved from top-level** and expanded with Tools code blocks (web_search_exa/web_fetch_exa; web_search/web_fetch); old top-level dirs removed

### 3. Wired in

- CMD.ANCHOR.WORKFLOW: step 1 → semantic-dispatcher; step 2 → search-dispatcher (replacing direct semantic_search / use-exa / use-parallel-search references)
- YAML registry: description + modified stamps updated (19:00, 19:30)

### 4. Verification — PASS

- Structural sweep **27/27 SKILL.md files OK** — frontmatter fields, nexus present, zero tables, even fence parity, no Rules/See-also/`##`
- Ref files table-free (search + semantic)
- **DB reconciled:** 8 inserted (SKL.SEARCH.DISPATCHER, SKL.SEMANTIC.DISPATCHER, 6 × SKL.USE.SEMANTIC.*) → **27 rows = 27 live**, 0 missing, 0 orphans
- **Vector reconciled:** embed 27, purge 0 stale, drift → **DB 27, VEC 27, MISS 0, STALE 0**

## Decisions

- Both dispatchers follow the playwright-dispatcher template (`.template/dispatcher/SKILL.md` + `ref/mode.md`) codified earlier
- Existing use-exa/use-parallel-search moved (not duplicated) — one home per skill per RUL.CODE.SHARED.CODE
- Nested skills carry the domain-appropriate nexus: NEX.TOOL.CHOICE (semantic), NEX.INVESTIGATION.STAGE (search)
- Ref notes use imperative register throughout — verb-leading, affirmative, no negation framing

## Open edges

- `skills.related` DB column stale — drop or keep empty
- `_disabled/audit-skills.ts` updated for nexus + section requirements but server not reactivated
- `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — rule-level rewrite candidate
- survey-scripts references Ruby (`r*-*.rb`, `_rb/`) — stale-language candidate per bash-first direction

## Logs

- `task-stdout/20260802-{time}-skills-db-reconcile-2.log` — reconcile apply (8 inserted, 0 purged, exit 0)

## Todo state

Format standardization: complete (27/27). Dispatcher expansion: complete (semantic + search). DB + vector: 27=27 clean. Remaining: related-column decision, audit-skills reactivation, rule cleanup, survey-scripts language.
