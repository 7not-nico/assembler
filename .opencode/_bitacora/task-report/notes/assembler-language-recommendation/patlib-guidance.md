# Patlib Guidance — Maxims & Protocols

## Maxims

### MAX.BUN.ONLY — Deterministic Tool Execution

```
status: active | priority: 3 | enforcement: Convention
```

Mandates Bun runtime for all subproject tooling. Rules include:
- Tools execute via `bun run`
- Dependencies resolve through shared symlinks
- Verification uses `bun -e`
- Network operations use `fetch()`
- File operations use `Bun.write()` / `Bun.file()`

**Constraint**: Adding Go or Rust would violate this maxim unless scoped to
specific MCP servers with explicit override.

### MAX.CLI.TO.MCP — Separation Then Unification

```
status: active | priority: 4 | enforcement: Convention
```

Two-phase rhythm: (1) CLI tools determine one aspect each, shared logic in lib/;
(2) MCP composes workflow-relevant aspects.

Rules:
- Each CLI tool determines exactly one aspect
- Begins as `bun run` entrypoint
- MCP declared only after shared logic composable
- MCP imports same package.json deps and shared libs

**Constraint**: Existing pattern assumes TypeScript throughout. Adding Go/Rust
would either: (a) break shared lib extraction, or (b) require separate lib/ per
language.

### MAX.CODE.LAYERS — Dependency Rings

```
status: active | priority: 1 | enforcement: Tool
```

Seven rings: PURE → DB-READ → LOCAL-READ → REMOTE-READ → LOCAL-WRITE →
REMOTE-WRITE → DB-WRITE. Files import only inward.

Tool files declare `// @toolclass`. Lib files declare `// purity: {RING}`.

**Constraint**: Rings are language-independent concept. New-language tools can
declare toolclass; new-language libs must declare ring.

## Protocols

### PROT.MCP.TRANSPORT

Local MCP servers use `StdioServerTransport` from `@modelcontextprotocol/sdk`.
Process persists across requests. `db.close()` per handler.

**Constraint**: This protocol is TypeScript-specific (imports from
`@modelcontextprotocol/sdk`). Go/Rust MCP servers use their own SDKs
(`mark3labs/mcp-go`, `modelcontextprotocol/rust-sdk`). Would need parallel
protocol docs.

### PROT.MCP.SERVER

Agentic (npm-published) servers invoked via `bunx`. Local custom servers
use `bun run`. Agentic servers exempt from read-only constraint.

**Constraint**: Go/Rust MCP servers published as npm packages via `bunx`
or as standalone binaries. If binary, invocation model changes from
`bun run ./path/to/index.ts` to `./path/to/binary`.

### PROT.TOOL.RUNNER

`bunx` over `npx` for package invocation.

**Constraint**: Go/Rust binaries don't need package runners. Distribute as
standalone executables.

## Summary

| Entity | Applies To | Constraint on Go/Rust |
|--------|------------|----------------------|
| MAX.BUN.ONLY | All tooling | **Blocks** — mandates Bun runtime |
| MAX.CLI.TO.MCP | Workflow tools | **Blocks** — assumes TypeScript throughout |
| MAX.CODE.LAYERS | Lib/tool files | **Compatible** — language-independent |
| PROT.MCP.TRANSPORT | Local MCP servers | **Blocks** — TypeScript SDK specific |
| PROT.MCP.SERVER | Published MCP servers | **Needs update** — binary invocation |
| PROT.TOOL.RUNNER | Package invocation | **N/A** — binaries need no runner |
