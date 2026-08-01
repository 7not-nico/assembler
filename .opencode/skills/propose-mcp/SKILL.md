---
name: propose-mcp
description: Use this skill when the user discusses a persistent service or multi-step workflow — it detects when an MCP server is warranted and proposes creating it with full convention compliance
state-profile: hybrid
related: ["SKL.AUDIT.TOOL"]
terms: ["IDENTITY.MCP"]
patterns: ["NEX.META.PROPOSAL", "REF.LIB.PURITY.BOUNDARY", "REF.LIB.DEPENDENCY.DIRECTION", "PROT.LIB.CONTRACT", "REF.LIB.DIRECTORY.LAYER"]
---
**Procedure**

When proposing an MCP server:

1. **Detect** — infer MCP server name from discussion. Check `glob .opencode/tools/{name}/index.ts` — skip if exists
2. **Check** — `read-selection --type tools` — skip if tool class already registered
3. **Layer confirm** — run layer check via `SKL.GUIDE.ARCHITECTURE`:
   - Needs persistent DB or filesystem access across calls? → MCP server
   - Stateless one-shot operation? → Custom IPC tool instead (propose via `SKL.PROPOSE.TOOL`)
   - User-initiated slash workflow? → Command instead
   - Needs auto-detect triggers? → Skill instead
   - Prescribes how with principle? → Pattern instead
4. **Search** — find related entities for cross-references:
   - `read-selection --type patterns --query persistent|service|db|io|mcp`
   - `read-selection --type protocols --query mcp|tool|lib|purity`
   - `read-selection --type terms --query mcp|tool`
5. **Design purity structure** — per `REF.LIB.PURITY.BOUNDARY`:
   - `_lib/{name}-types.ts` (pure) — shared interfaces
   - `_lib/{name}-query.ts` (io) — DB/filesystem operations, returns typed data
   - `_lib/{name}-format.ts` (pure) — response formatting
   - Smaller scope may merge query + index.ts if minimal I/O
6. **Propose** — when missing, propose creation to user, include:
   - `tools/{name}/` directory structure
   - Module contracts with `// purity:` annotations
   - MCP tool signatures with Zod schemas
   - Related entities found for cross-references
   - Reference implementations: `mcp-patlib` (patlib query), `mcp-spec-audit` (spec audit)
7. **Create package** — `tools/{name}/package.json` with deps: `@modelcontextprotocol/sdk`, `zod`
8. **Write lib** — create modules following impurity→pure dependency direction
9. **Write server** — `tools/{name}/index.ts` using `StdioServerTransport`, thin orchestration only
10. **Verify** — run stdio smoke test: `initialize` → `tools/list` → `tools/call` for each tool

**Gotchas**

- Use subdirectory structure `tools/{name}/index.ts` for MCP servers — signals server vs Custom IPC tool
- MCP server location: `tools/{name}/index.ts` subdirectory. Single file `tools/{name}.ts` signals Custom IPC tool — subdirectory required for servers
- The `// purity:` contract is mandatory on every lib module — first 5 lines declare exports, purity, depends-on per `PROT.LIB.CONTRACT`
- Pure modules use `import type` for cross-boundary type access — runtime imports from I/O modules disallowed (`REF.LIB.DEPENDENCY.DIRECTION` rule 4)
- MCP servers default to stdio transport — add Streamable HTTP only when multi-client access is needed
- Use Custom IPC tools for single-file operations with no persistent state rather than MCP servers — keep scope minimal
- `package.json` is required per `tools/{name}/` — MCP servers use their own dependency plane
- Server name in `new McpServer({ name })` should match the directory name (e.g., `mcp-spec-audit`)
- Every tool argument must have `.describe()` — the LLM reads these to understand parameters
- Response formatting stays in pure modules — pure modules own all string formatting; I/O modules return typed data only
- `z.enum()` validator uses `as const` array. Mutable array excluded — prevents type widening
- After creation — run stdio test before reporting complete. Import check alone insufficient — test init, list tools, call each tool

**Rules**

- Frontmatter: `name` + `description` + `state-profile` + `related` + `terms` + `patterns` only
- Body: Trigger → Procedure → Gotchas → Rules → See also
- Procedure follows `NEX.META.PROPOSAL`: detect → check → search → write → verify
- Every MCP server has: `index.ts` (orchestration) + lib modules (pure/io separation)
- Every lib module declares contract: `// exports:`, `// purity:`, `// depends-on:`
- A pure module uses `import type` for I/O module access — runtime imports require an impure facade
- After creation — run stdio smoke test: init, list tools, call each tool with sample args

**See also**

- `SKL.GUIDE.ARCHITECTURE` — updated layer decision tree with MCP server at step 10
- `REF.LIB.PURITY.BOUNDARY` — purity definitions and side-effect checklist
- `REF.LIB.DEPENDENCY.DIRECTION` — unidirectional import dependency direction
- `PROT.LIB.CONTRACT` — module contract declaration format
- `REF.LIB.DIRECTORY.LAYER` — root `_lib/` vs subproject `lib/`
- `IDENTITY.MCP` — MCP identity
- `SKL.AUDIT.TOOL` — audit counterpart for verification
- `SKL.PROPOSE.TOOL` — propose Custom IPC tools (alternative layer)
- `SKL.PROPOSE.COMMAND` — propose commands (alternative layer)
- `mcp-patlib` — reference: patlib MCP server (DB-backed, 3 lib modules)
- `mcp-spec-audit` — reference: spec audit MCP server (DB-backed, 3 lib modules)
