# Tool Error Postmortem

## Incident

When starting an opencode session in `assembler/`, tools produced terminal output and validation failures that prevented normal interaction.

## Timeline

| Time | Event |
|------|-------|
| Session start | `opencode assembler/` launched |
| MCP startup | 9 MCP servers spawn as child processes |
| Tool validation | opencode scans `.opencode/tools/` and validates each file |
| Validation failure | `bench-vectors.ts`, `reindex-vectors.ts`: shebang CLI + cross-tool imports flagged |
| User impact | Terminal flooded with error output, cannot type messages |

## Root Cause Chain

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Monolith extraction created tools/ files copying MCP     │
│    server logic into shebang CLI wrappers                   │
├─────────────────────────────────────────────────────────────┤
│ 2. Those wrappers had cross-tool imports into               │
│    tools/mcp-patlib-vector/embedder.ts instead of _lib/     │
├─────────────────────────────────────────────────────────────┤
│ 3. Later extraction fixed imports (→ _lib/embedder-onnx)    │
│    but tools kept shebang format instead of plugin format   │
├─────────────────────────────────────────────────────────────┤
│ 4. Shebang CLI format violates audit-tool Rules 2 and 8:    │
│    - Rule 2: export default tool({...}) required             │
│    - Rule 8: console.log output flagged                     │
├─────────────────────────────────────────────────────────────┤
│ 5. opencode startup validation flags violations → terminal  │
│    error output → user blocked                              │
└─────────────────────────────────────────────────────────────┘
```

## Two Distinct Bugs, Same Symptom

| Bug | Original | Follow-up |
|-----|----------|-----------|
| **Violation** | Cross-tool import | Plugin format violation |
| **Files** | `bench-vectors.ts`, `reindex-vectors.ts` | `search-vectors.ts`, `similar-vectors.ts` |
| **Pattern** | `import("../tools/mcp-patlib-vector/embedder")` | `#!/usr/bin/env bun` + `main().catch()` |
| **Why missed** | Imports looked clean at glance, hidden in dynamic `await import()` | Copied MCP server structure without adapting to plugin format |
| **Fix** | Extract to `_lib/embedder-onnx.ts` | Convert to `export default tool({...})` or disable |

## Why the Follow-Up Bug Happened

The MCP server (`mcp-patlib-vector/index.ts`) uses a shebang + `main().catch()` pattern. When extracting its logic into standalone CLI tools, the same pattern was copied — but MCP servers and CLI tools live in different discovery paths:

| Type | Location | Format | Validation |
|------|----------|--------|------------|
| MCP server | `tools/*/index.ts` | shebang + MCP SDK | Exempt (configured in `opencode.json`) |
| Custom IPC Tool | `tools/*.ts` | `export default tool({...})` | Validated by audit-tool |
| Shebang CLI | `tools/*.ts` | shebang + main() | ❌ Flagged |

The format mismatch: MCP servers are configured in `opencode.json` and started as child processes. CLI tools are discovered as OpenCode plugins and validated against audit rules. A tool file cannot be both.

## Key Metrics

| Metric | Value |
|--------|-------|
| Total files created | 3 new + 1 restored |
| Total files disabled | 5 |
| Distinct bug causes | 2 (cross-tool import, format violation) |
| Review cycles to catch | 2 (caught only after disabling) |
| Orphaned `_lib/` modules | 12 (~716 LOC) |
| Startup processes | 9 MCP servers |
| Active tools (plugin-compliant) | 17 |
