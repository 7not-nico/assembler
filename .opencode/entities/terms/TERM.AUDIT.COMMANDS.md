**Audit Commands** — automated compliance checking for the AMANDA command system. The `audit-commands` tool scans all `.yaml` files in `.opencode/commands/yamls/` for required fields (id, title, description, source, tags), ID format (`CMD.{VERB}.{DOMAIN}`), filename-verb agreement, source (`assembler`), tag minimums (3+), description cross-check against `.md` frontmatter, related-ID resolution via patlib.db, bidirectional orphan detection (YAML↔.md), and duplicate ID detection. Part of the audit family alongside `audit-rule`, `audit-term`, `audit-pattern`, `audit-skill`, `audit-tool`, and `audit-investigation`.

---
id: TERM.AUDIT.COMMANDS
title: Audit Commands
source: CON.TOOLCLASS.AUTOMATON
tags: [audit, commands, compliance, convention, enforcement, stateful-auditor]
related: []
reference:
  - title: audit-commands — Tool Definition
    url: https://opencode.ai/docs
  - title: audit-rules — Rules Audit Term
    url: https://opencode.ai/docs
  - title: audit-tool — Tool Audit Term
    url: https://opencode.ai/docs
  - title: PROT.COMMAND.RULE — Command Naming Convention
    url: https://opencode.ai/docs
  - title: TERM.OPENCODE.COMMANDS — Command Definition
    url: https://opencode.ai/docs
---