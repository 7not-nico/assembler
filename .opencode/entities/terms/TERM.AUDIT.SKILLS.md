**Audit Skills** — automated compliance checking for the AMANDA skill system. The `audit-skills` tool scans all `SKILL.md` files under `.opencode/skills/*/` for frontmatter presence (name, description, state-profile, optional type/compatibility/metadata/allowed-tools), state-profile validity (one of five values: stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid), naming convention (verb-domain with optional digits), directory-name agreement, tiered body section enforcement (type=reference→none, type=procedure→Procedure+Gotchas, type=full→Trigger+Procedure+Gotchas+Rules, defaults to full), description length (max 1024 characters), compatibility length (max 500), header format (**bold** not `##`), and duplicate name detection. Part of the audit family alongside `audit-rule`, `audit-term`, `audit-pattern`, `audit-tool`, and `audit-investigation`.

---
id: TERM.AUDIT.SKILLS
title: Audit Skills
source: CON.TOOLCLASS.AUTOMATON
tags: [audit, skills, compliance, convention, enforcement, stateful-auditor]
related: []
reference:
  - title: audit-skills — Tool Definition
    url: https://opencode.ai/docs
  - title: audit-rules — Rules Audit Term
    url: https://opencode.ai/docs
  - title: audit-term — Terms Audit Term
    url: https://opencode.ai/docs
  - title: PROT.SKILL.PROFILE — Skill State-Profile Convention
    url: https://opencode.ai/docs
  - title: IDENTITY.SKILL — Skill Identity
    url: https://opencode.ai/docs
---