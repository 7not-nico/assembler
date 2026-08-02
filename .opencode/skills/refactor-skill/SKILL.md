---
name: refactor-skill
description: Use this skill when refactoring skill files — it rewrites .opencode/skills/ files to follow the canonical skill format
state-profile: hybrid
nexus: NEX.TOOL.SEQUENCE
---
**Trigger**

Use this skill when a SKILL.md under `.opencode/skills/` deviates from the canonical format — structural mismatch, stale frontmatter, or missing sections.

**Procedure**

When refactoring a skill:

1. Read the current SKILL.md
2. Read `.opencode/skills/.template/SKILL.md` — the canonical format; align structure to it
3. Check against each criterion in `references/agentskills-criteria.md`
4. Align frontmatter to `name` + `description` + `state-profile` + `nexus` (optional, one NEX.* ID)
5. Ensure `state-profile` holds one of five values (see `PROT.SKILL.PROFILE`); add `nexus` when the skill composes a nexus entity
6. Keep body sections to Trigger, Procedure, Gotchas — bold headers only
7. Write Procedure as numbered imperative steps — "how to approach" phrasing
8. Write Gotchas as antipattern → positive redirect pairs, 3+ entries
9. Remove hardcoded absolute paths — use runtime queries or relative paths
10. Remove voice or tone instructions — agent voice comes from rules
11. Final check — under 500 lines / 5,000 tokens

**Gotchas**

- `##` headers in skill body — skills use **bold** section headers. Markdown `##` breaks visual consistency
- Rules or See also sections in skill body — skills carry Trigger, Procedure, Gotchas only. Format constraints belong in rules, references in the `nexus` field
- Voice or tone instructions in skill body — agent voice comes from rules. Skills write procedural steps and gotchas without voice guidelines
- Hardcoded absolute paths in skill body — skills use runtime queries or relative paths. Mark paths for skill.db resolution
- Examples or templates in skill body — skills define procedures and gotchas. Examples belong in commands, templates in tool descriptions
- Inline instructions about comment or coding style in skill body — skills define workflow. Style conventions belong in rules
- Missing `state-profile` — add one of stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid per PROT.SKILL.PROFILE
- Stale frontmatter fields (`type`, `related`, `patterns`, `terms`) — drop them; canonical set is name, description, state-profile, nexus
- Skill body exceeds 500 lines / 5,000 tokens — move detail to `references/` files, tell the agent when to load each
