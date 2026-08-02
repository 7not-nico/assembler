**Language Role Map** — each language owns one role in the workspace. Ruby handles script tasks tied to a schema and SQL. Rust and Go handle systems and high-performance logic. Bash handles imperative shells. TypeScript extends OpenCode functionality. The role determines the language; a task selects its language by its layer, not by what it prefers.

## Rule

- **Ruby — schema scripts** — Ruby processes script tasks in the `.opencode/_scripts/` and `script/` folders. Scripts read and write through the schema — `.sql` definitions, `bun:sqlite`/`sqlite3` databases, registry tables. Functional style governs the code. The script's data model lives in its schema; the script executes that model.
- **Rust and Go — systems and high-performance logic** — Rust powers core logic where speed and safety bind: ANN backends, binary transports, computational kernels. Go serves the same role where concurrency and compile speed favor it — goroutine-parallel workers, binary-transport services. Both speak binary protocols at scale; plain formats serve otherwise.
- **Bash — imperative shells** — Bash forms binary imperative shells: tool wrappers, scripts that orchestrate, and scripts that automate. It clones repos, pipes logs, moves files, and sequences commands. Each shell performs one imperative task; guards and clear exit codes govern it.
- **TypeScript — OpenCode extension** — TypeScript extends OpenCode functionality: custom IPC tools, plugins, and MCP servers under `.opencode/tools/` with shared `_lib/` modules. Static types construct the imperative shell around the engine; the engine's core logic stays in Rust.

## Selection test

- The task manipulates schema-backed data through SQL → Ruby.
- The task needs raw speed, binary transport, or a computational kernel → Rust or Go.
- The task sequences commands, files, and processes → Bash.
- The task extends the OpenCode agent runtime → TypeScript.

## Applicability

All code in the workspace: root tooling, project scripts, template infrastructure, and subproject toolchains.

---
id: SPEC.LANGUAGE.ROLE.MAP
title: Language Role Map — Ruby Schemas, Rust/Go Systems, Bash Shells, TypeScript Extension
source: assembler
summary: "Ruby processes script tasks tied to a schema. Rust and Go power systems and high-performance logic with binary transports. Bash forms imperative shells that orchestrate. TypeScript extends OpenCode functionality via IPC tools, plugins, and MCP servers."
specifies: Language selection by role across the workspace
tags: [language, role, selection, ruby, rust, go, bash, typescript, specification]
status: active
---
