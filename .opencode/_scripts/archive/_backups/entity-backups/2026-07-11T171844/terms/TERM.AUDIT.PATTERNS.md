**Audit Patterns** — automated compliance checking for the AMANDA pattern system. The `audit-patterns` tool scans all `.md` files in `.opencode/patterns/` for frontmatter YAML presence, required fields (id, title, source, summary, principle, enforcement, tags, status, priority), title format (em-dash separator), enforcement/status/priority enums, body sections (`## Rules`, `## Applicability`, `## See also`), tag minimums (3+), see-also ID resolution via patlib.db, duplicate ID detection, file-naming convention (`{id}.md`), and priority-1 exclusivity (PAT.DRY only). Part of the audit family alongside `audit-rule`, `audit-term`, `audit-skill`, `audit-tool`, and `audit-investigation`.

---
id: TERM.AUDIT.PATTERNS
title: Audit Patterns
source: assembler
tags: [audit, patterns, compliance, convention, enforcement, stateful-auditor]
terms: [TERM.AUDIT.RULES, TERM.AUDIT.TERMS]
patterns: [PAT.ENTITY-TYPE-ROUTING]
related: []
reference:
  - title: audit-patterns — Tool Definition
    url: https://opencode.ai/docs
  - title: audit-rules — Rules Audit Term
    url: https://opencode.ai/docs
  - title: audit-term — Terms Audit Term
    url: https://opencode.ai/docs
  - title: PAT.LLM.SPECIFICATION — LLM Specification Pattern
    url: https://opencode.ai/docs
  - title: TERM.PATTERN — Pattern Definition
    url: https://opencode.ai/docs
---