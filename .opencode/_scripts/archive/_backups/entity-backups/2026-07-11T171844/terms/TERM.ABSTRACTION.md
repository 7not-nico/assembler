**Abstraction** — a formal mathematical or computational concept defined in `abstractions/ABS.*.md` with symbolic notation and inference rules. Distinguished from terms (define *what* — general concepts without formal rules) and patterns (prescribe *how* — conventions and enforcement).

**Structure** — body opens with `**{Name}** —`, followed by formal definition, rules, sections, examples. Backmatter YAML: id, title, source, tags, related, reference (minimum 3 entries with URL+title).

**Schema** — `abstractions` table: id, title, body, source, related, tags, reference, created, modified. ID prefix `ABS.*` per PAT.ENTITY-TYPE-ROUTING. Synced name-to-name into the `abstractions` table.

**PAT.LLM.SPECIFICATION** — exempt. Pure definitions, no behavioral instructions.

Audited by the `audit-abstraction` skill.

---

id: TERM.ABSTRACTION
title: Abstraction
source: assembler
tags: abstraction,definition,vocabulary,patlib,entity-type
terms: [TERM.TERM, TERM.PATTERN]
patterns: [PAT.ENTITY-TYPE-ROUTING]
related: [SKL.AUDIT.ABSTRACTION]
reference:
  - title: OpenCode Documentation
    url: https://opencode.ai/docs
  - title: PAT.ENTITY-TYPE-ROUTING — ID Prefix Convention
    url: https://opencode.ai/docs
  - title: TERM.TERM — Term Entity Definition
    url: https://opencode.ai/docs
  - title: TERM.PATTERN — Pattern Entity Definition
    url: https://opencode.ai/docs
---