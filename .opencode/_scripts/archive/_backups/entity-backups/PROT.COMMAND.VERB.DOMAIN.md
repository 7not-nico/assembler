---
id: PROT.COMMAND.VERB.DOMAIN
title: "Command Verb-Domain — Consistent Command Naming Convention"
source: assembler
summary: "Every command ID follows CMD.{VERB}.{DOMAIN} with filename {verb}-{domain}.md."
protocol: "Commands are named verb-first then domain, enabling predictable discovery and consistent ID structure."
enforcement: Tool
related: []
tags: [command, naming, convention, verb, domain, architecture]
status: active
priority: 2
---

Commands are named verb-first then domain, enabling predictable discovery and consistent ID structure.

## Rules

- Every command ID must match `CMD.{VERB}.{DOMAIN}` — uppercase dot-separated segments
- Filename must match `{verb}-{domain}.md` — lowercase hyphen-separated
- The first segment of the ID (verb) must match the first segment of the filename (verb)
- `x`/`z` prefixes concatenate to their segment — one unit per combined prefix+segment
- Repeated domain segments collapse into acronyms
- Source is always `assembler` for first-party commands
- `SKL.AUDIT.COMMAND` enforces this convention — run it after creating any command

## Applicability

Any new or renamed command in `.opencode/commands/`. The convention applies to both the `.md` filename and the corresponding `yamls/{name}.yaml` ID.

## See also

- SKL.PROPOSE.COMMAND
- SKL.AUDIT.COMMAND
- SKL.FORMAT.COMMAND
- TERM.OPENCODE.COMMANDS
- CMD.ADD.CONTENT
- CMD.FLOW.DATA
