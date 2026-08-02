# What We Learned About Tool Format

## Lesson 1: The Format Is the Contract

A tool file's first line is not decorative — it determines how opencode treats the file:

| First line | Treatment | Valid? |
|-----------|-----------|--------|
| `// @toolclass TRNS` | Discovered as Custom IPC Tool | ✅ |
| `// @toolclass RECG` | Discovered as Custom IPC Tool | ✅ |
| `#!/usr/bin/env bun` | Treated as Custom IPC Tool (but fails) | ❌ |
| `import { tool } from "@opencode-ai/plugin"` | Discovered (must also have @toolclass) | ✅ |

The `@toolclass` annotation at line 1 is the marker that says "I am a tool." Without it, or with a shebang first, the file is in an ambiguous state.

## Lesson 2: MCP Servers and Tools Are Different Artifacts

They look similar but behave differently:

```
MCP server: tools/mcp-name/index.ts
  └── Has a package.json
  └── Is a child process
  └── Communicates via stdio JSON-RPC
  └── Configured in opencode.json
  └── Exempt from format validation
  └── Shebang is correct entry point

Custom IPC Tool: tools/name.ts
  └── Is a single file
  └── Imported into opencode process
  └── Returns strings to LLM
  └── Auto-discovered from tools/
  └── Validated by audit rules
  └── Shebang is incorrect
```

## Lesson 3: Imports Can Be Correct While Format Is Wrong

The two bugs in this session demonstrated independent dimensions:

```
Dimension 1: Import paths
  ├── ✅ _lib/ module
  └── ❌ Another tool's directory

Dimension 2: File format
  ├── ✅ export default tool({...})
  └── ❌ #!/usr/bin/env bun + main().catch()
```

A file can have correct imports AND wrong format (the follow-up bug).
A file can have wrong imports AND correct format (the original bug, partially).

Both dimensions must pass independently.

## Lesson 4: The "Template Trap"

When creating a new tool by copying an existing file, the format of the source file determines the format of the new file. This is the **template dependency**:

```
Source file format → template → new file format
                                    │
                                    └── If source is wrong format,
                                        new file inherits the error
```

The fix is to use a verified template (not an existing tool) as the starting point for new tools.

## Lesson 5: Error Messages Are Not Diagnostic

The interceptor's generic "exception running tool" message does not distinguish between:

- Missing `export default tool`
- Wrong export shape
- Broken import path
- Syntax error
- Runtime error in top-level code

Each of these requires a different fix, but the error message is the same. The user must manually inspect the file to determine which case applies.

## Lesson 6: Side Effects Obscure Errors

When a shebang CLI is imported, its top-level code runs before the format check. This means:

1. console.log output appears
2. DB connections open
3. Functions execute
4. THEN the format check fails

The user sees the output from steps 1-3 before the error in step 4, creating the impression that the tool "ran" but then "crashed" — rather than the correct diagnosis that the file was never a valid tool to begin with.

## Lesson 7: Protocol Exists to Prevent These Errors

Every error in this session is explicitly covered by an existing protocol:

| Error | Protocol that would have prevented it |
|-------|---------------------------------------|
| Shebang CLI in tools/ | PROT.TOOL.DEFINITION Rule 1, Gotcha |
| Cross-tool import | PROT.TOOL.COMPOSITE Gotcha 1 |
| console.log instead of return | PROT.TOOL.DEFINITION Rule 4 |
| Main().catch() instead of execute | PROT.TOOL.DEFINITION Rule 1 |
| @toolclass on line 2 not 1 | PROT.TOOL.AUTOMATON Rule 6 |
| Template copy from MCP server | PROT.TOOL.COMPOSITE (MCP servers ≠ tools) |

The protocols existed before the errors occurred. The gaps were:
1. Not knowing which protocols apply to which artifact types
2. Not running audit checks after creating new tools
3. Verifying only one fix dimension at a time
