---
id: PROT.PLUGIN.SCORING
title: "Plugin Candidate Evaluation — Seven Criteria"
source: NEX.PLUGIN.LAYER
related: [PROT.TOOL.HOOKS, PROT.PLUGIN.LIFECYCLE, PROT.PLUGIN.WRITE, PROT.LIB.CONTRACT, PROT.TOOL.AUTOMATON]
summary: "Seven criteria evaluate plugin candidates before implementation. Apply before writing code. Six of seven pass to proceed."
protocol: "Every candidate evaluates against seven criteria. Six of seven pass to proceed. Four to five: refine or reject. Three or fewer: wrong layer."
enforcement: Formality
status: active
priority: 2
tags: [plugin, architecture, evaluation, convention, decision]
---

Seven criteria qualify a plugin candidate before writing code. Criteria divide into four structural and three implementation checks.

## Protocol

### Structural criteria — what to build

1. **Single subject** — one plugin addresses one concern. Two concerns produce two plugins.
2. **Real gap** — solves a recurring friction point. Edge cases and theoretical problems belong in notes. Plugins handle recurrent patterns.
3. **One hook** — single lifecycle hook as entry point. Additional hooks accumulate scope per trigger. Complementary hooks for different trigger sources (e.g. `file.edited` for editor saves, `tool.execute.after` for agent tools) do not count as scope creep — each covers a distinct event path.
4. **Observable output** — writes to a file, database, or `client.app.log()`. Silent plugins hide failures.

### Implementation criteria — how to build

5. **Purity boundary** — logic exceeding five lines extracts to `_lib/{module}.ts` as a pure module. Plugin file handles I/O only.
6. **Low weight** — plugin stays under fifty lines. `_lib/` module stays under fifty lines. Larger files indicate scope creep.
7. **Hooks-only** — hooks handle the concern without tool registration. Plugin-registered tools require companion skills per `PROT.TOOL.HOOKS`.

### Thresholds

Scoring thresholds determine the next action:

- **7 of 7** — proceed with implementation.
- **6 of 7** — proceed and document the one weakness.
- **4 to 5 of 7** — refine the candidate or reject.
- **3 or fewer** — wrong layer for plugin. Read operations go to MCP (primary) or CLI (fallback). Write operations go to CLI (fallback only).

## Decision tree

Decision rules guide each scenario:

- Existing plugin covers the same hook → extend the existing plugin.
- Candidate addresses two concerns → split into two plugins.
- Candidate has no observable output → add `client.app.log()` or choose a different approach.
- Logic exceeds five lines → extract to `_lib/{module}.ts`.
- Rare or one-time trigger → choose a different approach — plugins start on every session.
- Plugin registers a tool → add companion skill at `skills/{name}/SKILL.md`.

## Gotchas

- Two hooks for complementary sources: Accept — complementary hooks cover different edit paths. See `PROT.PLUGIN.LIFECYCLE` hook matrix. (Plugin handles `file.edited` + `tool.execute.after` — different trigger sources, not the same event)
- Plugin registers tool, no skill: Add companion skill or convert to hooks-only pattern — remove tool registration. (`tool:` hook present, `skills/{name}/SKILL.md` absent)
- Silent plugin: Add structured logging on every execution path — success and failure both visible. (No `client.app.log()`, no file writes, no DB writes)
- Low-frequency trigger: Skip plugin. Low-frequency read: MCP or CLI. Low-frequency write: CLI or manual workflow. (`config`, `tool.definition`, or `dispose` as only hook)
- Plugin reads for display: Move data retrieval to MCP or CLI read-* tool per `PROT.PLUGIN.WRITE`. Plugin handles mutations only. (Handler SELECTs data alone, returns formatted results)
- Cross-plugin import: Extract shared logic to `_lib/` module. Both plugins import from `_lib/`. (`from "../plugins/other"` in plugin file)
- Plugin loads at startup with no work: Reject. Startup cost without session value burdens every session. (Plugin initializes DB and registers hooks. Fires zero times per session.)

## Enforcement

Peer review on new plugin PRs. Each new plugin documents which criteria it passes. Reviews check for scope creep — does the plugin do one thing clearly.

## Exception

Validation plugins (`PROT.PLUGIN.LIFECYCLE`) intentionally use two hooks (`file.edited` + `tool.execute.after`) to cover two distinct trigger sources: editor manual saves (`file.edited`) and agent tool execution (`tool.execute.after`). This is not a criterion-3 violation — each hook serves a different trigger source. The one-hook criterion addresses scope creep within a single trigger path; complementary hooks for different sources are the expected pattern.

## Applicability

Any `.opencode/plugins/` file across all projects. Before writing a new plugin file, run the seven-criteria evaluation.

## See also

- `PROT.TOOL.HOOKS` — general plugin lifecycle hooks
- `PROT.PLUGIN.LIFECYCLE` — validation plugin pattern (complementary hooks for different trigger sources)
- `PROT.PLUGIN.WRITE` — write-only constraint for plugin tools
- `REF.LIB.PURITY.BOUNDARY` — pure vs IO separation definitions
- `PROT.LIB.CONTRACT` — lib module contract declaration
- `PROT.TOOL.AUTOMATON` — tool and plugin automaton classification
- `CON.FS.WATCH` — filesystem-level event detection, distinct from plugin hooks
