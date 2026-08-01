---
name: audit-pattern
description: Audit all .opencode/patterns/ files for structural and semantic compliance
state-profile: stateful-auditor
related: [PAT.AUDIT.PROCEDURE, PAT.DRY]
---
**Trigger** — any edit or creation of files under `.opencode/patterns/`

**Procedure**

When auditing patterns:

1. Read every `PAT.*.md` file under `.opencode/patterns/`
2. Check frontmatter — must have all 9 fields: `id`, `title`, `source`, `summary`, `principle`, `enforcement`, `tags`, `status`, `priority`
3. Check title format — must contain em-dash `—` (`Name — Subtitle`)
4. Check enforcement — one of `Tool`, `Convention`, `Review`
5. Check status — one of `active`, `draft`, `deprecated`
6. Check priority — integer 1–5
7. Check tags — minimum 3 entries
8. Check body — must contain `## Rules`, `## Applicability`, `## See also` sections
9. Resolve `related` entries — run `read-projection` for each, flag unresolvable IDs
10. Resolve cross-file duplicate IDs — flag if two files share the same `id`
11. Report per pattern — list each violation with `file:line`
12. Summarize — pass/fail count and compliance score

**Gotchas**

- A pattern with all 9 frontmatter fields may still be semantically empty — a `principle` that says "Be good" passes structure but fails audit. Flag weak principles.
- `priority: 1` is reserved for foundational patterns only (currently only `PAT.DRY`) — flag all others
- `enforcement: Tool` requires the tool to actually exist in some project's `.opencode/tools/` — flag orphan enforcement claims
- `read-validate` parses YAML but doesn't check these semantic rules — this skill fills that gap

**Rules**

- Frontmatter requires all 9 fields: id, title, source, summary, principle, enforcement, tags, status, priority
- Title must contain em-dash `—` between name and subtitle
- Enforcement must be one of: `Tool`, `Convention`, `Review`
- Status must be one of: `active`, `draft`, `deprecated`
- Priority must be integer 1–5
- Tags must have 3 or more entries
- Body must have `## Rules`, `## Applicability`, `## See also`
- No two patterns may share the same `id`
- Report format: per-pattern violations with `file:line`, then pass/fail count
