---
id: ILL.LIB.STACK
title: "Handler Stack — Read Handler Orchestration Walkthrough"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of the read handler pattern — transport calls handler, handler queries DB, formatter converts to text. Uses entity-search.ts as the concrete example."
illustration: "An MCP tool calls searchEntities which queries the DB via builtEntityQuery. The handler returns raw rows; a pure formatter converts them to display text."
illustrates: [NEX.LIB.STACK]
tags: lib,handler,walkthrough,orchestration,read,stack
related: [REF.LIB.PURITY.BOUNDARY, PROT.LIB.CONTRACT]
---
## Rationale

Patlib uses a three-layer architecture for data access: **transport** (thin, wires calls), **handler** (io, queries DB), **formatter** (pure, converts data to text). This walkthrough traces a complete read operation from MCP tool invocation through handler query to formatted output.

Files involved:
- `.opencode/_lib/mcp-query.ts` — the handler with `searchEntities` and `getEntityDetail`
- `.opencode/_lib/mcp-format.ts` — the pure formatter with `formatSearchResults` and `formatEntityDetail`
- `.opencode/tools/mcp-patlib/index.ts` — the transport layer registering MCP tools

## Walkthrough

### Step 1: Transport receives the tool call

The MCP tool `patlib_search` receives user arguments (type, query, tag, limit). The transport code validates arguments via Zod schema, then calls the handler:

```typescript
// tools/mcp-patlib/index.ts — transport layer
const entityType = args.type ?? "terms"
const rows = searchEntities(db, entityType, args)
const text = formatSearchResults(rows, entityType)
return { content: [{ type: "text", text }] }
```

The transport handles argument parsing and result formatting only. No SQL, no file I/O.

### Step 2: Handler queries the DB

The `searchEntities` handler in `mcp-query.ts` owns all DB access. It builds a SQL query dynamically based on the entity type and filter arguments:

```typescript
// _lib/mcp-query.ts — handler, io
export function searchEntities(db, entityType, params) {
  const e = entityType
  if (e === "skills") {
    let sql = "SELECT id, title, body, skill, state_profile FROM skills"
    // ... conditions appended per filter
    return queryAll(db, sql, bindings)
  }
  // ... other entity types
}
```

The handler declares `// purity: io` and `// depends-on: db, paths, fs, path, mcp-types, validate-file`. It manages `initDB()` at the caller level and returns raw `SearchRow[]` objects — no text formatting.

### Step 3: Formatter converts raw data to display text

The pure `formatSearchResults` function in `mcp-format.ts` receives raw rows and converts them to structured text:

```typescript
// _lib/mcp-format.ts — formatter, pure
export function formatSearchResults(rows, entityType) {
  if (rows.length === 0) return `No ${entityType} found.`
  // entity-type-specific layout logic
  const lines = rows.map(r => `${r.id} ${r.title}`)
  return lines.join("\n")
}
```

The formatter is a pure function — no DB access, no file I/O. Same formatter works for MCP and CLI transport.

### Step 4: Separation in practice

Adding a new entity type follows the same pattern:

1. Write SQL in the handler (`mcp-query.ts`)
2. Write formatting logic in the formatter (`mcp-format.ts`)
3. Register the tool in the transport layer (`mcp-patlib/index.ts`)

Each layer keeps a single responsibility. Handlers return raw data for formatters. Formatters convert data without querying. Transport layers wire handler calls only.

## Key insight

The handler pattern enforces **purity-layer separation at the architectural level**: handlers query (io), formatters convert (pure), transport wires (composition). Adding a new entity type requires touching exactly three files — one per layer — and each change stays within its layer's concern.

## See also

- `NEX.LIB.STACK` — the handler pattern this illustrates
- `REF.LIB.PURITY.BOUNDARY` — purity boundary definitions
- `PROT.LIB.CONTRACT` — module contract declarations
- `ILL.LIB.ENSURE.IO` — impurity classification walkthrough
- `ILL.LIB.CONTRACT.BLOCK` — contract block declaration
