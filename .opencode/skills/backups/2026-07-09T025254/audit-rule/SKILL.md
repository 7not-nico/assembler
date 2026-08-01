---
name: audit-rule
description: Audit all .opencode/rules/yamls/ YAML files for structural and semantic compliance
state-profile: stateful-auditor
related: [PAT.AUDIT.PROCEDURE, RUL.ACRONYMIC.ANAPHORA]
---
**Trigger** — any edit or creation of files under `.opencode/rules/yamls/` or `.opencode/rules/`

**Procedure**

When auditing rules:

1. **Inventory** — locate every `.yaml` file under `.opencode/rules/yamls/`
2. **Required fields** — every YAML file must have `id`, `title`, `source`, `tags`, `group`. Missing fields flagged per file
3. **ID format** — must match `RUL.{UPPERCASE.SEGMENTS}` (e.g. `RUL.ACRONYMIC.ANAPHORA`). Flag malformed IDs
4. **Title** — must be non-empty. Should match the corresponding `rules/{name}.md` first bold line
5. **Source** — must be `assembler` for all first-party rules
6. **Tags** — minimum 3 entries, YAML inline array format (`[tag1, tag2, tag3]`). Flag comma-joined strings or missing tags
7. **Group** — must be one of `writing | philosophy | workflow | system`. Flag missing or invalid group values
8. **Related** — if present, run `read-projection` for each entry. Flag unresolvable IDs
9. **Cross-reference** — every `rules/yamls/{name}.yaml` must have a corresponding `rules/{name}.md`. Flag orphans
10. **Orphan .md detection** — locate every `.md` under `rules/` that lacks a corresponding `.yaml` in `rules/yamls/`. Flag orphans
11. **No duplicate IDs** — flag if two `.yaml` files share the same `id`
12. Report per rule — list each violation with `file:line`
13. Summarize — pass/fail count and compliance score

**Gotchas**

- `rules/yamls/*.yaml` is the authoritive patlib source — `rules/*.md` are the instruction-loading copies. A rule may exist in patlib without a corresponding instruction file, but an instruction file without a rule YAML means it's invisible to query tools
- Tags in YAML files use inline array (`[tag1, tag2]`) — the `normalizeArray` function handles both formats but the convention is inline array
- The `related` field is optional — missing `related` is valid, empty `related: []` is also valid. Do not flag either
- `source` for external rules (future) may differ — only flag `non-assembler` for first-party files
- `group` is required — unlike `related`, a missing `group` is always a violation
- The trigger covers both `rules/` and `rules/yamls/` — step 9 audits the `.md` side that the trigger promises but the original procedure skipped

**Rules**

- Every `rules/yamls/*.yaml` must have: id, title, source, tags, group
- ID must match `RUL.{UPPERCASE.SEGMENTS}` format
- Tags must have 3+ entries in inline array format
- `group` must be one of: `writing`, `philosophy`, `workflow`, `system`
- Every `rules/yamls/{name}.yaml` must have a corresponding `rules/{name}.md`
- Every `rules/{name}.md` must have a corresponding `rules/yamls/{name}.yaml`
- No duplicate IDs across `rules/yamls/`
- Related entries must resolve via `read-projection`
- Report format: per-rule violations with `file:line`, then pass/fail count
