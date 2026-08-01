---
id: PAT.PLUGIN.VALIDATION
Title: "Validation Plugins — Pure Logic + Lifecycle Hooks for Data Integrity"
Source: assembler
Related: [PROT.TOOL.HOOKS, PROT.LIB.PURITY.BOUNDARY, PROT.PERSON.ENTITY]
Summary: "Validation plugins separate pure detection logic (_lib/) from lifecycle hooks (plugins/). Logic is deterministic and testable; hooks trigger on file edits and tool execution."
Protocol: "Validation plugins: 1) Pure detection function in _lib/validate-{domain}.ts returns structured report. 2) Plugin in plugins/ imports logic, registers file.edited and/or tool.execute.after hooks. 3) Reports use client.app.log() with severity level. 4) Hooks-only — no tool: registration. 5) Companion skill omitted per PROT.TOOL.HOOKS §1."
Enforcement: Convention
Status: active
Priority: 3
Tags: [plugin, validation, integrity, convention, lifecycle, logging]
---

Pattern for data integrity checks that run automatically on relevant events. Pure logic in `_lib/`, lifecycle hooks in `plugins/`.

## Protocol

1. **Layer separation** — pure detection function in `_lib/validate-{domain}.ts`. Excludes I/O and side effects. Accepts DB query results, returns structured `{ unused?, orphan?, ... }` report.

2. **Lifecycle hooks in plugins/** — plugin at `plugins/{domain}.ts` imports logic, wires hooks. Use `file.edited` for file-change triggers. Use `tool.execute.after` for post-sync triggers.

3. **Hooks-only** — validation plugins register event hooks with no `tool:` registration. Companion skill omitted per PROT.TOOL.HOOKS §1.

4. **Structured logging** — use `await client.app.log({ body: { service, level, message } })` with levels:
   - `warn` — actionable violation (unused events, orphan refs)
   - `info` — advisory (lonely events, single-person consumers)
   - `error` — plugin failure (DB write error, unexpected exception)

5. **Shebang and console.log excluded** — per PROT.TOOL.HOOKS §4. Use `client.app.log()` for logging.

6. **@pluginclass annotation** — file header: `// @pluginclass TRNS`

## Schema

### Layer responsibilities

| Layer | File pattern | Purity | Responsibility |
|-------|-------------|--------|----------------|
| Logic | `_lib/validate-{domain}.ts` | Pure | Accept data, return report |
| Hooks | `plugins/{domain}.ts` | IO | Init DB, call logic, log results |

### Hook matrix

| Hook | Trigger | Use case |
|------|---------|----------|
| `file.edited` | Seed or entity file saved | Validate after manual edit |
| `tool.execute.after` | write-sync or read-validate | Validate after automated sync |

### Report format

```typescript
Interface ValidationReport {
  violations: string[];
  advisories: string[];
}
```

## Rationale

- Pure/logic separation enables testability without DB — `_lib/validate-events.ts` and `_lib/validate-refs.ts` import no `bun:sqlite`
- Lifecycle hooks catch violations at edit time, before propagation to consumers
- Hooks-only avoids companion skill requirement per PROT.TOOL.HOOKS §1
- Structured logging via `client.app.log()` keeps output in opencode's log stream, separate from tool output

## Enforcement

Defined by protocol convention — validation plugins follow the pattern established by existing plugin implementations. Audit via `audit-tool` scanning `plugins/` for `@pluginclass TRNS` + `_lib/validate-*` imports.

## See also

- `ILL.PLUGIN.VALIDATION.WATCH` — validation plugin walkthrough — event integrity setup
- `PROT.TOOL.HOOKS` — general plugin lifecycle hooks architecture
- `PROT.LIB.PURITY.BOUNDARY` — pure vs IO separation pattern
- `PROT.PERSON.ENTITY` — person event timeline, consumer of event validation
- `plugins/audit-events.ts` — event usage validation plugin
- `plugins/ref-integrity.ts` — entity reference integrity plugin
- `_lib/validate-events.ts` — pure logic for event usage detection
- `_lib/validate-refs.ts` — pure logic for orphan ref detection
