---
name: propose-rule
description: Use this skill when the user discusses a workflow principle absent from patlib — it detects the absence and proposes creating a rule for it
state-profile: hybrid
type: procedure
related: [SKL.VET.PROPOSAL, SKL.AUDIT.RULE]
terms: [IDENTITY.RULE]
patterns: [NEX.META.PROPOSAL, MAX.DRY]
---

**Procedure**

When detecting a rule:

1. Infer ID from discussion, then check via `read-selection --type rules` — skip if exact or semantic match exists
2. Search via `read-selection --type patterns` — find relevant patterns to populate `patterns:` field
3. Search via `read-selection --type terms` — find relevant terms to populate `related:` field
4. Search via `read-selection --type skills` — find relevant skills to populate `related:` field
5. When missing — propose creation to the user, include related patterns, terms, and skills found
6. On confirmation — write `.opencode/rules/yamls/{name}.yaml` with id, title, source, tags, group, patterns, related
7. Write `.opencode/rules/{name}.md` with bold title + em-dash description
8. Run `write-sync rules`
9. Report the rule ID

**Gotchas**

**Pre-flight**
- Check `read-selection` before proposing — duplicates violate DRY
- ID must match `RUL.{UPPERCASE.SEGMENTS}` format
- Minimum 3 tags, source `assembler`

**File format**
- `.md` files: short (1-5 lines), bold title `—` description. Frontmatter excluded
- `.yaml` files use inline array tags — `tags: [tag1, tag2, tag3]`
- `.yaml` fields: id, title, source, tags, group, patterns, related

**Post-creation**
- Both files required — YAML authoritative for queries, `.md` loads as instruction
- After writing — run `write-sync rules` to register in queries

**Rules**

**Rule structure**
- ID: `RUL.{UPPERCASE.SEGMENTS}`
- Title: non-empty, matches `.md` bold line
- Source: `assembler` for first-party rules
- Tags: 3+ entries, inline array

**Files and references**
- Two files required: `.yaml` and `.md` — both present
- `patterns:` field — pattern IDs
- `related:` field — term and skill IDs
- Related entries resolve via `read-projection`
