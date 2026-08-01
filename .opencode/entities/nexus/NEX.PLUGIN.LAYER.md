---
id: NEX.PLUGIN.LAYER
title: Plugin Write Layer
source: assembler
summary: Plugins form a distinct write-side architectural layer. MCP reads, plugins write, CLI falls back. Each plugin delegates to a shared lib handler following the io-handler → write → sync pattern.
composition: Separate write concerns into a dedicated plugin layer. Plugins handle all filesystem and DB writes. MCP and CLI tools stay read-only.
enforcement: Convention
related: []
tags: [plugin, architecture, write, layer, ludoteca, convention]
status: active
priority: 3
---

OpenCode plugins serve as the write-side counterpart to MCP read tools. Plugins in `.opencode/plugins/` register tools that create, modify, or sync persistent data. Each plugin delegates to a shared lib handler, following the io-handler → write → sync pattern.

### Write plugin contract

- Accepts arguments describing the data to create or modify
- Delegates to a shared lib handler in `lib/` (io)
- Handler normalizes, serializes, and writes to filesystem
- Handler synchronizes to DB via `syncType()`
- Returns a status message string

### Why plugins over MCP or CLI

- **Auto-discovered** — OpenCode loads `.opencode/plugins/` at startup without config
- **Write-capable** — MCP tools stay read-oriented. Plugins handle filesystem and DB writes.
- **Direct invocation** — plugins call handlers directly. CLI process is the fallback layer.
- **Session-aware** — plugins receive `{ project, client, $, directory, worktree }` from OpenCode

### Applicability

Teams needing write-side persistence (entity creation, metadata updates, DB sync) beyond what MCP or CLI tools provide. Projects with a `.opencode/plugins/` directory that need auto-discovered write tools.

### See also

- `ILL.PLUGIN.WRITE.FLOW` — write handler delegation walkthrough
- `NEX.LIB.HANDLER.STACK` — handler pattern for io orchestration
- `PROT.TOOL.HOOKS` — plugin lifecycle hooks
- `ILL.LIB.HANDLER.STACK` — read handler orchestration (complementary)
- `TERM.LUDOTECA` — ludoteca project context
