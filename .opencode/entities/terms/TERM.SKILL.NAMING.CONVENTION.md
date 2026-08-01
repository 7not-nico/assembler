**Skill Naming Convention** — skill identifiers in the AMANDA system follow the `{verb}-{domain}` pattern. The verb describes the action (audit, propose, bootstrap, classify, detect, format, guide, query, refactor, remind, search, judge, vet, stage) and the domain describes the subject (pattern, term, rule, skill, tool, db, project, command, decision, architecture, research, nerdfont, geo, proposal, create, semantic). Established sub-patterns: `audit-{entity}` (7 skills), `propose-{entity}` (3 skills), `guide-{domain}` (2 skills). The patlib ID derives from the directory name via uppercase dot-separated conversion (e.g. `vet-proposal` → `SKL.VET.PROPOSAL`).

---
id: TERM.SKILL.NAMING.CONVENTION
title: Skill Naming Convention
source: CON.SUBJECT.OBJECT.VERB
tags: convention,naming,skills,architecture,patlib,classification
related: []
reference:
  - title: AMANDA skill directory — 23 skills
    url: https://opencode.ai/docs
  - title: SPEC.ENTITY.ROUTING.TABLE — related routing convention
    url: https://opencode.ai/docs
  - title: IDENTITY.SKILL — skill entity identity
    url: https://opencode.ai/docs
---