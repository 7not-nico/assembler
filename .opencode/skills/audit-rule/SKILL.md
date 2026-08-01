---
name: audit-rule
description: Use this skill when auditing rule files — checks .opencode/rules/yamls/ YAML files and rules markdown files against IDENTITY.RULE and PROT.RULE.SCHEMA
state-profile: stateful-auditor
type: reference
related: [IDENTITY.RULE, PROT.RULE.SCHEMA, RUL.ACRONYMIC.ANAPHORA, RUL.AUTOMATE.BEFORE.FIX]
terms: [IDENTITY.RULE]
patterns: [NEX.TOOL.SEQUENCE]
---

**Procedure**

When auditing rules:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.RULE` via `read-projection`. Identity defines: group `architectonic`, ring `R0`, naming `{name}`, session-level instructions that compose with other rules. Each rule YAML has `id`, `title`, `group`, `tags`. Body instructions paired as `.md` files. Audit against these values.

2. **Inventory** — locate every `.yaml` file under `.opencode/rules/yamls/`.

3. **Required fields** — per IDENTITY.RULE: every YAML file must have `id`, `title`, `group`, `tags`. Missing fields flagged per file. The `source` field is not used in rules — flag `source` if present.

4. **ID format** — must match `RUL.{UPPERCASE.SEGMENTS}` (e.g. `RUL.ACRONYMIC.ANAPHORA`). Per IDENTITY.RULE naming. Flag malformed IDs.

5. **Title** — must be non-empty. Should match the corresponding `rules/{name}.md` first bold line.

6. **Tags** — minimum 3 entries, YAML inline array format (`[tag1, tag2, tag3]`). Flag comma-joined strings or missing tags.

7. **Group** — per IDENTITY.RULE: "compose with other rules". Group must be `assembler` for parent rules or a valid `RUL.*` entity ID for child rules. Flag missing or invalid group values.

8. **Related** — if present, run `read-projection` for each entry. Flag unresolvable IDs. Parent rules (`group: assembler`) must have `related` pointing to a `MAX.*` entity.

9. **Cross-reference** — every `rules/yamls/{name}.yaml` must have a corresponding `rules/{name}.md`. Flag orphans.

10. **Orphan .md detection** — locate every `.md` under `rules/` that lacks a corresponding `.yaml` in `rules/yamls/`. Flag orphans.

11. **No duplicate IDs** — flag if two `.yaml` files share the same `id`. Also flag if `read-selection --type rules` shows duplicate titles across different IDs.

12. **.md format compliance** — verify every `rules/{name}.md` follows `automate-before-fix` format: first line starts with instruction text (declarative or imperative per register); `Scope:` line present within first 3 lines of prose; `Composes with:` line present for chained rules. Per PROT.RULE.SCHEMA.

13. **Report per file** — list each violation with `file:line`.

14. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- `rules/yamls/*.yaml` is the authoritative patlib source — `rules/*.md` are instruction-loading copies. A rule may exist in patlib without a corresponding instruction file, but an instruction file without a rule YAML means it's invisible to query tools
- Tags in YAML files use inline array (`[tag1, tag2]`). The `normalizeArray` function handles both formats but the inline array is convention
- The `related` field is optional for child rules — missing `related` is valid, empty `related: []` is also valid. Do not flag either. But parent rules (`group: assembler`) must have `related` pointing to a `MAX.*` entity
- `source` is not used in rules — if found in a YAML, flag it for removal. Rules use `group` for parent encoding and `related` for maxim grounding
- `group` is required — unlike `related`, a missing `group` is always a violation. Valid values: `assembler` (parent) or a `RUL.*` entity ID (child)
- Per IDENTITY.RULE: rules "compose with other rules". Verify composes-with chain resolves via `related` field
- Group `architectonic` R0 — rules are session-level instructions. Distinguish from maxims (axiomatic R0, external truths) and skills (architectonic R1, procedures)

**Rules**

- Every `rules/yamls/*.yaml` must have: `id`, `title`, `group`, `tags`
- ID must match `RUL.{UPPERCASE.SEGMENTS}` format
- Tags must have 3+ entries in inline array format
- `group` must be `assembler` (parent) or a valid `RUL.*` entity ID (child)
- `source` field must not be present — flag if found
- `precedes` field must not be present — flag if found
- Parent rules (`group: assembler`) must have `related` pointing to a `MAX.*` entity
- Every `rules/yamls/{name}.yaml` must have a corresponding `rules/{name}.md`
- Every `rules/{name}.md` must have a corresponding `rules/yamls/{name}.yaml`
- No duplicate IDs across `rules/yamls/`
- No duplicate titles across `rules/yamls/` (same title, different ID)
- Every `rules/{name}.md` follows format: instruction line, Scope:, Composes with:
- Related entries must resolve via `read-projection`
- Report format: per-file violations with `file:line`, then pass/fail count
