**Audit Tools** — automated compliance checking for the AMANDA tool architecture. The `audit-tool` skill scans all `.opencode/tools/` directories (root + 13 subprojects) for structural and semantic violations: Custom IPC Tool pattern, read/write separation, `crashOnError()` presence, import DAG, path prefixes, arg descriptions, and console.log usage. Part of the audit family alongside `audit-pattern`, `audit-term`, `audit-skill`, and `audit-investigation`.

---
id: TERM.AUDIT.TOOLS
title: Audit Tools
source: CON.TOOLCLASS.AUTOMATON
tags: [audit, tools, compliance, convention, enforcement, stateful-auditor]
related: []
reference:
  - title: PROT.TOOL.DEFINITION — Custom IPC Tool Protocol
    url: https://opencode.ai/docs
  - title: MAX.CODE.ORTHOGONALITY.PRINCIPLE — Read/Write Separation
    url: https://opencode.ai/docs
  - title: REF.LIB.DIRECTORY.LAYER — _lib/ vs lib/ Convention
    url: https://opencode.ai/docs
  - title: audit-tool — Skill Definition
    url: https://opencode.ai/docs
  - title: audit-pattern — Pattern Audit Skill
    url: https://opencode.ai/docs
---