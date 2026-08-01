---
id: PAT.COMMAND.VERB.DOMAIN
title: "Command Verb-Domain — Consistent Command Naming Convention"
source: assembler
summary: "Every command ID follows CMD.{VERB}.{DOMAIN} with filename {verb}-{domain}.md."
principle: "Commands are named verb-first then domain, enabling predictable discovery and consistent ID structure."
enforcement: Tool
tags: [command, naming, convention, verb, domain, architecture]
patterns: []
terms: [TERM.OPENCODE.COMMANDS]
status: active
priority: 2
---

Commands are named verb-first then domain, enabling predictable discovery and consistent ID structure.

## Context

AMANDA commands — slash-command definitions in `.opencode/commands/` — were originally named inconsistently (domain-verb, verb-domain, domain-noun, single-word). The verb-domain convention establishes a single pattern: the action comes first (verb), then the subject (domain). The ID follows `CMD.{VERB}.{DOMAIN}` and the filename follows `{verb}-{domain}.md`. Prefixes `x` and `z` are concatenated (e.g., `xrequire`, `zconvert`). Repeated segments collapse into acronyms (`COMMAND` → `CMD`). The `SKL.AUDIT.COMMAND` enforces this convention.

## Rules

- Every command ID must match `CMD.{VERB}.{DOMAIN}` — uppercase dot-separated segments
- Filename must match `{verb}-{domain}.md` — lowercase hyphen-separated
- The first segment of the ID (verb) must match the first segment of the filename (verb)
- `x`/`z` prefixes stay concatenated to the segment — they are not separate segments
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
