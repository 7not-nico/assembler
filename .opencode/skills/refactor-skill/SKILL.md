---
name: refactor-skill
description: Use this skill when refactoring skill files — it rewrites .opencode/skills/ files to follow agentskills.io best practices
state-profile: hybrid
related: []
patterns: ["PROT.SKILL.STATECLASS"]
---
**Procedure**

When refactoring a skill:

1. Read the current SKILL.md
2. Read `references/agentskills-criteria.md` for the full criteria list
3. Check against each criterion
4. Add trigger section — explicit, prominent, at top
5. Convert declarations to procedures — "how to approach" instructions. "what it is" declarations excluded
6. Add gotchas — at least 3 entries, each paired with positive redirect
7. Add rules — hard constraints, minimum 3 rules
8. Remove hardcoded paths — mark for skill.db
9. Ensure `state-profile` field in frontmatter with one of five allowed values (see `PROT.SKILL.STATECLASS`)
10. Remove voice section — agent knows voice from rules
11. Final check — under 500 lines / 5,000 tokens

**Gotchas**

- `##` headers in skill body — skills use `**bold`** section headers. Markdown `##` breaks visual consistency
- Voice or tone instructions in skill body — agent voice comes from rules. Skills write procedural steps and gotchas without voice guidelines
- Hardcoded absolute paths in skill body — skills use runtime queries or relative paths. Mark paths for skill.db resolution
- Examples or templates in skill body — skills define procedures and rules. Examples belong in commands, templates in tool descriptions
- Inline instructions about comment or coding style in skill body — skills define workflow. Style conventions belong in rules

**Rules**

- Frontmatter: 3 fields maximum (name, description, state-profile)
- Body sections: 4 sections, bold headers (Trigger, Procedure, Gotchas, Rules)
- Trigger: 1-3 sentences, top of body, describes auto-load condition
- Procedure: 3+ numbered steps, "how to approach" phrasing
- Gotchas: 3+ entries, each entry pairs antipattern with positive redirect
- Rules: 3+ rules in hard-constraint format
- Final skill: ≤500 lines, ≤5,000 tokens
