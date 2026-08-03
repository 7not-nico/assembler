# 20260802-183000 — Skills DB + vector reconciliation

## What was done

### 1. patlib skills table reconciled (user-approved direct DB pass)

Wrote `/tmp/opencode/reconcile-skills.py` — parses every live SKILL.md (frontmatter + Trigger/Procedure/Gotchas sections), maps kebab-case names → `SKL.*` dotted IDs, computes orphan/missing sets against the DB.

| Metric | Before | After |
|--------|--------|-------|
| DB rows | 66 | 19 |
| Live skills (top-level + nested) | 19 | 19 |
| Orphans purged | — | 54 |
| Missing inserted | — | 7 |

**Purged (54):** all SKL.ACQUIRE.*, SKL.AUDIT.*, SKL.PROPOSE.*, SKL.SEARCH.*, SKL.GUIDE.*, SKL.BOOTSTRAP.DB, SKL.CATEGORIZE.PAPERS, SKL.CLASSIFY.TOOL, SKL.COMPOSE.WEB, SKL.DECLARE.GROUNDED.ENTITY, SKL.FORMAT.COMMAND, SKL.JUDGE.SEMANTIC, SKL.KNOWLEDGE.RUBY (superseded by knowledge-languages), SKL.ORCHESTRATE.RESEARCH, SKL.ORGANIZE.PAPERS, SKL.PRUNE.STALE, SKL.QUERY.NERDFONT, SKL.READ.MAXIMS.PROTOCOLS, SKL.REPORT.OUTCOMES, SKL.SCAFFOLD.TOOLS, SKL.STAGE.CREATE, SKL.USE.ENTITY.AUDIT, SKL.USE.PATLIB, SKL.USE.SPEC.AUDIT, SKL.VALIDATE.SPEC, SKL.VET.PROPOSAL.

**Inserted (7):** SKL.BITACORA.WORKFLOW (stateful-writer), SKL.KNOWLEDGE.LANGUAGES (stateless), SKL.MANAGE.BASH.FLOWS (stateful-writer), SKL.PLAYWRIGHT.DISPATCHER (stateless), SKL.REASON.INVARIANTS (hybrid), SKL.STRUCTURE.STDOUT (stateless), SKL.SURVEY.SCRIPTS (stateless).

**Verification:** `live ids 19, db ids 19, missing [], orphans []` — PASS.

### 2. Vector store reconciled

- `semantic_embed --type skills --force` → embedded 19 skills
- `semantic_drift` before purge → DB 19, VEC 73, MISS 0, STALE 54 (old orphaned embeddings survived the upsert)
- `semantic_purge --type skills` dry-run → 54 stale confirmed
- `semantic_purge --type skills --apply` → 54 purged
- `semantic_drift` after → **DB 19, VEC 19, MISS 0, STALE 0** — PASS

### 3. Bitacora

- Todo `skills-format-standardize.md`: "Final audit + write-sync + re-embed" marked `[x]`; DB open-edge marked `[x]` with reconcile details
- Command log: `task-stdout/20260802-175545-skills-db-reconcile.log` (exit 0)

## Decisions

- Direct DB pass per user choice (over restore-sync-tooling and defer) — sync lib stays disabled
- Insert fields parsed from live SKILL.md files: id (SKL.* derived from name), title (Title Case), description/state_profile from frontmatter, trigger/procedure/gotchas/body from sections
- Vector purge required a second pass — force-embed upserts current rows but does not delete stale entity embeddings

## Open edges

- `skills.related` DB column stale (canonical frontmatter dropped the source field) — drop or keep empty
- `_disabled/audit-skills.ts` updated for nexus + section requirements but server not reactivated
- `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — rule-level rewrite candidate
- survey-scripts references Ruby (`r*-*.rb`, `_rb/`) — stale-language candidate per bash-first direction

## Todo state

Metadata: complete. Stale archive: complete. Anchor rewrite: complete. Body canonical set: complete (19/19). Tables → code blocks: complete. Restructure alignment: complete. Template updates: complete. DB reconcile: complete (19=19). Vector reconcile: complete (19=19). Remaining: related-column decision, audit-skills reactivation, rule cleanup, survey-scripts language.
