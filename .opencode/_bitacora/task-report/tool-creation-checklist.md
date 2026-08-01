# Tool Creation Checklist

Derived from the vector tooling retrospective. Use when creating any new tool in `.opencode/tools/`.

## Before Writing

- [ ] **Is this a tool or an MCP server?**
  - Tool: single `tools/name.ts` file, `export default tool({...})`
  - MCP server: `tools/mcp-name/index.ts`, configured in `opencode.json`
  - Shebang CLI: ❌ Never create in `tools/`. Use `_lib/` module if logic is needed by other tools.

- [ ] **Does the logic already exist in `_lib/`?**
  - Yes → import from `../_lib/module` (root) or `../lib/module` (subproject)
  - No → add to `_lib/`, not to another tool

## Template

```typescript
// @toolclass <CODE>   // TRNS, RECG, GENR, or SGNL

import { tool } from "@opencode-ai/plugin"
import { initDB } from "../_lib/db"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "One-line description of what this tool does",
  args: {
    input: tool.schema.string().describe("Required input"),
    optional: tool.schema.string().optional().describe("Optional flag"),
  },
  async execute(args) {
    crashOnError()
    const db = initDB()
    try {
      // tool logic here
      return { content: [{ type: "text", text: JSON.stringify(result) }] }
    } finally {
      db.close()
    }
  },
})
```

## Format Rules (Enforced by audit-tool)

| # | Rule | Check |
|---|------|-------|
| 1 | `export default tool({...})` | No shebang, no `main()`, no bare export |
| 2 | `@toolclass` at line 1 | One of: TRNS, RECG, GENR, SGNL |
| 3 | Import from `_lib/` only | No `tools/` → `tools/` imports |
| 4 | `crashOnError()` in execute | Called near top, before DB/FS ops |
| 5 | All args have `.describe()` | No bare `.string()`, `.number()`, `.boolean()` |
| 6 | No console output | Return strings via `{ content: [{ type: "text", text: ... }] }` |
| 7 | Path prefix correct | Root: `../_lib/`. Subproject: `../lib/` |
| 8 | Read/write separation | One direction per tool (read XOR write) |

## Review Checklist (Before Adding to tools/)

- [ ] File starts with `// @toolclass <CODE>` (not `#!/usr/bin/env bun`)
- [ ] Uses `import { tool } from "@opencode-ai/plugin"`
- [ ] Exports `default tool({...})`
- [ ] No `console.log`, `console.error`, `process.stdout.write`
- [ ] All imports from `_lib/` or `lib/` (not from another tool)
- [ ] `crashOnError()` called in `execute()`
- [ ] Schema args have `.describe()`
- [ ] Returns `{ content: [{ type: "text", text: string }] }`
- [ ] DB connections opened and closed (try/finally)
- [ ] Does NOT read AND write in same execute (unless @toolclass TRNS)

## If You Need CLI Behavior

Tools return strings for LLM consumption, not terminal output. If you need a standalone CLI:

- Option A: Use an existing tool's `execute()` — called by opencode, returns string
- Option B: Create a `_lib/` module with the logic, then both a tool and an external script can import from it
- Option C: Keep the CLI script OUTSIDE `tools/` (e.g. `scripts/` or root of project)
- ❌ Never put a shebang CLI in `tools/`
