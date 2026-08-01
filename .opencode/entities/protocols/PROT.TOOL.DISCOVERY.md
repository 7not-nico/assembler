---
id: PROT.TOOL.DISCOVERY
title: "MCP Server Auto-Discovery — Tool Tier for Project-Domain Access"
source: NEX.TOOL.CHOICE
related: [PROT.PLUGIN.WRITE, PROT.TOOL.DEFINITION, PROT.TOOL.SCOPE]
summary: "MCP servers in opencode.json are auto-discovered by the opencode runtime, forming a third tool tier alongside Custom IPC tools and CLI tools. Project-domain logic gains direct LLM access without manual bun run invocation."
protocol: "MCP servers configured in opencode.json auto-discover their tools, parallel to Custom IPC auto-discovery from .opencode/tools/. Project CLI tools gain auto-discovery via MCP wrapper. opencode.json entry IS registration."
enforcement: Formality
status: active
priority: 3
tags: [tooling, architecture, opencode, convention, mcp, auto-discovery]
---

MCP servers in `opencode.json` are auto-discovered by the opencode runtime, parallel to Custom IPC tool discovery from `.opencode/tools/`. Two auto-discovery mechanisms compose: filesystem-based (Custom IPC) and config-based (MCP). Both expose callable tools to the LLM.

## Tool tiers

Three tiers cover tool access patterns:

Three tiers cover tool access patterns:

- **MCP server tools** source from `opencode.json` → `mcp-*/index.ts`. Auto-discovered via MCP, invoked via LLM tool call. Role: primary read layer — server stays alive with 1-6ms RTT.
- **Custom IPC tools** source from root `.opencode/tools/*.ts`. Auto-discovered via Custom IPC, invoked via LLM tool call. Role: root-level agent tools only.
- **Project CLI tools** source from project `.opencode/tools/*.ts`. Manually discovered, invoked via `bun run <tool>.ts`. Role: fallback tier for development, debugging, and one-off queries.

MCP server tier is the primary read layer for project-domain tools. CLI tools serve as development/debugging fallback per `PROT.TOOL.MODEL`.

## Protocol

1. **`opencode.json` entry registers MCP server** — add `{name}: {type: "local", command: ["bun", "run", ".opencode/tools/mcp-{domain}/index.ts"]}` to the project's `opencode.json`. No separate manifest, DB table, or registration step required.

2. **MCP tools scope by project context** — project-level `opencode.json` scopes MCP tools to that project directory. Root `opencode.json` scopes tools globally across all projects. Follows the same scoping convention as `PROT.TOOL.SCOPE`.

3. **MCP server directory naming follows `mcp-{domain}/`** — place server implementation at `.opencode/tools/mcp-{domain}/index.ts`. Consistent with existing `mcp-patlib`, `mcp-spec-audit`, `mcp-ludoteca`.

4. **MCP server exports focused tool surface** — expose a compact set of retrieval tools per domain (2–5 tools per server). Typical surface: `{domain}_search`, `{domain}_get`. One tool per query pattern. One monolithic tool for all operations is excluded.

5. **MCP server imports from `../../lib/`** — server implementation imports shared library modules, other tools excluded. Same lib import convention as Custom IPC tools per `REF.LIB.DIRECTORY.LAYER`.

6. **Project CLI tools gain auto-discovery via MCP wrapper** — `mcp-{project}/index.ts` imports from `../../lib/db` and `../../lib/read-*` modules, exposing `{project}_search` and `{project}_get` as MCP tools. The MCP wrapper replaces repeated `bun run` CLI invocations for frequent query patterns.

## Gotchas

- `mcp-{domain}/` directory exists without `opencode.json` entry: Add `{name}: {type: "local", command: ["bun", "run", ".opencode/tools/mcp-{domain}/index.ts"]}` to project `opencode.json` (`mcp-*/index.ts` file present, `opencode.json` missing corresponding MCP block)
- MCP server wraps tool instead of lib: Import from `../../lib/` — MCP server delegates to library modules, other tools excluded (imports from `../../tools/` instead of `../../lib/`)
- Over-fragmented tool surface: Consolidate — 2–5 tools per server. Pair retrieval patterns: one search, one get, one validate per domain (Server exposes 10+ individual MCP tools)
- MCP server duplicates an existing Custom IPC tool: Extract shared logic to `../../lib/` — both IPC tool and MCP server import from the same lib module (`mcp-{domain}` tool and `.opencode/tools/` tool share identical SQL and formatting logic)
- Cross-project MCP server: Keep MCP server within the project's own `.opencode/tools/` — each project registers its own server (Project `A` `opencode.json` references `project-b/.opencode/tools/mcp-b/`)

## Enforcement

`audit-tool` extended: verify every `mcp-*/index.ts` under `.opencode/tools/` has a corresponding entry in the project's `opencode.json`. Verify each MCP server exports at least one `server.tool()` call. Flag MCP servers that import from `../../tools/` instead of `../../lib/`. Run `audit-tool` on each push.

## Applicability

Any project with 2+ frequent query patterns against its database. Root MCP servers (`mcp-patlib`, `mcp-spec-audit`) serve as the reference implementation pattern for project-level MCP servers (`mcp-ludoteca`).

## See also

- `ILL.MCP.DISCOVERY.SETUP` — MCP discovery walkthrough — registering ludoteca server
- `PROT.TOOL.DEFINITION` — Custom IPC implementation pattern, parallel auto-discovery mechanism
- `PROT.TOOL.SCOPE` — tool project scoping convention, same scoping rules apply to MCP servers
- `TERM.OPENCODE.CUSTOM.TOOLS` — OpenCode custom tools, both IPC and MCP are tool types
- `IDENTITY.MCP` — MCP identity
- `REF.META.PROJECT.TOPOLOGY` — unidirectional, modular, non-linear architecture; MCP servers add new modular entry points
- `PAT.MCP.READONLY` — MCP read-only contract, tools exposed via auto-discovered servers are read-only
- `PROT.PLUGIN.WRITE` — plugin write-only contract, the write equivalent of this tier
