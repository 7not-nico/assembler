**Skill State Classification** — taxonomy of skills by their interaction with persistent state. Five categories determine testing strategy, isolation guarantees, and dependency management. Stateless skills require zero DB mocking. Stateful-auditors read and validate only. Hybrids validate before writing.

**Stateless** — no reads, no writes, no validation of persistent state. Pure decision or formatting guidance that operates entirely within the conversation.

**Stateful-Reader** — reads persistent state, reports result; read-only, no validation.

**Stateful-Writer** — generates new state (files, DB records) without validating existing state. Assumes input correctness from prior steps or user.

**Stateful-Auditor** — reads and validates existing state against criteria only. Reports violations with file:line references.

**Hybrid** — reads existing state, validates against criteria, then writes new or changed state only after validation passes. Create-or-audit pattern — conditional write gated on validation.

---
id: TERM.SKILL.STATECLASS
title: Skill State Classification
source: assembler
tags: skill,state,classification,taxonomy
terms: []
patterns: [PAT.SKILL.STATECLASS]
related: []
reference:
  - title: PAT.SKILL.STATECLASS — Skill State Classification Pattern
    url: https://opencode.ai/docs
  - title: audit-skill — State Profile Compliance Check
    url: https://opencode.ai/docs
  - title: guide-architecture — Layer Decision Tree
    url: https://opencode.ai/docs
---