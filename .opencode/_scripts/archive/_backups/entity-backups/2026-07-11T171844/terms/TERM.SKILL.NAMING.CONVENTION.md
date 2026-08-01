**Skill Naming Convention** — skill identifiers in the AMANDA system follow the `{verb}-{domain}` pattern. The verb describes the action (audit, propose, bootstrap, classify, detect, format, guide, query, refactor, remind, search, judge, vet, stage) and the domain describes the subject (pattern, term, rule, skill, tool, db, project, command, decision, architecture, research, nerdfont, geo, proposal, create, semantic). Established sub-patterns: `audit-{entity}` (7 skills), `propose-{entity}` (3 skills), `guide-{domain}` (2 skills). The patlib ID derives from the directory name via uppercase dot-separated conversion (e.g. `vet-proposal` → `SKL.VET.PROPOSAL`).

---
id: TERM.SKILL.NAMING.CONVENTION
title: Skill Naming Convention
source: assembler
tags: convention,naming,skills,architecture,patlib,classification
terms: [TERM.TERM,TERM.SKILL]
patterns: [PAT.ENTITY-TYPE-ROUTING]
related: []
reference:
  - title: AMANDA skill directory — 23 skills
    url: https://opencode.ai/docs
  - title: PAT.ENTITY-TYPE-ROUTING — related routing convention
    url: https://opencode.ai/docs
  - title: TERM.SKILL — skill definition
    url: https://opencode.ai/docs
---