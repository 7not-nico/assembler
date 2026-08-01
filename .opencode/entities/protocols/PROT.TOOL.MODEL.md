---
id: PROT.TOOL.MODEL
title: "Tool Invocation Model — Shebang CLI vs Custom IPC Tool"
source: NEX.TOOL.CHOICE
related: [PROT.PLUGIN.WRITE, PROT.TOOL.AUTOMATON, PROT.TOOL.DISCOVERY]
summary: "Tools operate in two invocation contexts: Shebang CLI for human-facing subproject tools (bun run), and Custom IPC Tool for agent-facing root tools (auto-discovered by OpenCode). CLI prefix naming signals I/O direction."
protocol: "Subproject user tools use shebang CLI with bun run; root agent tools use Custom IPC Tool with export default tool({...}). CLI prefix signals I/O direction (read-*, write-*, audit-*)."
enforcement: Formality
status: active
priority: 3
tags: [tooling, architecture, opencode, convention, invocation, cli, ipc]
---

Tools operate in two invocation contexts: Shebang CLI for
Human-facing subproject tools (invoked via `bun run`), and Custom IPC Tool for agent-facing
Root tools (auto-discovered by OpenCode). The model determines shebang, output channel,
Permissions, and discovery mechanism.

## Protocol

1. **Shebang CLI for subproject user tools** — tools in subproject `.opencode/tools/`
   use shebang with `bun` on line 1. Humans invoke them by name:
   `bun run .opencode/tools/read-node.ts`. Output via `console.log` → stdout.
   Permissions: `rw-r--r--` (644) — `bun run` loads the file directly; execute
   bit optional.

2. **Custom IPC Tool for root agent tools** — tools in root `.opencode/tools/` use
   `export default tool({...})` per `PROT.TOOL.DEFINITION`. Shebang: excluded —
   `export default tool({...})` replaces it. Output: `return` string from
   `execute()`. Auto-discovered by OpenCode filesystem scan.
   Permissions: `rw-r--r--` (644).

3. **Common constraints apply to both** — import from `lib/` only, other tools
   excluded. `crashOnError()` at top of every entry point. Both follow purity
   boundary
   per `REF.LIB.PURITY.BOUNDARY`.

4. **Custom IPC at root only** — Custom IPC Tool format
   (`export default tool({...})`) belongs in root `assembler/.opencode/tools/`.
   Subprojects use OpenCode auto-discovery exclusively for plugin and MCP
   discovery; their `lib/` module paths resolve locally to support shebang CLI
   tools. Use Shebang CLI, MCP, or Plugin format for subproject tools.

5. **Choose by audience and project level** — root tools default to Custom IPC
   (agent calls). Subproject tools default to Shebang CLI (human calls). A tool
   with both audiences: write as Shebang CLI in subproject, extract shared logic
   to `lib/`, promote to root Custom IPC when agent requirements emerge.

6. **Promote don't duplicate** — when a subproject Shebang CLI tool gains agent
   requirements, promote to root Custom IPC Tool. Extract shared logic to `lib/`,
   rewrite the tool shell to `export default tool({...})`, keep the original as
   CLI wrapper calling the same lib function if human invocation still needed.

7. **CLI prefix signals I/O direction** — CLI tools in `.opencode/tools/` use prefix
   naming for discoverability. `read-*` tools execute read-only SELECT queries and
   file reads — invocation via `bun run .opencode/tools/read-<name>.ts`. `write-*`
   tools execute write-only INSERT, UPDATE, DELETE, and file writes — invocation
   via `bun run .opencode/tools/write-<name>.ts`. `audit-*` and `verify-*` tools
    are read-only acceptors — they inspect state and return diagnostics. Mixed
    prefixes that read and write within one tool violate the naming contract. The tier
   contract (`PAT.MCP.READONLY`, `PROT.PLUGIN.WRITE`) governs I/O rules; CLI
   prefix naming mirrors that separation.

8. **TRNS tools are the mixed-I/O exception** — transducer tools (TRNS per
   `PROT.TOOL.AUTOMATON`) read, transform, AND write by nature. Use `reindex-*`
   or `sync-*` prefix to signal transducer role. `reindex-vectors` reads entity texts,
   transforms into embeddings, writes to vector index. Allowed because operation is
   idempotent, cache is disposable, and source mtime gating prevents unnecessary writes.

## Applicability

All AMANDA projects with `.opencode/tools/`. Applies to both root and subproject
Tools, with project-level restrictions:

Allowed tool types vary by project level:

- Root `assembler/` permits Custom IPC, Shebang CLI, MCP, and Plugin.
- Subproject permits Shebang CLI, MCP, and Plugin — Custom IPC is excluded.

The tier contract layer (`PAT.MCP.READONLY`, `PROT.PLUGIN.WRITE`) defines I/O
Rules for their respective layers; this protocol defines the invocation model
For CLI and Custom IPC tools.

## Enforcement

- `audit-tool` (root): verify shebang present only on CLI tools, `console.log` use
  limited to CLI tools, `process.exit` use limited to CLI tools, `export default
  tool({...})`: required for root tools.
- Ludoteca `audit-lib`: shebang: required on all tools. Import paths: `lib/` only.
  Tool→tool imports excluded.

## See also

- `ILL.TOOL.INVOCATION.PICK` — invocation model walkthrough — Shebang CLI promotion
- `IDENTITY.CLI` — CLI identity
- `IDENTITY.IPC` — Custom IPC identity
- `IDENTITY.SCRIPT` — Script identity (Ruby functional layer, separate invocation model)
- `NEX.TOOL.LAYER.CHOICE` — layer choice by call pattern, performance characteristics
- `PROT.TOOL.DEFINITION` — Custom IPC Tool architecture
- `PROT.TOOL.SCOPE` — project-scoped tool namespacing
- `PROT.TOOL.AUTOMATON` — automata I/O model for tools
- `REF.LIB.PURITY.BOUNDARY` — purity tiers for lib modules
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — single direction per tool
