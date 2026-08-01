# OpenCode Tool Discovery Flow

How opencode discovers, imports, and validates tools in `.opencode/tools/`.

## Discovery Sequence

```
Session Start
  │
  ├── 1. Read opencode.json
  │       ├── MCP servers → start as child processes
  │       ├── Remote servers → connect via SSE
  │       └── Instructions → load rule files
  │
  ├── 2. Scan .opencode/tools/
  │       ├── For each *.ts file (non-recursive):
  │       │     ├── Record file path
  │       │     └── Read first line
  │       │
  │       ├── For each MCP server (subdir with index.ts):
  │       │     └── Register via opencode.json entry
  │       │
  │       └── For each plugin file:
  │             ├── Record file path
  │             └── Read first line
  │
  ├── 3. Import tool files
  │       ├── For each *.ts in tools/:
  │       │     ├── await import(filepath)
  │       │     ├── If throws → report error → continue
  │       │     ├── If mod.default?.execute exists → register
  │       │     └── If undefined → report error → continue
  │       │
  │       └── (Plugin files imported via separate mechanism)
  │
  ├── 4. Load plugins
  │       ├── For each *.ts in plugins/:
  │       │     ├── await import(filepath)
  │       │     └── Register event handlers
  │       │
  │       └── Plugins wire up: file.edited, tool.execute.before/after
  │
  └── 5. Session ready
        ├── Tools available via tool() calls
        ├── MCP servers handling requests
        └── Plugins watching events
```

## What Happens Per Tool Type

| Tool Type | Location | Discovery | Validation |
|-----------|----------|-----------|------------|
| Custom IPC | `tools/*.ts` | Auto-scanned | `mod.default?.execute` check |
| MCP server | `tools/*/index.ts` | `opencode.json` entry | None (process-level) |
| MCP server (auto) | `tools/*/index.ts` | Auto-scanned subdirs | `opencode.json` entry required |
| Plugin | `plugins/*.ts` | Auto-scanned | `mod.exports` event handler check |
| Shebang CLI | `tools/*.ts` | Auto-scanned as Custom IPC | ❌ Fails `default?.execute` check |

## The Discovery Gap

opencode does NOT distinguish between tool types at the file level. It treats every `.ts` file in `tools/` as a potential Custom IPC Tool and imports it:

```
tools/
├── write-sync.ts           ← Custom IPC ✅
├── read-selection.ts       ← Custom IPC ✅
├── search-vectors.ts       ← Shebang CLI ❌ treated as Custom IPC
├── mcp-patlib/
│   └── index.ts            ← MCP server (subdir, different path)
└── _disabled/
    └── bench-vectors.ts    ← Not scanned (underscore prefix?)
```

The scanner likely skips files/directories starting with `_` (like `_disabled/`, `_lib/`, `_backups/`). This is why moving files to `_disabled/` prevents the error — they are no longer in the scan scope.

## What Happens When a Shebang CLI Is Discovered

```
1. Scanner finds: tools/search-vectors.ts
2. Imports it as a Custom IPC Tool
3. Top-level code executes:
     - import initDB
     - import initVectorDB
     - define main()
     - call main()  ← runs the tool logic
     - console.log("Loading...") ← output to terminal
4. Import completes:
     - exports: {}  (no export default)
5. Check mod.default?.execute:
     - undefined
6. Report error, continue
7. Side effects from step 3 already visible in terminal
```

## What the Scanner Skips

The scanner likely skips:
- Files starting with `_` (e.g., `_disabled/`, `_lib/`)
- Directories without `index.ts`
- Files with syntax errors at the import level
- Files that throw on import (reported but skipped)

Files in `_disabled/` are safe because the directory name starts with `_`. This is why moving shebang CLIs there resolves the startup error.

## Key Takeaway

The tool discovery system has two modes:

1. **MCP servers** — configured in `opencode.json`, started as child processes, no format validation
2. **Custom IPC Tools** — auto-discovered by scanning `tools/*.ts`, must have `export default tool({...})`

A file in `tools/*.ts` is assumed to be a Custom IPC Tool. If it is not (shebang CLI), it fails discovery with a confusing error. The only valid shebang files in `tools/` are MCP servers in `tools/*/index.ts` — they are registered differently.
