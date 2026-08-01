---
name: audit-term
description: Audit all .opencode/terms/ files for structural and semantic compliance
state-profile: stateful-auditor
related: [PAT.AUDIT.PROCEDURE, TERM.TERM, TERM.TERM.NAMING.CONVENTION, PAT.DRY]
---
**Trigger** — any edit or creation of files under `.opencode/terms/`

**Procedure**

When auditing terms:

1. Read every `TERM.*.md` file under `.opencode/terms/`
2. Check frontmatter — must have all 5 fields: `id`, `title`, `source`, `tags`, `reference`
3. Check body format — must start with `**{Name}** —` (bold term name, space, em-dash)
4. Check body content — terms must describe current state only and contain no examples. Flag historical references, past names, renaming history, examples that illustrate rather than define, or state that no longer applies.
5. Check tags — minimum 3 entries
6. Check references — minimum 3 entries, each must have `title` + `url`
7. Resolve `related` entries — run `read-projection` for each, flag unresolvable IDs
8. Resolve cross-file duplicate IDs — flag if two files share the same `id`
9. Report per term — list each violation with `file:line`
10. Summarize — pass/fail count and compliance score

**Gotchas**

- A term without `reference` entries is useless — the term's purpose is to link to authoritative sources
- `reference` entries missing `title` create link-only references that provide no user context — flag them
- `source` must match the project or organization name — not freeform
- Body text starting with `**{Name}** —` is required — terms without bold+em-dash are malformed
- Historical context and renaming history belong in a changelog or migration note, not in the term definition
- Examples illustrate; terms define. An example belongs in a pattern, tutorial, or reference note — not in the term body

**Rules**

- Frontmatter requires all 5 fields: id, title, source, tags, reference
- Body must start with `**{Name}** —` (bold, space, em-dash)
- Body must describe current state only with no examples — no historical context, past names, illustrations, or renaming history
- Tags must have 3 or more entries
- Reference must have 3 or more entries, each with `title` and `url`
- No two terms may share the same `id`
- Report format: per-term violations with `file:line`, then pass/fail count
