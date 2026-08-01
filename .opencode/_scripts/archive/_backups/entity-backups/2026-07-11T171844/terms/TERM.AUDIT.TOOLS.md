**Audit Tools** — automated compliance checking for the AMANDA tool architecture. The `audit-tool` skill scans all `.opencode/tools/` directories (root + 13 subprojects) for structural and semantic violations: Plugin IPC pattern, read/write separation, `crashOnError()` presence, import DAG, path prefixes, arg descriptions, and console.log usage. Part of the audit family alongside `audit-pattern`, `audit-term`, `audit-skill`, and `audit-investigation`.

---
id: TERM.AUDIT.TOOLS
title: Audit Tools
source: assembler
tags: [audit, tools, compliance, convention, enforcement, stateful-auditor]
terms: []
patterns: [PAT.PLUGIN.IPC.TOOL, PAT.ORTHOGONALITY, PAT.SHARED.LIB, PAT.ANCHORED.PATHS]
related: []
reference:
  - title: PAT.PLUGIN.IPC.TOOL — Plugin IPC Tool Pattern
    url: https://opencode.ai/docs
  - title: PAT.ORTHOGONALITY — Read/Write Separation
    url: https://opencode.ai/docs
  - title: PAT.SHARED.LIB — _lib/ vs lib/ Convention
    url: https://opencode.ai/docs
  - title: audit-tool — Skill Definition
    url: https://opencode.ai/docs
  - title: audit-pattern — Pattern Audit Skill
    url: https://opencode.ai/docs
---