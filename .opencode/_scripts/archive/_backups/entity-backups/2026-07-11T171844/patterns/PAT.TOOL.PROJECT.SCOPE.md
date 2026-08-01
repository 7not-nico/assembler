---
id: PAT.TOOL.PROJECT.SCOPE
title: Tool Project Scope — Auto-Discovery Replaces Global Registration
source: assembler
summary: Plugin IPC tools are auto-discovered by OpenCode from .opencode/tools/ per-project. Same-named tools in different projects are distinct by scoping. No filename prefix, registration table, or global namespace needed.
principle: Plugin IPC tools are scoped by their project directory; no global naming, registration, or qualification needed.
enforcement: Convention
tags: [tooling, architecture, opencode, convention, scoping, ipc, plugin]
patterns: [PAT.PLUGIN.IPC.TOOL, PAT.ORTHOGONALITY, PAT.SHARED.LIB]
terms: []
status: active
priority: 3
---

Plugin IPC tools are auto-discovered by OpenCode from `.opencode/tools/` per project. OpenCode resolves them by project context — `write-sync` in `category-theory/.opencode/tools/` is distinct from `write-sync` in `ludoteca/.opencode/tools/` by virtue of their containing projects. No filename prefix, registration table, or global namespace is needed.

## Context

Two classes of tool exist in AMANDA:

| Class | Location | Registration |
|-------|----------|-------------|
| **Root tools** | `assembler/.opencode/tools/` | `toolclass.db` tracks archetypes (TRNS, RECG, etc.) |
| **Project tools** | `*/category-theory/.opencode/tools/` and similar | Filesystem only — no DB entry |

Root tools define reusable archetypes (transducer, acceptor, etc.). Project tools are one-to-one with their project's domain — they import from their own `../lib/db` and operate on their own schema. The two never conflict.

## Rules

1. **Directory is scope** — same-named tools in different projects are distinct. Never rename for global uniqueness.
2. **No toolclass registration** — `toolclass.db` tracks only root-level tool archetypes. Project-local tools are not entered.
3. **No database registration** — project tools are enumerated by the filesystem, not a DB table. No `projects` table needed.
4. **Unidirectional per tool** — one tool, one purpose. Read or write, one direction. Compound operations compose via LLM calling multiple tools or using `task` subagent.
5. **Namespace by project** — file path `project-a/.opencode/tools/write-sync.ts` and `project-b/.opencode/tools/write-sync.ts` coexist without collision.

## Applicability

Every AMANDA project with `.opencode/tools/` — any project using Plugin IPC.

## See also

- PAT.PLUGIN.IPC.TOOL — implementation pattern for Plugin IPC tools
- PAT.ORTHOGONALITY — independent components don't interfere
- PAT.SHARED.LIB — shared library convention
