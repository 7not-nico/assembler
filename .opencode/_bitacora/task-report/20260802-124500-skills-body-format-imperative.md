# 20260802-124500 — Skills body format: canonical body set + imperative register

## What was done

### 1. Canonical body section set decided (user directive)

Skills carry **Trigger, Procedure, Gotchas** only. **Rules and See also sections dropped** from the canonical format.

**Template** (`.opencode/skills/.template/SKILL.md`) — updated to three body sections with imperative/affirmative prose guidance. Frontmatter unchanged: `name`, `description`, `state-profile`, `nexus` (optional).

**refactor-skill** — rewritten to the canonical body:
- Procedure: 11 steps (read template, align frontmatter, three body sections, imperative procedures, gotcha pairing, no hardcoded paths, ≤500 lines/5,000 tokens)
- Gotchas: 9 entries, including "Rules or See also sections in skill body" → redirect, stale frontmatter fields, missing state-profile
- Rules section removed — constraints folded into Gotchas as positive redirects

### 2. Rules sections stripped from 4 live skills (content folded into Gotchas)

| Skill | Rules → Gotchas |
|-------|-----------------|
| reason-quantitative | 4 → 4 (encoding-before-solving, 2+ quantities, no orphan quantities, precision reporting) |
| reason-verbal | 4 → 4 (fixed step order, inference anchoring, vocabulary check, conclusion format) |
| study-foundations | 4 → 3 (pipeline order, logged anchors, aggregate quality dimension) |
| survey-scripts | 7 → 6 (script count, sNN prefix, read-only output, pure-lambda-first, stdlib-only, overlap check) |

### 3. Disabled audit tool aligned

`_disabled/audit-skills.ts` SECTION_REQUIREMENTS — `full` type changed from `["Trigger", "Procedure", "Gotchas", "Rules"]` to `["Trigger", "Procedure", "Gotchas"]`.

### 4. Imperative register verified + one fix

Audited all 17 live skills:
- **9 procedural skills**: all steps lead with imperatives (manage-bash-flows, reason-invariants, reason-quantitative, reason-verbal, refactor-skill, structure-stdout, study-foundations, survey-scripts, knowledge-ruby)
- **8 reference skills**: no Procedure section by design (stateless reference class — tool tables + gotchas)
- **knowledge-ruby step 0 fixed**: "When asked about Ruby, read..." → "Read the relevant atomic file from `knowledge/ruby/` — when asked about Ruby, match the topic to its file"

### 5. Verification — PASS

All 17 live skills: `Rules=0 SeeAlso=0 ##=0` — zero Rules sections, zero See also sections, zero `##` headers. Imperative register 17/17.

## Decisions

- Body sections: Trigger, Procedure, Gotchas only — Rules/See also excluded (user directive)
- Rules content folds into Gotchas as antipattern → positive redirect pairs, preserving the constraints
- Reference skills (stateless class) exempt from imperative register — no procedural steps to command
- `.template/SKILL.md` is the single source for canonical body structure; refactor-skill points to it

## Open edges

- Gotchas positive-redirect pairing audit pending (survey-scripts retains 2 non-paired gotchas)
- Tables → code blocks conversion pending (knowledge-ruby, use-playwright-* carry markdown tables)
- DB: 66 skill rows vs 17 live dirs — 49 orphan rows + 4 live skills missing rows (manage-bash-flows, reason-invariants, structure-stdout, survey-scripts); sync lib disabled
- `skills.related` DB column stale (source field removed)
- `RUL.QUERY.PATLIB.CONTEXT` + `RUL.USE.LOCAL.MCP.SERVERS` rules reference disabled mcp-patlib — rule-level rewrite candidate
- `_disabled/audit-skills.ts` updated but server not reactivated
- survey-scripts references Ruby (`r*-*.rb`, `_rb/`) — stale-language item per bash-first direction

## Logs

- `task-stdout/20260802-115343-skills-metadata-survey.log`
- `task-stdout/20260802-115650-skills-metadata-migrate.log`

## Todo state

Metadata: complete. Stale archive: complete (26 archived, 17 live). Anchor rewrite: complete. Body canonical set: complete (17/17 verified). Remaining: gotcha pairing, tables conversion, DB reconciliation, rule cleanup.
