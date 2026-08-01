---
name: detect-project
description: Detect when a workflow or domain is complex enough to warrant a new project folder with its own database
state-profile: stateful-auditor
related: [PAT.ASSEMBLER.ARCHITECTURE, PAT.ORTHOGONALITY]
---
**Trigger** — user describes a repeatable workflow, persistent data, or domain-specific process involving multi-step data entry, CRUD operations, tagging, or cross-referencing

**Procedure**

When detecting a potential new project:

1. Check assembler root `AGENTS.md` for known projects
2. List assembler root for directories with their own `AGENTS.md`
3. Verify no existing project covers the domain
4. Check if the workflow warrants a new project (see Rules below)
5. If warranted — propose creation to the user
6. On confirmation — derive from `ludoteca/.opencode/`

**Gotchas**

- Always check `AGENTS.md` first — many domains may already be covered
- If the workflow only needs 1-2 tables, it belongs in an existing project — not a new one
- Cross-referencing other projects (patlib.db, nerdfont.db) doesn't require a new project — use the existing tools
- A new project needs its own `AGENTS.md` with subproject conventions — don't create a project without it

**Rules**

- Warrant a new project when: needs its own `bun:sqlite` database with 3+ related tables, needs dedicated CRUD tools or CLI commands, needs domain-specific validation or business logic, needs its own `AGENTS.md` with subproject conventions
- Derive from `ludoteca/.opencode/` — don't invent new structure
- Cross-referencing other projects doesn't require a new project — use existing tools
