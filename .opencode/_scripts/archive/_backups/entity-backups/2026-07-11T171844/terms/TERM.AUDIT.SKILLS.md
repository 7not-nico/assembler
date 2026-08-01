**Audit Skills** — automated compliance checking for the AMANDA skill system. The `audit-skills` tool scans all `SKILL.md` files under `.opencode/skills/*/` for frontmatter presence (name, description, state-profile), state-profile validity (one of five values: stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid), naming convention (verb-domain), directory-name agreement, required body sections (**Trigger**, **Procedure**, **Gotchas**, **Rules**), header format (**bold** not `##`), and duplicate name detection. Part of the audit family alongside `audit-rule`, `audit-term`, `audit-pattern`, `audit-tool`, and `audit-investigation`.

---
id: TERM.AUDIT.SKILLS
title: Audit Skills
source: assembler
tags: [audit, skills, compliance, convention, enforcement, stateful-auditor]
terms: [TERM.AUDIT.RULES, TERM.AUDIT.TERMS]
patterns: [PAT.ENTITY-TYPE-ROUTING]
related: []
reference:
  - title: audit-skills — Tool Definition
    url: https://opencode.ai/docs
  - title: audit-rules — Rules Audit Term
    url: https://opencode.ai/docs
  - title: audit-term — Terms Audit Term
    url: https://opencode.ai/docs
  - title: PAT.SKILL.STATECLASS — Skill State-Profile Convention
    url: https://opencode.ai/docs
  - title: TERM.SKILL — Skill Definition
    url: https://opencode.ai/docs
---