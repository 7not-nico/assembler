---
id: NEX.TOOL.CHOICE
title: "Tool Layer Choice — CLI, IPC, MCP, Plugin, or Script"
source: assembler
summary: "Five tool and script layers: CLI (human-facing TS), IPC (agent-facing TS), MCP (agent-facing transport), Plugin (event-driven in-process), Script (Ruby functional investigation). CLI and Script serve as fallback tiers."
composition: "Five layers compose the tool and script system: CLI (human-facing TS/Bun, fallback), IPC (agent-facing Custom IPC, root-level), MCP (agent-facing JSON-RPC transport, read-default), Plugin (event-driven in-process, write-only), Script (Ruby functional investigation, atomic audits). CLI and Script serve as fallback tiers. Deployment layer chosen by call pattern: repeated queries use MCP, single ad-hoc use CLI, MCP, or IPC, light ops use MCP or Plugin, heavy ops use any, investigative analysis uses Script."
enforcement: Convention
status: active
priority: 3
tags: [tooling, architecture, performance, layer-choice, deployment, convention]
---

Five layers compose the tool and script system: CLI (human-facing TS/Bun, fallback), IPC (agent-facing Custom IPC, root-level), MCP (agent-facing JSON-RPC transport, read-default), Plugin (event-driven in-process, write-only), Script (Ruby functional investigation, atomic audits). CLI and Script serve as fallback tiers when a higher layer unavailable.

## Protocol

1. **CLI and Script serve as fallback tiers** — when MCP server, IPC, or plugin unavailable, CLI tools provide equivalent operations. `read-*` tools fall back for MCP read queries. `write-*` tools fall back for plugin write operations. Scripts fall back for investigative analysis when MCP query tools unavailable. The CLI layer covers both directions at the cost of manual invocation — use when the higher layer is unavailable or during development.

2. **Choose deployment layer by call pattern** — I/O direction and analysis type determine possible layers. Call pattern selects among them:
   - Repeated (3+) queries per session → MCP (1-6ms RTT after ~60ms init)
   - Single ad-hoc query → CLI, IPC, or MCP (similar total cost)
   - Light operation (<30ms lib work) → MCP, IPC, or Plugin (CLI 25-30ms startup dominates)
   - Heavy operation (>100ms lib work) → any layer (overhead <10% of total)
   - Investigative analysis → Script (Ruby atomic audits with parallel execution)
   - Event-driven → three detection tiers by trigger source:
     - opencode editor manual save → Plugin (`file.edited`)
     - agent Write/Bash tool execution → Plugin (`tool.execute.after`)
     - any-source filesystem change → MCP (`fs.watch`)

## Performance characteristics

Measured on local NVMe with Bun 1.3.14. Relative ratios stable across hardware; absolute numbers scale with filesystem speed.

| Layer | Cold init | Per-call RTT | Startup cost amortization |
|-------|-----------|-------------|---------------------------|
| CLI | 25-30ms per invocation | same as cold | Only on heavy ops (>100ms lib work) |
| IPC | ~0ms (in-process) | ~0ms beyond lib | N/A — always warm |
| MCP | ~60ms process startup | 1-6ms | Full — server stays alive per session |
| Plugin | ~0ms (in-process) | ~0ms beyond lib | N/A — always warm |
| Script | ~50ms Ruby init | 1-5ms per script | Amortized over batched audits via `r0-run-parallel.rb` |

Implications:
- Repeated queries in a session favor MCP: 1-6ms vs 25-30ms per CLI call
- Single queries: CLI, IPC, and MCP are equivalent (~30ms total time)
- Heavy operations (validate, sync, full scan): layer choice irrelevant
- CLI startup cost dominates light operations — a sub-millisecond query costs 25-30ms in CLI overhead (79× lib baseline measured)
- Script init cost amortizes over parallel batch execution — `r0-run-parallel.rb` forks 48 scripts in parallel

## Rationale

- Layer choice depends on call pattern beyond I/O direction — a read operation may prefer MCP for repeated calls; CLI suits a single ad-hoc query
- The performance table grounds the choice in measured latency rather than intuition — CLI startup dominates light ops, MCP process startup amortizes over repeated calls, Plugin has zero startup cost

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| MCP server for a single session query | MCP init (~60ms) equals or exceeds CLI cold start | Use CLI or bun -e — MCP overhead only pays off at 3+ queries |
| CLI for repeated (10+) queries in a loop | 25-30ms per CLI call × 10 = 250-300ms overhead | Rewrite as MCP or Plugin — 1-6ms per call after init |
| Plugin for heavy computation | Plugin runs in-process, blocking the event loop | Extract to MCP server — long-running work belongs in a separate process |
| Layer choice driven by preference, pattern absent | Developer always uses CLI regardless of call count | Delegate to the call pattern rules — repeated queries favor MCP; CLI excluded for repeated use |

## Enforcement

Code review and `audit-tool` verify deployment layer matches call pattern during tool design. Repeated-use operations default to MCP or Plugin; single-use operations may use CLI.

## Applicability

All AMANDA projects. Layer choice applies to all five deployment layers: `.opencode/tools/` (CLI + IPC), `.opencode/tools/mcp-*/` (MCP), `.opencode/plugins/` (Plugin), and `.opencode/_scripts/` (Script).

## See also

- `ILL.TOOL.LAYER.CHOICE.DECIDE` — CLI vs IPC vs MCP vs Plugin vs Script decision walkthrough
- `IDENTITY.CLI` — CLI identity
- `IDENTITY.IPC` — Custom IPC identity
- `IDENTITY.MCP` — MCP identity
- `IDENTITY.PLUGIN` — Plugin identity
- `IDENTITY.SCRIPT` — Script identity
- `PROT.TOOL.MODEL` — invocation model types (Shebang CLI, Custom IPC)
- `PROT.TOOL.AUTOMATON` — tool I/O classification (rule 8)
- `PROT.PLUGIN.WRITE` — plugin write-only contract
- `REF.LIB.PURITY.BOUNDARY` — purity tiers; layer choice respects the same boundary
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — single direction per tool
- `CON.FS.WATCH` — filesystem-level event detection via MCP
- `PROT.PLUGIN.LIFECYCLE` — hook matrix with trigger source disambiguation
