---
name: refactor-skill
description: Refactor .opencode/skills/ files to follow agentskills.io best practices
state-profile: hybrid
related: [PAT.SKILL.STATECLASS]
---
**Trigger** — any edit or creation of files under `.opencode/skills/`

**Procedure**

When refactoring a skill:

1. Read the current SKILL.md
2. Read `references/agentskills-criteria.md` for the full criteria list
3. Check against each criterion
4. Add trigger section — explicit, prominent, at top
5. Convert declarations to procedures — "how to approach" not "what it is"
6. Add gotchas — non-obvious things the agent would get wrong
7. Add rules — hard constraints
8. Remove hardcoded paths — mark for skill.db
9. Ensure `state-profile` field in frontmatter with one of five allowed values (see `PAT.SKILL.STATECLASS`)
10. Remove voice section — agent knows voice from rules
11. Verify under 500 lines / 5,000 tokens

**Gotchas**

- Never use `##` headers — use `**bold**` section headers only
- Never add voice instructions — the agent already knows the voice from rules
- Never hardcode `/home/eddyr/assembler/` paths — mark for skill.db
- Never add examples or templates — keep to procedures and rules
- A line saying "never add comments" is itself a violation

**Rules**

- Frontmatter: `name` + `description` + `state-profile` only
- Body: Trigger → Procedure → Gotchas → Rules
- Trigger: explicit, at top, describes when LLM should auto-load
- Procedure: numbered steps, "how to approach" not "what to produce"
- Gotchas: non-obvious things the agent would get wrong
- Rules: hard constraints, format requirements
