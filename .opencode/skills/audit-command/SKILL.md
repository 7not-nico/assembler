---
name: audit-command
description: Use this skill when auditing command YAML files — checks .opencode/commands/yamls/ against IDENTITY.COMMAND and PROT.COMMAND.RULE
state-profile: stateful-auditor
type: reference
related: [IDENTITY.COMMAND, PROT.COMMAND.RULE, SKL.FORMAT.COMMAND]
terms: [IDENTITY.COMMAND, TERM.OPENCODE.COMMANDS]
patterns: [MAX.DRY]
---

**Procedure**

When auditing commands:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.COMMAND` via `read-projection`. Identity defines: group `architectonic`, ring `R1`, naming `CMD.{VERB}.{DOMAIN}`, guided composition entity prescribing a structured workflow. Commands use verb-domain naming and numbered steps. Commands are stateless and composed at the agent level. Audit against these values.

2. **Inventory** — locate every `.yaml` file under `.opencode/commands/yamls/`.

3. **Required fields** — per IDENTITY.COMMAND and PROT.COMMAND.RULE: every YAML must have `id`, `title`, `source`, `tags`. Flag missing fields per file.

4. **ID format** — must match `CMD.{VERB}.{DOMAIN}` format per IDENTITY.COMMAND naming convention. Flag malformed IDs.

5. **Verb-domain naming** — per IDENTITY.COMMAND: "verb-domain naming". First segment after `CMD.` must be a verb (e.g., CMD.FETCH.PAPERS, CMD.SYNC.ENTITY). Flag non-verb prefixes.

6. **Source** — must always be `assembler` for first-party commands per PROT.COMMAND.RULE.

7. **Tags** — minimum 3 entries, inline array format `[tag1, tag2, tag3]` per PROT.META.IDENTITY. Flag comma-joined or missing.

8. **Cross-reference** — every `commands/yamls/{name}.yaml` must have a corresponding `commands/{name}.md`. Flag orphans.

9. **No duplicate IDs** — flag if two `.yaml` files share the same `id`.

10. **.md format compliance** — per IDENTITY.COMMAND: "uses verb-domain naming and numbered steps. The executor reads and follows the prescribed sequence." Verify `.md` body uses numbered steps.

11. **Report per file** — list each violation with `file:line`.

12. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- `commands/yamls/*.yaml` is the authoritative patlib source — `commands/*.md` are instruction-loading copies. A command may exist in patlib without a corresponding instruction file. An instruction file without a YAML is invisible to query tools
- Tags in YAML files use inline array (`[tag1, tag2]`). `normalizeArray` handles both formats; inline array is convention
- The `related` field is optional — missing `related` is valid, empty `related: []` is also valid
- `source` must always be `assembler` for first-party commands
- Filenames that predate the verb-domain convention — rename required. Flag them; skipping excluded
- Per IDENTITY.COMMAND: commands "are stateless and composed at the agent level". Distinguish from skills (stateful profiles possible) and rules (session-level)

**Rules**

- Every `commands/yamls/*.yaml` must have: `id`, `title`, `source`, `tags`
- ID must match `CMD.{VERB}.{DOMAIN}` format — verb first segment
- Source: `assembler` for first-party commands
- Tags: 3+ entries in inline array format
- Every `commands/yamls/{name}.yaml` must have a corresponding `commands/{name}.md`
- Every `commands/{name}.md` must have a corresponding `commands/yamls/{name}.yaml`
- No duplicate IDs across `commands/yamls/`
- `.md` body uses numbered steps per IDENTITY.COMMAND
- Report format: per-file violations with `file:line`, then pass/fail count
