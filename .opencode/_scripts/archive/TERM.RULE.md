**Rule** — a compressed, memorable truth derived from a loaded instruction. Defined in `rules/yamls/*.yaml` as pure YAML (no body). Fields: id (RUL.*), title, source, tags, related. Synced into the `rules` table. Rules are the queryable metadata layer for the 17 live instructions loaded from `.opencode/rules/*.md`.

---
id: TERM.RULE
title: Rule
source: CON.BOUNDED.CONTEXT
tags: rule,instruction,compressed,patlib
related: []
reference:
  - title: audit-rule skill — rule compliance check
    url: https://opencode.ai/docs
  - title: .opencode/rules/ — loaded instructions
    url: https://opencode.ai/docs
  - title: .opencode/rules/yamls/ — YAML rule storage
    url: https://opencode.ai/docs
---