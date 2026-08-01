---
id: PROT.TOOL.DEFINITION
title: "Custom IPC Tool — Auto-Discovered OpenCode Tools"
source: NEX.TOOL.CHOICE
related: []
summary: "OpenCode custom tools defined via @opencode-ai/plugin tool() helper, auto-discovered from .opencode/tools/."
protocol: "Every tool uses export default tool({...}) with typed args schema via tool.schema, returns a string from execute(). One direction per tool: read-only OR write-only. crashOnError() at top of every execute()."
enforcement: Formality
status: active
priority: 3
tags: [tooling, architecture, opencode, convention, ipc, plugin]
---

Every tool uses `export default tool({...})` with typed args schema, returning a string from `execute()`. Custom IPC Tool is the target architecture for **root-level** agent tools. Project-level tools use MCP (primary read layer) or Plugin (primary write layer) per `PROT.TOOL.MODEL`.

## Protocol

1. **Use `export default tool({...})`** — auto-discovered by OpenCode IPC from `.opencode/tools/`. Replaces `export default function` + `process.argv` checks.
2. **Describe the tool and each arg with `.describe()`** — the LLM reads these descriptions to understand what the tool does and what each parameter expects.
3. **Define all args with `tool.schema`** — Zod types provide type safety at the schema layer and LLM-readable parameter definitions.
4. **Return a string from `execute()`** — the LLM reads the return value as tool output. String return is the only output channel.
5. **Import shared module from `../lib/db` (subproject) or `../_lib/db` (root)** — follows the lib import path convention per `REF.LIB.DIRECTORY.LAYER`.
6. **Import only from `_lib/` or `../lib/`** — tools import from shared library modules. Cross-tool logic extracts to a new lib module.
7. **Keep `@opencode-ai/plugin` in `.opencode/package.json`** — required dependency for all Custom IPC tools.
8. **Serve one direction per tool** — each tool reads OR writes data. A tool that queries a DB and writes results violates this rule. Split into separate read and write tools.
9. **Place `crashOnError()` from `errors.ts` at top of every `execute()`** — before any DB or filesystem operation. Guarantees the tool reports failures to the LLM.

## Gotchas

- Missing `crashOnError()` in execute body: Add `crashOnError()` as first call inside `execute()` — before any DB or filesystem operation (Search for `crashOnError` — absent from `execute()` function)
- Bare `.string()` or `.number()` without `.describe()`: Add `.describe("what this arg expects")` — the LLM reads descriptions to populate each arg (Schema arg call without `.describe()` following it)
- `console.log` or `console.error` in tool file: Use `return` to pass output to the LLM — `console.log` output is invisible to the tool caller (Search for `console.` in tool source)
- Shebang line still present: Remove shebang line — Custom IPC tools are auto-discovered; CLI invocation excluded (Line 1 starts with shebang marker)
- Tool reads and writes in same `execute()`: Split into two tools — one read-only (RECG), one write (TRNS or GENR) (`db.query(...).all()` and `db.query(...).run()` both appear in the same function)
- Schema `.default()` without `??` fallback: Apply `??` at point of use — `.default()` documents expected value for LLM, runtime fallback uses `??` (`.default()` used in schema but handler uses bare arg)
- SQLite params passed to `.query()` instead of result method: Pass bindings to `.all()`, `.get()`, or `.run()` — `.query()` accepts SQL string only (`db.query("SELECT ?", val)` — extra arg silently ignored)

## Enforcement

`audit-tool` verifies each file: `export default tool({...})` present, `crashOnError()` called, `.describe()` on every arg, `console.log` absent, shebang excluded, import paths correct, read/write separation. Run `audit-tool` on each push.

## Migration

Convert Shebang CLI or Hybrid tools to Custom IPC Tool following this table:

Migration follows a one-to-one mapping per element:

- Bun shebang on line 1 → remove the line.
- `export default function name()` → `export default tool({...})`.
- `console.log(x)` → `return x`.
- `process.argv` parsing → typed `args` schema.
- CLI self-check block → remove the block.

## Applicability

All AMANDA systems with `.opencode/tools/`. New tools must use Custom IPC Tool. Existing Shebang CLI and Hybrid tools should migrate on next edit.

## See also

- `ILL.TOOL.CUSTOM.CREATE` — step-by-step tool creation walkthrough
- `PROT.TOOL.DEFINITION` — schema defaults need runtime `??` fallback
- `REF.LIB.DIRECTORY.LAYER` — lib import path convention used by tools
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — principle underlying read/write separation
- `PAT.MCP.READONLY` — MCP read-only contract, the read tier for Custom IPC Tool counterparts
- `PROT.PLUGIN.WRITE` — plugin write-only contract, the write tier for Custom IPC Tool counterparts
