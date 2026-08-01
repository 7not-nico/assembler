**Audit Terms** — automated compliance checking for the AMANDA term system. The `audit-term` skill scans all `.md` files in `.opencode/terms/` for backmatter YAML presence, required fields (id, title, source, tags, reference), body format (`**{Name}** —`), tag and reference minimums (3+), cross-reference resolution via patlib.db, duplicate ID detection, and file-naming convention (`{id}.md`). Part of the audit family alongside `audit-pattern`, `audit-rule`, `audit-skill`, `audit-tool`, `audit-investigation`, and `audit-abstraction`.

---
id: TERM.AUDIT.TERMS
title: Audit Terms
source: CON.TOOLCLASS.AUTOMATON
tags: [audit, terms, compliance, convention, enforcement, stateful-auditor]
related: []
reference:
  - title: audit-term — Skill Definition
    url: https://opencode.ai/docs
  - title: audit-rules — Rules Audit Term
    url: https://opencode.ai/docs
  - title: audit-tool — Tool Audit Term
    url: https://opencode.ai/docs
  - title: SPEC.ENTITY.ROUTING.TABLE — ID Prefix Convention
    url: https://opencode.ai/docs
  - title: TERM.TERM.NAMING.CONVENTION — Term ID Naming
    url: https://opencode.ai/docs
---