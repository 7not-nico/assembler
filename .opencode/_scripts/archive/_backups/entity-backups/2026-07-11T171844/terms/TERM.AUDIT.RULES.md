**Audit Rules** — automated compliance checking for the AMANDA rule system. The `audit-rule` skill scans all `.yaml` files in `.opencode/rules/yamls/` for required fields, ID format (`RUL.*`), tag minimums, cross-reference resolution, and orphan detection against `.opencode/rules/`. Part of the audit family alongside `audit-pattern`, `audit-term`, `audit-skill`, `audit-tool`, and `audit-investigation`.

---
id: TERM.AUDIT.RULES
title: Audit Rules
source: assembler
tags: [audit, rules, compliance, convention, enforcement, stateful-auditor]
terms: [TERM.AUDIT.TOOLS]
patterns: [PAT.ENTITY-TYPE-ROUTING]
related: []
reference:
  - title: audit-rule — Skill Definition
    url: https://opencode.ai/docs
  - title: PAT.ENTITY-TYPE-ROUTING — ID Prefix Convention
    url: https://opencode.ai/docs
  - title: audit-pattern — Pattern Audit Skill
    url: https://opencode.ai/docs
  - title: audit-tool — Tool Audit Skill
    url: https://opencode.ai/docs
  - title: rules/pattern-vs-term.md — Pattern vs Term Heuristic
    url: https://opencode.ai/docs
---