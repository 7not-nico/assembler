---
name: audit-command
description: Audit all .opencode/commands/yamls/ YAML files for structural and semantic compliance with verb-domain convention
state-profile: stateful-auditor
related: [TERM.OPENCODE.COMMANDS, SKL.FORMAT.COMMAND, SKL.AUDIT.SKILL, PAT.DRY]
---

**Trigger** — any edit or creation of files under `.opencode/commands/yamls/` or `.opencode/commands/`

**Procedure** — When auditing commands:

1. **Inventory** — locate every `.yaml` file under `.opencode/commands/yamls/`

2. **Required fields** — every YAML file must have `id`, `title`, `description`, `source`, `tags`. Missing fields flagged per file

3. **ID format** — must match `CMD.{VERB}.{DOMAIN}` (uppercase dot-separated segments, verb first). Flag malformed IDs

4. **Filename-verb agreement** — the first segment of the ID (verb) must match the filename's first segment (verb). E.g., `CMD.STUB.FILE` → `stub-file.md`. Flag mismatches

5. **Title** — must be non-empty. Should match the corresponding `commands/{name}.md` frontmatter description

6. **Source** — must be `assembler`

7. **Tags** — minimum 3 entries, YAML inline array format (`[tag1, tag2, tag3]`). Flag comma-joined strings or missing tags

8. **Related** — if present, run `read-projection` for each entry. Flag unresolvable IDs

9. **Cross-reference** — every `commands/yamls/{name}.yaml` must have a corresponding `commands/{name}.md`. Flag orphans

10. **Orphan .md detection** — locate every `.md` under `commands/` that lacks a corresponding `.yaml` in `commands/yamls/`. Flag orphans

11. **No duplicate IDs** — flag if two `.yaml` files share the same `id`

12. Report per command — list each violation with `file:line`
13. Summarize — pass/fail count and compliance score

**Gotchas** — - `commands/yamls/*.yaml` is the authoritative patlib source — `commands/*.md` are the instruction-loading copies. A command may exist in patlib without a corresponding instruction file, but an instruction file without a command YAML means it's invisible to query tools
- Tags use inline array (`[tag1, tag2]`) — the `normalizeArray` function handles both formats but the convention is inline array
- The `related` field is optional — missing `related` is valid, empty `related: []` is also valid
- `source` must always be `assembler`
- Filenames that predate the verb-domain convention must be renamed — flag them, don't skip them

**Rules** — - Every `commands/yamls/*.yaml` must have: id, title, description, source, tags
- ID must match `CMD.{VERB}.{DOMAIN}` format
- Filename must match first segment of ID (verb)
- Tags must have 3+ entries in inline array format
- Every `commands/yamls/{name}.yaml` must have a corresponding `commands/{name}.md`
- Every `commands/{name}.md` must have a corresponding `commands/yamls/{name}.yaml`
- No duplicate IDs across `commands/yamls/`
- Related entries must resolve via `read-projection`
- Report format: per-command violations with `file:line`, then pass/fail count
