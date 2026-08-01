---
id: PROT.TOOL.AUTOMATON
title: "Tool and Plugin Classification — Automata Theory I/O Model"
source: NEX.TOOL.CHOICE
related: [PROT.PLUGIN.WRITE]
summary: "Tool and plugin I/O behavior classified into four automata models — RECG (read-only), TRNS (separate tapes), GENR (write-only), SGNL (read-write coordination) — declared inline via // @toolclass or // @pluginclass at line 1."
protocol: "Every tool and plugin has an I/O automaton model. Tools declare via // @toolclass <CODE>; plugins declare via // @pluginclass <CODE>. Root-level MCP tools use RECG (read-only). Subproject MCP tools may use RECG or TRNS. Plugins use GENR (write-only). Both at line 1, parsed by audit-tool."
enforcement: Formality
status: active
priority: 2
tags: [tooling, architecture, automata, classification, convention]
---

Every tool and plugin has an I/O automaton model. Tools declare via `// @toolclass <CODE>`; plugins declare via `// @pluginclass <CODE>`. Both at line 1.

## Protocol

1. **Every tool and plugin belongs to exactly one of four classes** — RECG (acceptor), TRNS (transducer), GENR (generator), SGNL (synchronizer). The class determines memory, directionality, and I/O behavior.
2. **RECG tools are read-only** — they inspect data, decide membership, and return a result. No writes to persistent state.
3. **TRNS tools have separate input and output tapes** — they read source data and write transformed data. Input and output refer to different data domains.
4. **GENR tools are write-only** — they produce output from internal state or parameters alone. No reads from persistent state.
5. **SGNL tools read and write shared state** — they coordinate by inspecting and updating a common store. Read-write within a single execution.
6. **Tools declare at line 1** — `// @toolclass <CODE>` on the first line of every `.opencode/tools/*.ts` file. Imports and blank lines before it are violations.
7. **Plugins declare at line 1** — `// @pluginclass <CODE>` on the first line of every `.opencode/plugins/*.ts` file. Same position, same enforcement.
8. **Classification orthogonal to deployment layer** — RECG, TRNS, GENR, SGNL describe I/O behavior independent of deployment mechanism. CLI, IPC, MCP, Plugin, and Script are deployment layers. Any automaton class maps to any deployment layer, subject to tier constraints:
    - **Root-level MCP tools use RECG** (read-only) — root services are shared infrastructure, writes require transaction boundaries.
    - **Subproject MCP tools may use RECG or TRNS** — subprojects own their data domain and may expose controlled write operations (download, register) via MCP when paired with a fallback CLI tool.
    - **Plugin tools use GENR** (write-only per `PROT.PLUGIN.WRITE`).
    - **CLI and Custom IPC tools accept all four classes**.
    - **Script tools use RECG** (read-only per `SPEC.CODE.RING.TOPOLOGY`) — atomic audits inspect state and report.
   Choose deployment per audience and scope per `PROT.TOOL.MODEL`; the I/O model remains constant.
9. **Use `audit-tool` to enforce classification coverage** — run after creating or editing any tool or plugin file.
10. **Generate a manifest from annotations** — `.opencode/manifests/tools.md` may be generated from `// @toolclass` and `// @pluginclass` annotations for documentation.

## Gotchas

- No `// @toolclass` on tool: Add `// @toolclass <CODE>` as line 1 (Tool file line 1 lacks `// @toolclass`)
- No `// @pluginclass` on plugin: Add `// @pluginclass <CODE>` as line 1 (Plugin file line 1 lacks `// @pluginclass`)
- `// @pluginclass` on tool file: Use `// @toolclass` for tool files (Tool file has `// @pluginclass` instead of `// @toolclass`)
- `// @toolclass` on plugin file: Use `// @pluginclass` for plugin files (Plugin file has `// @toolclass` instead of `// @pluginclass`)
- Tool/plugin classified as TRNS; reads and writes same data: Classify as SGNL instead — SGNL coordinates (Same read and write targets within handler)
- Classified as RECG; writes to persistent state: Reclassify as TRNS or SGNL (`// @toolclass RECG` with `db.query(...).run()` or `writeFileSync`)
- Classified as GENR; reads from DB: Reclassify as TRNS or SGNL (`// @pluginclass GENR` with `db.query(...).all()`)
- Invalid class code used: Use one of the four valid codes (Code outside RECG, TRNS, GENR, SGNL)
- Root-level MCP tool classified as RECG uses write operations: Move write operations to a plugin or reclassify as TRNS for subproject MCP. (`// @toolclass RECG` with `db.run()` or `writeFileSync` in root MCP handler)
- Subproject MCP tool classified as TRNS; reads and writes same data domain: Classify as TRNS — separate I/O tapes within same subproject domain (Reads and writes operate on the same subproject data)
- MCP handler executes SELECT then INSERT: Split into two tools: RECG for the SELECT, TRNS for the INSERT (Handler reads data then writes the result)
- Plugin classified as GENR executes SELECT-only returns: Plugins are write-only per `PROT.PLUGIN.WRITE`. Move the query to MCP or CLI `read-*`. (`// @pluginclass GENR` with pure SELECT returning data to caller)

## Enforcement

`audit-tool` reads line 1 of every `.opencode/tools/*.ts` and `.opencode/plugins/*.ts` file. It verifies `// @toolclass <CODE>` for tools and `// @pluginclass <CODE>` for plugins. Flags missing annotations, annotation-vs-directory mismatches, invalid codes, and behavioral mismatches. Run `audit-tool` on each push.

## Migration

Tools created before the classification requirement must have `// @toolclass <CODE>` added before the next `audit-tool` run. Undefined classes produce a warning. The former `toolclass.db` has been removed — classification is now file-local.

## Applicability

All tools (`.opencode/tools/*.ts`) and plugins (`.opencode/plugins/*.ts`) within the AMANDA ecosystem. Each layer uses its own annotation prefix with the same four-class automaton model.

## See also

- `CON.TOOLCLASS.AUTOMATON` — definitions of the four automaton classes
- `PROT.TOOL.DEFINITION` — Custom IPC tool structure
- `PROT.TOOL.HOOKS` — plugin lifecycle hooks, receive `// @pluginclass`
- `PROT.SKILL.PROFILE` — analogous state classification for skills
- `MAX.CODE.DRY.PRINCIPLE` — every piece of knowledge has one authoritative representation
- `PROT.PLUGIN.WRITE` — plugin write-only contract, plugins use GENR (write-only)
- `PROT.TOOL.COMPOSITE` — category theory model; classification identity serves as the morphism identity
- `NEX.ACQUIRE.BIORXIV.PIPELINE` — bioRxiv acquisition workflow, subproject MCP using TRNS classification
