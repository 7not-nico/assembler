---
name: audit-skill
description: Audit all `.opencode/skills/` files for compliance with skill formatting guidelines
state-profile: stateful-auditor
related: [PAT.AUDIT.PROCEDURE, TERM.SKILL, TERM.SKILL.NAMING.CONVENTION, TERM.SKILL.STATECLASS, PAT.SKILL.STATECLASS]
---
**Trigger** — any edit or creation of files under `.opencode/skills/`

**Procedure**

When auditing skills:

1. Read every `SKILL.md` under `.opencode/skills/*/`
2. Check frontmatter — must have `name` (one word, hyphenated), `description` (one sentence, present tense), and `state-profile` (one of: `stateless`, `stateful-reader`, `stateful-writer`, `stateful-auditor`, `hybrid`)
2a. Cross-reference declared `state-profile` against the skill body — a `stateless` skill should not contain DB or file I/O operations; a `stateful-auditor` must read and validate but never write; a `hybrid` must write and validate
3. Check body structure — no prose paragraphs, no examples, bold section headers only
4. Check content rules — no "never add comments" lines, no template blocks
5. Report per-skill — list each violation with `file:line`
6. Summarize — pass/fail count and compliance score

**Gotchas**

- A line saying "never add comments" or "no examples" is itself a violation — the presence of such a line violates the rule it tries to enforce
- `##` headers are violations — use `**bold**` section headers only
- Voice instructions don't belong in skills — the agent already knows the voice from rules
- Em-dash elaboration is allowed in section headers but not in body text

**Rules**

- Frontmatter is `name` + `description` + `state-profile` — no other fields
- `state-profile` must be one of five allowed values: `stateless`, `stateful-reader`, `stateful-writer`, `stateful-auditor`, `hybrid`
- Body uses bold section headers — not `##` or plain text
- Body is bullet lists or single directive lines — no prose paragraphs
- Report format: per-skill violations with `file:line`, then pass/fail count
