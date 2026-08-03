# 20260802-131500 — Skills template updates for dispatcher pattern

## What was done

### 1. Template tree expanded (`.opencode/skills/.template/`)

| File | Content |
|------|---------|
| `SKILL.md` | Canonical single-skill template — comment block now notes the dispatcher + ref-file variants |
| `dispatcher/SKILL.md` | Dispatcher canonical format — Trigger (routes by mode), Procedure (match mode → read ref → load nested skill → follow workflow), Gotchas (3 pairs) |
| `dispatcher/ref/mode.md` | Ref-file template with both observed shapes — mode refs (Route/Target/Notes) and language refs (Role/Ring/Style/Naming/Home/Knowledge/Select/Escalate) |

### 2. PROT.SKILL.SCHEMA dispatcher-aware

- **Rule 9** — dispatcher skills (`{domain}-dispatcher`) add `ref/{mode}.md` route files and nested `skill/{aspect}/SKILL.md` canonical skills per `.template/dispatcher/SKILL.md`
- **Rule 10** — each `SKILL.md` produces one skills table entry — one per top-level skill plus one per nested dispatcher skill
- **New gotcha** — "Dispatcher skill without ref files or nested skills" → model on `.template/dispatcher/SKILL.md`

### 3. refactor-skill updated

Procedure step 2 now reads: dispatcher skills use `.template/dispatcher/SKILL.md` + `.template/dispatcher/ref/{mode}.md` alongside the canonical `.template/SKILL.md`.

## Decisions

- Two ref-file shapes coexist intentionally — mode refs route to tool skills; language refs carry role/ring/style conventions. The template documents both rather than forcing one shape
- Dispatcher pattern follows the user's restructure (playwright-dispatcher, knowledge-languages) — the schema now codifies what exists rather than inventing a new pattern
- Nested skills register as their own patlib entries (Rule 10) — write-sync treats each SKILL.md as one skill

## Open edges

- YAML registry `.opencode/commands/yamls/anchor-workflow.yaml` description still says "Ruby reference" — should reference the language dispatcher; `modified` stamp pending
- DB: 66 patlib skill rows vs live set (14 top-level dirs + 5 nested skills) — old knowledge-ruby + five removed use-playwright-* rows orphaned; bitacora-workflow, knowledge-languages, playwright-dispatcher missing rows
- `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib
- `_disabled/audit-skills.ts` updated for nexus + dispatcher sections but server not reactivated

## Todo state

Body canonical set: complete. Tables → code blocks: complete. Restructure alignment: complete (19/19 SKILL.md files OK). Template updates: complete. Remaining: bitacora report, YAML registry, DB reconciliation, rule cleanup, final audit.
