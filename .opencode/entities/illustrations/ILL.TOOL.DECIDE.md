---
id: ILL.TOOL.DECIDE
title: "Layer Choice — CLI vs MCP vs Plugin Decision Walkthrough"
source: PROT.TOOL.DEFINITION
summary: "Walkthrough of choosing the correct deployment layer — repeated queries per session favor MCP over CLI; event-driven detection splits across Plugin (file.edited, tool.execute.after) and MCP (fs.watch) depending on trigger source."
illustration: "A read-pattern tool faces three deployment options: CLI (25-30ms per call), MCP (1-6ms after ~60ms init), Plugin (~0ms in-process). Repeated queries in a session amortize MCP init cost; single queries equivalent across layers."
illustrates: [NEX.TOOL.CHOICE]
tags: tooling,walkthrough,deployment,performance,layer-choice
related: [PROT.TOOL.MODEL, PAT.MCP.READONLY, PROT.PLUGIN.WRITE]
---
## Context

A new tool reads patterns filtered by tag. Three deployment layers are available: CLI (shebang), MCP server, or Plugin. The choice depends on call pattern, init cost, and per-call overhead.

## Performance reference

| Layer | Cold init | Per-call RTT |
|-------|-----------|-------------|
| CLI | 25-30ms per invocation | Same as cold |
| MCP | ~60ms handshake | 1-6ms |
| Plugin | ~0ms (in-process) | ~0ms beyond lib |

## Walkthrough

### Scenario A: Single ad-hoc query

The LLM needs to look up patterns tagged `naming` one time during a session.

| Layer | Total cost | Verdict |
|-------|-----------|---------|
| CLI | 25-30ms | Acceptable |
| MCP | ~60ms init + 1-6ms = ~66ms | Worse than CLI for single use |
| Plugin | ~0ms | Best; lifecycle hook required |

CLI chosen: single ad-hoc query, init cost comparable to MCP, no lifecycle hook needed.

### Scenario B: Repeated queries across a session

The LLM queries patterns by tag repeatedly (15+ times) as it iterates on a naming convention task.

| Layer | Total cost (15 calls) | Verdict |
|-------|----------------------|---------|
| CLI | 15 × 25-30ms = 375-450ms | High cumulative overhead |
| MCP | 60ms + 15 × 1-6ms = 75-150ms | Best — init amortized |
| Plugin | ~0ms | Best, plugin event hook required |

MCP chosen: 3× cheaper than CLI at 15 calls. Init cost pays off after the third call.

### Scenario C: Event-driven write — opencode editor saves

The tool needs to run every time a pattern file is saved in the opencode editor to update the tag index.

| Layer | Feasible | Verdict |
|-------|----------|---------|
| CLI | No — no event trigger | Excluded |
| MCP | No — MCP servers lack opencode `file.edited` hook access | Excluded |
| Plugin | Yes — `file.edited` hook | Only viable option |

Plugin chosen: opencode-internal edit events require the plugin layer exclusively.

### Scenario D: Event-driven write — agent tool or any-source file change

The tool needs to run when the agent writes a pattern file via Write/Bash tool, or when any process modifies a file.

| Layer | Feasible | Verdict |
|-------|----------|---------|
| Plugin | Yes — `tool.execute.after` for agent tool calls | Covers agent writes |
| MCP | Yes — `fs.watch` for any-source filesystem changes | Covers all sources (agent, editor, external) |
| CLI | No — no event trigger | Excluded |

Layer chosen by scope: `tool.execute.after` (plugin) for agent-specific detection, `fs.watch` (MCP) for any-source monitoring. See `PROT.PLUGIN.LIFECYCLE` hook matrix for trigger source disambiguation.

## Decision summary

| Call pattern | Recommended layer | Rule applied |
|-------------|-------------------|-------------|
| Single ad-hoc query | CLI | Layer init cost irrelevant for single use |
| Repeated queries (3+) | MCP | Init amortized; 1-6ms vs 25-30ms per call |
| Event-driven (editor save) | Plugin | Only layer with `file.edited` hook |
| Event-driven (agent tool) | Plugin | `tool.execute.after` hook |
| Event-driven (any-source) | MCP | `fs.watch` at the server level |
| Heavy computation | Any layer | Lib work dominates; overhead <10% |

## Key insight

Layer choice is a cost equation with three variables: init cost, per-call cost, and call count. CLI wins at count=1. MCP wins at count≥3. Plugin wins at count=any with event trigger. For event-driven detection, the trigger source determines the layer: opencode editor saves → Plugin `file.edited`, agent tool execution → Plugin `tool.execute.after`, any-source filesystem change → MCP `fs.watch`. The performance table makes the cost equation computable per use case; the trigger-source table makes the layer choice correct per event type.

## See also

- `NEX.TOOL.CHOICE` — the layer choice protocol this illustrates
- `PROT.TOOL.MODEL` — invocation model types (Shebang CLI, Custom IPC)
- `PAT.MCP.READONLY` — MCP read-only contract
- `PROT.PLUGIN.WRITE` — plugin write-only contract
- `PROT.PLUGIN.LIFECYCLE` — hook matrix with trigger source disambiguation
- `CON.FS.WATCH` — filesystem-level event detection via MCP
