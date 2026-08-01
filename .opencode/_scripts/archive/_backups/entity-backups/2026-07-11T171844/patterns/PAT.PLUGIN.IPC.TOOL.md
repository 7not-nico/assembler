---
id: PAT.PLUGIN.IPC.TOOL
title: Plugin IPC Tool — Auto-Discovered OpenCode Tools
source: assembler
summary: OpenCode custom tools defined via @opencode-ai/plugin tool() helper, auto-discovered from .opencode/tools/.
principle: Every tool the LLM calls must use export default tool({...}) with typed args schema, returning a string from execute().
enforcement: Convention
tags: [tooling, architecture, opencode, convention, ipc, plugin]
patterns: [PAT.ORTHOGONALITY, PAT.SHARED.LIB, PAT.ANCHORED.PATHS, PAT.MUTATION.PATTERN]
terms: []
status: active
priority: 3
---

Every tool the LLM calls must use `export default tool({...})` with typed args schema, returning a string from `execute()`.

## Context

Three tool architecture patterns exist across AMANDA systems:

| Pattern | Mechanism | Status | Used by |
|---------|-----------|--------|---------|
| **Shebang CLI** | `#!/usr/bin/env bun` + `bun run .opencode/tools/<name>.ts` | Legacy | nerdfont, bitacora |
| **Hybrid** | Shebang + `export default function` + `process.argv[1]` self-check | Legacy | was palestra |
| **Plugin IPC** | `export default tool({...})` from `@opencode-ai/plugin` | Target | ludoteca, palestra |

Plugin IPC is the target. Shebang CLI and Hybrid are legacy — existing tools may remain but new tools must use Plugin IPC.

## Rules

- Use `export default tool({...})` — replaces `export default function` + `process.argv` check
- Describe the tool and each arg with `.describe()` — the LLM reads these
- Define all args with `tool.schema` (Zod) for type safety and LLM-readable parameters
- Return a string from `execute()` — the LLM reads the return value
- Import shared module from `../lib/db` (subproject) or `../_lib/db` (root)
- Import only from `_lib/` or `../lib/`
- `@opencode-ai/plugin` must be in `.opencode/package.json`
- Tool serves one direction — each tool reads or writes, not both
- `crashOnError()` from `errors.ts` at top of every `execute()`

## Migration

Replace Shebang CLI or Hybrid patterns with Plugin IPC:

```typescript
// Old (Hybrid/Shebang CLI)
#!/usr/bin/env bun
import { connect } from "../lib/db"

export default function doSomething() {
  const db = connect()
  const rows = db.query("SELECT ...").all()
  db.close()
  console.log("Found " + rows.length)
}

if (process.argv[1]?.endsWith("name.ts")) { doSomething() }
```

```typescript
// New (Plugin IPC)
import { tool } from "@opencode-ai/plugin"
import { connect } from "../lib/db"

export default tool({
  description: "Describes what this tool does",
  args: {},
  async execute() {
    const db = connect()
    const rows = db.query("SELECT ...").all()
    db.close()
    return "Found " + rows.length
  },
})
```

Key changes:
- `#!/usr/bin/env bun` → remove
- `export default function name()` → `export default tool({...})`
- `console.log(x)` → `return x`
- `process.argv` parsing → typed `args` schema
- CLI self-check → remove (tool is auto-discovered)

## Applicability

All AMANDA systems with `.opencode/tools/` — any project that exposes callable functions to the LLM.

## See also

- PAT.ORTHOGONALITY
- PAT.SHARED.LIB
- PAT.ANCHORED.PATHS
- PAT.MUTATION.PATTERN
- root `AGENTS.md` (tool architecture classification)
