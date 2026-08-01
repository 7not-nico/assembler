**Skills** — a derived patlib table populated from `skills/*/SKILL.md` frontmatter at sync time. Each skill row represents one skill, with columns: id (`SKL.{UPPERCASE.NAME}`), title, description, trigger, procedure, gotchas, rules, body, skill, and state_profile. No dedicated files exist — the table is populated by `write-sync --type skills`, which reads skill frontmatter and bold sections directly. Accessed via `read-selection --type skills` (horizontal selection) and `read-projection --type skills --id SKL.*` (vertical projection).

---
id: TERM.OPENCODE.THOUGHT
title: Skills
source: assembler
tags: skill,index,derived,patlib,sync,convention
terms: [TERM.HORIZONTAL.PARTITIONING,TERM.VERTICAL.PARTITIONING]
patterns: [PAT.THOUGHT,PAT.OPENCODE.THOUGHT,PAT.SKILL.STATECLASS]
related: []
reference:
  - title: PAT.THOUGHT — Derived Skill Index Pattern
    url: https://opencode.ai/docs
  - title: PAT.OPENCODE.THOUGHT — Superseded Pattern
    url: https://opencode.ai/docs
  - title: PAT.SKILL.STATECLASS — Skill State Profile Values
    url: https://opencode.ai/docs
  - title: TERM.HORIZONTAL.PARTITIONING — read-selection filtering
    url: https://opencode.ai/docs
  - title: TERM.VERTICAL.PARTITIONING — read-projection details
    url: https://opencode.ai/docs
---