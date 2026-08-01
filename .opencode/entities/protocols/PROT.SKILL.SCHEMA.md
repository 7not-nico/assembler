---
id: PROT.SKILL.SCHEMA
title: "Skill Identity — {Action}-{Domain} Naming and Resolution Convention"
source: NEX.META.PROPOSAL
summary: "Every skill name follows `{action}-{domain}` hyphenated format. Invocation of a base segment resolves to all matching prefix skills plus associated MCP servers."
protocol: "Every skill in .opencode/skills/ uses `{action}-{domain}` naming. Authored files follow the skill SKILL.md format. Skill compilation from source files auto-registers into patlib via write-sync."
enforcement: Formality
status: active
priority: 2
tags: [skill, identity, naming, convention, resolution, mcp]
related: [PROT.SKILL.PROFILE, PROT.TOOL.AUTOMATON, PROT.LLM.SPECIFICATION]
---

Every skill follows `{action}-{domain}` naming. Directory matches name exactly. Resolution on invocation expands base segment to all prefixed skills plus domain-matching MCP servers. Skills compile from source files into patlib via write-sync.

## Protocol

### Naming

Rule 1 — Name uses `{action}-{domain}` — lowercase, hyphen-separated. Action describes the operation (use, search, audit, propose, format). Domain describes the target (playwright, patlib, protocol, patterns, maxims, nexus).

Rule 2 — Directory matches name exactly — `.opencode/skills/{name}/SKILL.md`. Name and directory must match.

Rule 3 — Aspect skills use `{action}-{domain}-{aspect}` — extended by hyphenation for focused variations. Example: `use-playwright-core`, `use-playwright-debug`.

### Resolution

Rule 4 — Invocation of `{action}-{domain} skill and MCP` resolves:
- The exact `{action}-{domain}` skill file
- All skills with prefix `{action}-{domain}-` (hyphen-extended aspects)
- MCP server(s) whose domain matches the skill domain

Rule 5 — MCP resolution maps by domain convention:
- `search-{entity}` skills → `mcp-patlib` + `mcp-patlib-vector`
- `use-playwright-*` skills → Playwright MCP
- `use-patlib` skill → `mcp-patlib` + `mcp-patlib-vector`
- `use-spec-audit` skill → `mcp-spec-audit`
- `use-entity-audit` skill → `mcp-entity-audit`

Rule 6 — Fallback when MCP unavailable: use Custom IPC tools `read-selection` / `read-projection` per RUL.QUERY.PATLIB.CONTEXT.

Rule 7 — Description starts with `Use this skill when...` — triggers LLM context matching on task description. Description IS the trigger — no separate trigger field needed.

Rule 8 — `state-profile` field declares the skill memory model per PROT.SKILL.PROFILE.

### Registration

Rule 9 — Skill authors create one `SKILL.md` per directory. Frontmatter fields: name (required, matches directory), description (required, starts with "Use this skill when"), state-profile (required), related (optional), patterns (optional), terms (optional).

Rule 10 — `write-sync --type skills` compiles skill directories into patlib. Each directory produces one skills table entry.

## Gotchas

- Name uses underscore or space: Use `{action}-{domain}` with hyphens — `search-protocols`; underscore or space: excluded (Name contains `_` or ` ` instead of `-`)
- Invocation resolves no skills: Verify `.opencode/skills/{action}-{domain}/` directory exists (`{action}-{domain} skill and MCP` returns empty)
- MCP server absent from config: Add MCP server to `opencode.json` — resolution requires active configuration (Skill references MCP absent from `opencode.json`)
- Skill file outside skills directory: Move file into `.opencode/skills/{name}/SKILL.md` — auto-discovery scans this path only (`SKILL.md` placed outside `.opencode/skills/`)
- Directory name mismatches frontmatter name: Align frontmatter `name` to directory name — write-sync uses directory stem (Directory `search-protocols`; frontmatter name `search-patterns`)
- Aspect skill misnamed as separate base: Use `{action}-{domain}-{aspect}` only when adding a focused variant. Base segment `search-protocols` is the canonical name (`search-per-type-protocols` instead of `search-protocols`)
- state-profile field absent: Add `state-profile` matching PROT.SKILL.PROFILE — one of stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid (Validation flags missing field)

## Enforcement

`audit-skill` checks: name matches regex `^[a-z]+(-[a-z]+)+$`, directory matches name, frontmatter has required fields (name, description, state-profile). `mcp-spec-audit` runs before sync — protocol PRs pass 100/100. `read-validate` confirms resolver references match registered MCP servers.

## Applicability

All `.opencode/skills/` directories across root and subprojects. Skills authored for agent workflows. Excluded for non-skill files in `.opencode/` (tools, libs, agents, config).

## See also

- `PROT.SKILL.PROFILE` — skill memory model classification
- `PROT.TOOL.AUTOMATON` — analogous I/O classification for tools
- `PROT.LLM.SPECIFICATION` — contract + gotcha framing rules
- `PROT.META.IDENTITY` — protocol identity format (reference for this file)
- `RUL.USE.LOCAL.MCP.SERVERS` — prefer MCP over manual inspection
- `RUL.QUERY.PATLIB.CONTEXT` — fallback to Custom IPC when MCP unavailable
- `IDENTITY.SKILL` — skill entity identity
- `ILL.PROTOCOL.STRUCTURE` — protocol file creation walkthrough
