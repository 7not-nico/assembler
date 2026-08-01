**Skill State Classification** — taxonomy of skills by their interaction with persistent state. Five categories determine testing strategy, isolation guarantees, and dependency management. Stateless skills need no DB mocking. Stateful-auditors read and validate but never write. Hybrids validate before writing.

**Stateless** — no reads, no writes, no validation of persistent state. Pure decision or formatting guidance that operates entirely within the conversation.

**Stateful-Reader** — reads persistent state, reports result, never writes or validates.

**Stateful-Writer** — generates new state (files, DB records) without validating existing state. Assumes input correctness from prior steps or user.

**Stateful-Auditor** — reads and validates existing state against criteria, never writes. Reports violations with file:line references.

**Hybrid** — reads existing state, validates against criteria, then writes new or changed state if validation passes. Create-or-audit pattern — never writes without validation.

---
id: TERM.SKILL.STATECLASS
title: Skill State Classification
source: assembler
tags: skill,state,classification,taxonomy
related: PAT.SKILL.STATECLASS
reference:
  - title: PAT.SKILL.STATECLASS — Skill State Classification Pattern
    url: https://opencode.ai/docs
  - title: audit-skill — State Profile Compliance Check
    url: https://opencode.ai/docs
  - title: guide-architecture — Layer Decision Tree
    url: https://opencode.ai/docs
---
