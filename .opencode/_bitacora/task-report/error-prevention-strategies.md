# Error Prevention Strategies

How to prevent the same class of errors in the future. Derived from the vector tooling retrospective.

## Strategy 1: Pre-Commit Validation Hook

Run the `audit-tool` skill rules before any tool is added to `tools/`:

```bash
# Check format
head -1 tools/new-tool.ts | grep -q '#!/usr/bin/env bun' && echo "FAIL: shebang detected"

# Check imports
rg 'from.*["\x27]\.\.\/tools\/' tools/new-tool.ts && echo "FAIL: cross-tool import detected"

# Check exports
grep -q 'export default tool' tools/new-tool.ts || echo "FAIL: export default tool({...}) required"
```

Ideally, integrate this into the agent's workflow via a rule:

> **Rule**: Before any tool file is added to `.opencode/tools/`, the agent must verify:
> 1. `export default tool({...})` is present
> 2. All imports are from `_lib/` or `lib/`
> 3. No `console.log`, `console.error`, or `process.exit` in execute

## Strategy 2: Audit Existing Tools on Session Start

The `audit-tool` skill should run automatically when a new tool is detected. Consider adding a startup check that:
1. Lists all `.ts` files in `tools/`
2. Checks each for plugin format compliance
3. Reports violations without blocking startup

## Strategy 3: Template-Based Tool Creation

Use a literal template file for new tools. The template should include only the valid pattern:

```typescript
// @toolclass ${CLASS}
import { tool } from "@opencode-ai/plugin"
import { initDB } from "../_lib/db"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "${DESCRIPTION}",
  args: {},
  async execute(args) {
    crashOnError()
    const db = initDB()
    try {
      // ... logic here
      return { content: [{ type: "text", text: JSON.stringify(result) }] }
    } finally {
      db.close()
    }
  },
})
```

## Strategy 4: Separate Shebang CLI Area

If standalone CLI scripts are needed, place them outside `tools/`:

```
.opencode/
├── tools/          # Plugin-format tools only
├── scripts/        # Shebang CLI scripts (not validated)
├── _lib/           # Shared logic
└── _disabled/      # Disabled/dead tools
```

Add a rule: `tools/` is for plugin-format tools only. No shebang CLIs.

## Strategy 5: MCP Server to Tool Extraction Protocol

When extracting logic from an MCP server to a tool, follow this protocol:

1. Identify shared logic → extract to `_lib/` module
2. Create tool in `tools/name.ts` using plugin template
3. Delete duplicated logic from MCP server (update imports)
4. Verify: no paths from `tools/` importing from other `tools/`

The original error happened because step 2 used the MCP server's file as a template instead of the plugin template.

## Strategy 6: Reviewed-by Tool

Create a `tools/audit-tool-files.ts` that scans all active tool files for violations and reports them. Run manually after any tool change:

```typescript
export default tool({
  description: "Audit all tool files for format violations",
  args: {},
  async execute() {
    // Check each tool file for:
    // 1. export default tool({...})
    // 2. @toolclass annotation
    // 3. No cross-tool imports
    // 4. No console.log
    // 5. crashOnError() present
    // Return report
  },
})
```

## Summary: What We Learned

| Lesson | Prevention |
|--------|-----------|
| Cross-tool imports are invisible in dynamic imports | Static analysis / rg check before commit |
| Shebang CLIs fail silently until restart | Template-based creation prevents format drift |
| MCP servers ≠ tools | Use different templates for each |
| `_lib/` extraction fixes imports but not format | Both must be checked independently |
| Same symptom, different causes | Always verify the actual error, not just the surface symptom |
