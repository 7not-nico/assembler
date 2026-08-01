**Audit Rules** — automated compliance checking for the AMANDA rule system. The `audit-rule` skill scans all `.yaml` files in `.opencode/rules/yamls/` for required fields, ID format (`RUL.*`), tag minimums, cross-reference resolution, and orphan detection against `.opencode/rules/`. Part of the audit family alongside `audit-pattern`, `audit-term`, `audit-skill`, `audit-tool`, and `audit-investigation`.

---
id: TERM.AUDIT.RULES
title: Audit Rules
source: CON.TOOLCLASS.AUTOMATON
tags: [audit, rules, compliance, convention, enforcement, stateful-auditor]
related: []
reference:
  - title: audit-rule — Skill Definition
    url: https://opencode.ai/docs
  - title: SPEC.ENTITY.ROUTING.TABLE — ID Prefix Convention
    url: https://opencode.ai/docs
  - title: audit-pattern — Pattern Audit Skill
    url: https://opencode.ai/docs
  - title: audit-tool — Tool Audit Skill
    url: https://opencode.ai/docs
  - title: SPEC.ENTITY.DISTINCTION.BOUNDARY — Entity Distinction Specification
    url: https://opencode.ai/docs
---