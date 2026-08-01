---
id: ILL.TOOL.READER
title: "Tool Classify Reader — RECG Classification Walkthrough"
source: PROT.TOOL.DEFINITION
summary: "Walkthrough of classifying a read-projection tool as RECG (acceptor) — read-only, inspects data, returns result."
illustration: "The read-projection tool inspects entity data and returns a projection. No writes, no transforms, no coordination. Classification: RECG (acceptor)."
illustrates: [PROT.TOOL.AUTOMATON]
tags: tool,classification,walkthrough,recg,automaton,acceptor
related: [PROT.TOOL.DEFINITION, PAT.MCP.READONLY]
---
## Context

A new `read-projection` tool queries entity data from patlib and returns a formatted projection. Before writing code, the tool needs an automaton classification. The classification determines what operations the tool may perform.

## Walkthrough

1. Analyze the tool's I/O behavior. `read-projection` takes an entity type and ID, queries the database with a SELECT statement, and returns a formatted result. No writes, no transforms to other domains, no shared state coordination.

2. RECG (acceptor) criteria: reads data, inspects it, returns a result. No writes to persistent state, no coordination with other tools, no transformation across data domains. All RECG conditions satisfied.

3. Apply the classification as `// @toolclass RECG` on line 1 of the tool file. The annotation is the first line — imports and blank lines above it are violations.

```ts
// @toolclass RECG
import { tool } from "@opencode-ai/plugin"
```

4. Verify the classification matches the implementation. MCP tools use RECG per `PAT.MCP.READONLY`. Custom IPC tools accept all four classes. The classification stays with the tool — a RECG tool moving from MCP to CLI keeps the same class.

5. Run `audit-tool` to confirm. The audit reads line 1, verifies `// @toolclass RECG`, checks no write operations exist in the handler or its lib dependencies.

## Key insight

The automaton class describes I/O behavior, not deployment layer. A RECG tool works as MCP (primary read layer) or CLI read-* (fallback). The classification stays constant when deployment changes. Four classes cover all tool I/O patterns: RECG (acceptor), TRNS (transducer), GENR (generator), SGNL (synchronizer).

## See also

- `PROT.TOOL.AUTOMATON` — abstract classification rules
- `CON.TOOLCLASS.AUTOMATON` — automaton class definitions
- `PROT.TOOL.DEFINITION` — Custom IPC tool structure
- `PAT.MCP.READONLY` — MCP read-only contract
