---
id: PROT.PLUGIN.LIFECYCLE
title: "Validation Plugins — Pure Logic + Lifecycle Hooks for Data Integrity"
source: NEX.PLUGIN.LAYER
related: [PROT.TOOL.HOOKS, PROT.PERSON.SCHEMA]
summary: "Validation plugins separate pure detection logic (_lib/) from lifecycle hooks (plugins/). Logic is deterministic and testable; hooks trigger on editor file saves (file.edited) and agent tool execution (tool.execute.after)."
protocol: "Validation plugins: 1) Pure detection function in _lib/validate-{domain}.ts returns structured report. 2) Plugin in plugins/ imports logic, registers file.edited and/or tool.execute.after hooks. 3) Reports use client.app.log() with severity level. 4) Hooks-only — no tool: registration. 5) Companion skill omitted per PROT.TOOL.HOOKS §1."
enforcement: Formality
status: active
priority: 3
tags: [plugin, validation, integrity, convention, lifecycle, logging]
---

Pure logic in `_lib/`, lifecycle hooks in `plugins/`. Validation plugins separate detection from I/O.

## Protocol

1. **Layer separation** — pure detection function in `_lib/validate-{domain}.ts`. Excludes I/O and side effects. Accepts DB query results, returns structured `{ unused?, orphan?, ... }` report.

2. **Lifecycle hooks in plugins/** — plugin at `plugins/{domain}.ts` imports logic, wires hooks. Use `file.edited` for opencode editor manual saves. Use `tool.execute.after` for agent tool execution (Write, Bash, sync, validate).

3. **Hooks-only** — validation plugins register event hooks with no `tool:` registration. Companion skill omitted per PROT.TOOL.HOOKS §1.

4. **Structured logging** — use `await client.app.log({ body: { service, level, message } })` with levels:
   - `warn` — actionable violation (unused events, orphan refs)
   - `info` — advisory (lonely events, single-person consumers)
   - `error` — plugin failure (DB write error, unexpected exception)

5. **Shebang and console.log excluded** — per PROT.TOOL.HOOKS §4. Use `client.app.log()` for logging.

6. **@pluginclass annotation** — file header: `// @pluginclass TRNS`

## Schema

### Layer responsibilities

Two layers: Logic (`_lib/validate-{domain}.ts`, pure, accepts data and returns report) and Hooks (`plugins/{domain}.ts`, IO, inits DB, calls logic, logs results).

### Hook matrix

Two hooks: `file.edited` (opencode editor manual save, validate after human edit) and `tool.execute.after` (any agent tool execution, validate after agent-driven change).

### Hook scope notes

- `file.edited` fires on **opencode editor manual saves only**. Agent Write/Bash tool calls to entity files do NOT trigger this hook.
- `tool.execute.after` fires on **any agent tool execution**, including Write, Bash, and the sync/validate tool commands listed above.
- For filesystem-level change detection from any source (editor, agent, external tool), use `fs.watch` at the MCP server level. Plugin hooks cover only opencode-internal events.

### Report format

```typescript
Interface ValidationReport {
  violations: string[];
  advisories: string[];
}
```

## Enforcement

Defined by protocol convention — validation plugins follow the pattern established by existing plugin implementations. Audit via `audit-tool` scanning `plugins/` for `@pluginclass TRNS` + `_lib/validate-*` imports.

## See also

- `ILL.PLUGIN.VALIDATION.WATCH` — validation plugin walkthrough — event integrity setup
- `PROT.TOOL.HOOKS` — general plugin lifecycle hooks architecture
- `REF.LIB.PURITY.BOUNDARY` — pure vs IO separation pattern
- `PROT.PERSON.SCHEMA` — person event timeline, consumer of event validation
- `CON.FS.WATCH` — filesystem-level change detection, distinct from plugin hooks
