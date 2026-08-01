**Skill** — a procedure provider following `{action}-{domain}` naming. Skills are hybrid state automata — they can be stateless, stateful-reader, stateful-writer, stateful-auditor, or hybrid. Each skill in `.opencode/skills/` uses `{action}-{domain}` naming with a SKILL.md format. Skill compilation auto-registers into patlib via write-sync.

---
id: IDENTITY.SKILL
title: Skill — {Action}-{Domain} Naming and Resolution
source: PROT.SKILL.SCHEMA.SCHEMA
group: architectonic
ring: R1
naming: '{action}-{domain}'
tags: skill,identity,naming,convention,resolution,mcp
related: [IDENTITY.RULE, PROT.SKILL.PROFILE, PROT.TOOL.AUTOMATON]
reference:
  - title: PROT.SKILL.SCHEMA.SCHEMA — skill entity protocol
    url: https://opencode.ai/docs
  - title: PROT.SKILL.PROFILE — skill state classification
    url: https://opencode.ai/docs
  - title: PROT.TOOL.AUTOMATON — tool automaton classification
    url: https://opencode.ai/docs
---
