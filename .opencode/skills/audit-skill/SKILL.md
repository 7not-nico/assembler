---
name: audit-skill
description: Use this skill when auditing skill files — checks every .opencode/skills/ file against IDENTITY.SKILL and PROT.SKILL.SCHEMA.SCHEMA
state-profile: stateful-auditor
type: reference
related: [IDENTITY.SKILL, PROT.SKILL.SCHEMA.SCHEMA, PROT.SKILL.PROFILE]
terms: [IDENTITY.SKILL, TERM.SKILL.NAMING.CONVENTION, TERM.SKILL.STATECLASS]
patterns: [NEX.TOOL.SEQUENCE, PROT.SKILL.STATECLASS]
---

**Procedure**

When auditing skills:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.SKILL` via `read-projection`. Identity defines: group `architectonic`, ring `R1`, naming `{action}-{domain}`, procedure provider. Skills are hybrid state automata — stateless, stateful-reader, stateful-writer, stateful-auditor, or hybrid. Audit against these values.

2. **Inventory** — locate every `SKILL.md` file under `.opencode/skills/`.

3. **Frontmatter fields** — per IDENTITY.SKILL and PROT.SKILL.SCHEMA.SCHEMA: must have `name`, `description`, `state-profile`, `related`. `type` and `patterns` optional. Flag missing fields per file.

4. **Naming convention** — per IDENTITY.SKILL: "each skill in `.opencode/skills/` uses `{action}-{domain}` naming". Verify directory name matches `{action}-{domain}` pattern. Flag names without action verb or without domain.

5. **State profile** — per IDENTITY.SKILL: "hybrid state automata — stateless, stateful-reader, stateful-writer, stateful-auditor, or hybrid". Flag invalid state-profile values. Verify stateless skills have no DB/file I/O.

6. **Body structure** — per IDENTITY.SKILL: "procedure provider". Body must have `## Procedure` section with numbered steps. Flag missing or misnamed procedure section.

7. **Related entities** — run `read-projection` for each `related` entry. Flag unresolvable IDs.

8. **No duplicate names** — flag if two skill directories share the same `{action}-{domain}` name.

9. **Skill-icon pairs** — if skill has a paired illustration or icon in `nerdfont/sets/`, verify consistency.

10. **Report per file** — list each violation with `file:line`.

11. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- `stateless` skill with DB or file I/O — persistent state read/write excluded. Use `hybrid` or `stateful-reader`/`writer` instead
- `stateful-auditor` that writes state — auditors read and validate only. Write logic uses `hybrid` or `stateful-writer`
- `type=reference` with I/O or state operations — reference skills are pure lookup. Use `procedure` or `full` instead
- Line with hard stop or prohibition in skill body — presence violates the rule it enforces. Frame constraints positively
- `##` headers in body — per RUL.WRITING.CONVENTION, use `**bold**` section headers. `##` breaks visual consistency
- Voice instructions in body — agent voice from rules. Skills write procedural steps without tone guidelines
- Per IDENTITY.SKILL: `{action}-{domain}` naming. Backups or stale directories with different naming patterns exist in `backups/` — exclude from audit

**Rules**

- Frontmatter: name, description, state-profile, related; type and patterns optional
- Directory naming: `{action}-{domain}` per IDENTITY.SKILL
- State profile: one of stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid
- Body: `## Procedure` section with numbered steps
- No hard stops or prohibitions in skill body — frame positively
- Related entries resolve via `read-projection`
- No duplicate names across skill directories
- Report format: per-skill violations with `file:line`, then pass/fail count
