---
name: propose-command
description: Use this skill when the user discusses a command not yet in .opencode/commands/ — it detects the absence and proposes creating it with full verb-domain convention compliance
state-profile: hybrid
type: procedure
related: [SKL.FORMAT.COMMAND, SKL.AUDIT.COMMAND]
terms: [TERM.OPENCODE.COMMANDS]
patterns: [MAX.ORTHOGONALITY, MAX.DRY]
---

**Procedure** — When proposing a command:

1. Infer verb and domain from discussion. Follow **verb-domain** naming:
   - ID: `CMD.{VERB}.{DOMAIN}` — uppercase dot-separated segments
   - Filename: `{verb}-{domain}.md`
   - `x`/`z` prefixes stay concatenated (e.g., `xrequire`, `zconvert`)
   - Collapse repeated segments into acronyms (e.g., `COMMAND` → `CMD`)

2. Check via glob `.opencode/commands/{verb}-{domain}.md` — skip if file exists

3. Check via `read-selection --type commands` — skip if ID exists in patlib

4. Search `read-selection --type terms --query command` — find relevant terms to populate `related:` (e.g., `TERM.OPENCODE.COMMANDS`)
5. Search `read-selection --type patterns --query command` — find relevant patterns to populate `related:`
6. Search `read-selection --type rules --query command` — find relevant rules to populate `related:`
7. Search `read-selection --type skills --query command` — find relevant skills to populate `related:`

8. When missing — propose creation to user, include:
   - Proposed `{verb}-{domain}.md` following `SKL.FORMAT.COMMAND` structure
   - Proposed `yamls/{verb}-{domain}.yaml` with `id`, `title`, `description`, `source`, `tags`, `related`

6. On confirmation — write `.opencode/commands/{verb}-{domain}.md`
7. Write `.opencode/commands/yamls/{verb}-{domain}.yaml`
8. Run `write-sync commands`
9. Report the command ID

**Gotchas** — - Always check file + patlib before proposing — duplicates violate DRY
- ID must be `CMD.{VERB}.{DOMAIN}` — verb comes first per convention
- Filename: `{verb}-{domain}.md` — old reverse order excluded
- Source must be `assembler`
- Minimum 3 tags
- `.md` follows `SKL.FORMAT.COMMAND`: frontmatter with `description:` + `subtask: true`, numbered steps, `$ARGUMENTS`
- After writing — run `write-sync commands` to register the command in queries
- If the command needs a new `--type commands` branch in tools, flag that as follow-up work

**Rules** — - ID must match `CMD.{VERB}.{DOMAIN}`
- Filename must match `{verb}-{domain}.md`
- Source must be `assembler`
- YAML fields: id, title, description, source, tags, related
- Tags must have 3+ entries in inline array
- Every command needs both `.md` and `.yaml` files
- Related entries (if present) must resolve via `read-projection`
- `related:` contains entity IDs for related terms, patterns, rules, and skills
