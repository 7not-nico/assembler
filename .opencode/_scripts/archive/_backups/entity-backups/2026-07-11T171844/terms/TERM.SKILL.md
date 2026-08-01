**Skill** — a stateful, multi-step procedure defined in `skills/*/SKILL.md`. Has a state-profile (stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid) that determines testing and isolation strategy. Frontmatter: `name`, `description`, `state-profile`. Body: bold section headers (Trigger, Procedure, Gotchas, Rules) extracted by `syncSkills()` into the `skills` table at sync time.

---
id: TERM.SKILL
title: Skill
source: assembler
tags: skill,workflow,stateful,hybrid,opencode
terms: [TERM.SKILL.STATECLASS]
patterns: [PAT.SKILL.STATECLASS,PAT.THOUGHT]
related: []
reference:
  - title: PAT.SKILL.STATECLASS — Skill State Classification Pattern
    url: https://opencode.ai/docs
  - title: PAT.THOUGHT — Derived Skill Index
    url: https://opencode.ai/docs
  - title: TERM.SKILL.STATECLASS — Skill State Classification term
    url: https://opencode.ai/docs
  - title: classify-tool skill — example skill
    url: https://opencode.ai/docs
---