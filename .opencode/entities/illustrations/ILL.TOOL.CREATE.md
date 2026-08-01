---
id: ILL.TOOL.CREATE
title: "Custom IPC Tool — Step-by-Step Tool Creation"
source: PROT.TOOL.DEFINITION
summary: "Walkthrough of creating a Custom IPC Tool from scratch: defining the tool() wrapper, typed args schema with .describe(), crashOnError() guard, and single-direction execute logic."
illustration: "A new read-tags tool follows the Custom IPC Tool protocol: export default tool({...}) with typed args via tool.schema, crashOnError() as first call, return string from execute, one direction per tool."
illustrates: [PROT.TOOL.DEFINITION]
tags: tooling,walkthrough,custom-ipc,tool-creation,convention
related: [PROT.TOOL.MODEL, PROT.TOOL.DEFINITION, REF.LIB.DIRECTORY.LAYER]
---
## Context

A tool is needed that reads all tags from patlib entities filtered by type. The tool follows `export default tool({...})` with typed args, `crashOnError()`, and one direction.

## Walkthrough

### Step 1: File structure

Place the file at `.opencode/tools/read-tags.ts`. The name follows the `read-*` prefix convention for read-only tools.

### Step 2: Import dependencies

```ts
import { tool } from "@opencode-ai/plugin"
import { crashOnError } from "../_lib/errors"
import { initDB, queryAll } from "../_lib/db"
```

Imports from `_lib/` only per REF.LIB.DIRECTORY.LAYER. Other tools excluded.

### Step 3: Define the tool with typed args

```ts
export default tool({
  name: "read-tags",
  description: "List all tags from patlib entities, optionally filtered by entity type.",
  args: {
    type: tool.schema.string().optional().describe("Filter by entity type (patterns, terms, protocols)"),
    limit: tool.schema.number().optional().describe("Max results (default 50)"),
  },
  execute: async (args) => {
    crashOnError()
    // ... logic
  },
})
```

Every arg has `.describe()` — the LLM reads these to understand parameter expectations.

### Step 4: Single-direction execute logic

The tool reads only — no writes:

```ts
execute: async (args) => {
  crashOnError()
  const db = initDB()
  let rows: { tag: string }[]
  if (args.type) {
    rows = queryAll(db, `SELECT DISTINCT tags FROM ${args.type}`) as { tag: string }[]
  } else {
    rows = queryAll(db, "SELECT DISTINCT tags FROM patterns UNION SELECT DISTINCT tags FROM terms") as { tag: string }[]
  }
  const allTags = [...new Set(rows.flatMap(r => r.tag.split(",").map(t => t.trim())))]
  const limited = args.limit ? allTags.slice(0, args.limit) : allTags.slice(0, 50)
  return limited.join("\n")
}
```

The tool reads only. One direction per tool — if a write were needed, a separate `write-tags` tool would handle it.

### Step 5: Auto-discovery

No registration step required. OpenCode scans `.opencode/tools/` and discovers `read-tags.ts` automatically via the `export default tool({...})` pattern.

## Full source

```ts
import { tool } from "@opencode-ai/plugin"
import { crashOnError } from "../_lib/errors"
import { initDB, queryAll } from "../_lib/db"

export default tool({
  name: "read-tags",
  description: "List all tags from patlib entities, optionally filtered by entity type.",
  args: {
    type: tool.schema.string().optional().describe("Filter by entity type (patterns, terms, protocols)"),
    limit: tool.schema.number().optional().describe("Max results (default 50)"),
  },
  execute: async (args) => {
    crashOnError()
    const db = initDB()
    let rows: { tag: string }[]
    if (args.type) {
      rows = queryAll(db, `SELECT DISTINCT tags FROM ${args.type}`) as { tag: string }[]
    } else {
      rows = queryAll(db, "SELECT DISTINCT tags FROM patterns UNION SELECT DISTINCT tags FROM terms") as { tag: string }[]
    }
    const allTags = [...new Set(rows.flatMap(r => r.tag.split(",").map(t => t.trim())))]
    const limited = args.limit ? allTags.slice(0, args.limit) : allTags.slice(0, 50)
    return limited.join("\n")
  },
})
```

## Rules applied

| Rule | In this tool |
|------|-------------|
| `export default tool({...})` | Used at top level — auto-discovery reads this |
| `.describe()` on every arg | `type` and `limit` both have `.describe()` |
| `crashOnError()` at top of execute | First call inside `execute()` |
| Import from `_lib/` only | Imports from `errors` and `db` |
| One direction per tool | Read-only — `SELECT` queries only |
| Return string | Returns `limited.join("\n")` |

## Key insight

A Custom IPC Tool is three things: a schema (args), a guard (`crashOnError()`), and a one-direction action (execute). The `export default tool({...})` wrapper makes all three discoverable and LLM-readable. No CLI registration, no shebang, no `console.log`.

## See also

- `PROT.TOOL.DEFINITION` — the Custom IPC Tool protocol this illustrates
- `PROT.TOOL.MODEL` — tool invocation model; Custom IPC belongs at root level
- `PROT.TOOL.DEFINITION` — schema defaults need runtime `??` fallback
- `REF.LIB.DIRECTORY.LAYER` — lib import path convention
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — one direction per tool
