# Format Violation Patterns

Common patterns that trigger `audit-tool` validation failures. Derived from the vector tooling retrospective.

## Pattern 1: Shebang CLI in tools/

```typescript
#!/usr/bin/env bun
// @toolclass TRNS

import { initDB } from "../_lib/db"

async function main() {
  const args = process.argv.slice(2)
  // ...
  console.log(JSON.stringify(result))
}

main().catch(e => { console.error("Fatal:", e); process.exit(1) })
```

**Violations:**
- Rule 2: shebang CLI — needs `export default tool({...})`
- Rule 8: `console.log`, `console.error` — needs return string

**Fix:** Convert to plugin format:

```typescript
// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initDB } from "../_lib/db"

export default tool({
  description: "...",
  args: { /* schema */ },
  async execute(args) {
    crashOnError()
    const db = initDB()
    // logic here
    return { content: [{ type: "text", text: JSON.stringify(result) }] }
  },
})
```

## Pattern 2: Cross-Tool Import

File `tools/foo.ts` imports from `tools/bar/`:

```typescript
// IN tools/foo.ts:
import { helper } from "../tools/bar/helper"   // ❌ cross-tool
```

**Violation:** Rule 5 — tools import from `_lib/` only.

**Fix:** Extract shared logic to `_lib/`:

```typescript
// IN _lib/helper.ts:
export function helper() { ... }

// IN tools/foo.ts:
import { helper } from "../_lib/helper"   // ✅

// IN tools/bar/index.ts:
import { helper } from "../../_lib/helper"   // ✅
```

## Pattern 3: Dynamic Cross-Tool Import (Harder to Catch)

```typescript
// IN tools/foo.ts:
const { helper } = await import("../tools/bar/helper")   // ❌ hidden in dynamic import
```

Same violation as Pattern 2, but harder to find with static analysis. The original `bench-vectors.ts` and `reindex-vectors.ts` used this pattern.

**Detection:** Search for `import(` with paths containing `tools/`:

```bash
rg 'import\s*\(.*tools/' tools/
```

## Pattern 4: Console Output in Tools

```typescript
console.log("Working...")           // ❌
console.error("Error:", err)        // ❌
process.stdout.write("progress")    // ❌
```

**Violation:** Rule 8 — tools return strings for LLM consumption.

**Fix:** Return structured data:

```typescript
return {
  content: [{ type: "text", text: JSON.stringify({ status: "done", result }) }]
}
```

For progress, use the tool's return value — the LLM processes it as a single response.

## Pattern 5: process.exit() in Tools

```typescript
if (!args.input) { console.error("missing input"); process.exit(1) }   // ❌
```

**Fix:** Throw or return error:

```typescript
if (!args.input) throw new Error("missing input")
// or:
if (!args.input) return { content: [{ type: "text", text: "Error: missing input" }], isError: true }
```

## Pattern 6: MCP Server Logic Copied to Tool

An MCP server (`tools/mcp-name/index.ts`) uses shebang + `main()` + `console.log` + `process.exit()`. Copying its `index.ts` structure into a standalone tool file preserves all violations.

**Lesson:** MCP servers and tools are different artifact types with different format requirements. Never use an MCP server's source as a template for a tool.

| Aspect | MCP Server | Custom IPC Tool |
|--------|-----------|-----------------|
| Location | `tools/name/index.ts` | `tools/name.ts` |
| Config | `opencode.json` entry | Auto-discovered |
| Import base | `../../_lib/` | `../_lib/` |
| Entry point | `main().catch()` | `export default tool({...})` |
| Output | `console.log` | Return string |
| Args | STDIO JSON-RPC | Schema in `args:` |
| Validation | Exempt (config-driven) | audit-tool rules |

## Automated Detection

Run against all active tools:

```bash
# Shebang CLIs
head -1 tools/*.ts | grep '#!/usr/bin/env bun'

# Cross-tool imports (static)
rg 'from.*["\x27]\.\.\/tools\/' tools/

# Cross-tool imports (dynamic)
rg 'import\s*\(.*["\x27]\.\.\/tools\/' tools/

# console.log in execute
rg 'console\.(log|error)|process\.stdout|process\.exit' tools/*.ts
```
