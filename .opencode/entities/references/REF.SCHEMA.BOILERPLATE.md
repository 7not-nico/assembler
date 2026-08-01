---
id: REF.SCHEMA.BOILERPLATE
title: "Schema Plugin Utils — Shared Boilerplate for Seed Operations"
source: PROT.SCHEMA.AUGMENT
summary: "Schema plugins operating on seed files share a common boilerplate layer. File I/O, path resolution, and hook registration come from a shared lib module. Only the transformation function is plugin-specific."
ref: "Extract file I/O, seed-directory resolution, file-edited hook registration, and standard tool interface into a shared lib module. Schema plugins import those functions rather than implementing their own."
related: []
tags: [schema, plugin, boilerplate, pattern]
---

Schema plugins that read, transform, and write seed files share common infrastructure. Extract that infrastructure into a single lib module. Each plugin then provides only a pure transformation function.

## Rules

1. **Shared I/O layer** — file read, file write, directory iteration, and seed-directory path resolution belong in one lib module. Schema plugins import those functions rather than implementing their own I/O.
2. **Pure transformation function** — the core logic of each schema plugin is a pure string-in, string-out function. Side effects: excluded from the transformation function.
3. **Standard tool interface** — expose a tool with three arguments: `file` for single-file operation, `all` for batch mode, `dryRun` for preview mode.
4. **Auto-correction hook** — register a `file.edited` hook that guards for the target file extension and seed-directory path before applying the transformation. Scope note: `file.edited` fires on opencode editor saves only. For agent Write/Bash tool calls, register a companion `tool.execute.after` handler. See `PROT.PLUGIN.LIFECYCLE` hook matrix for trigger source disambiguation.
5. **Uniform result format** — per-file operations return `"{verb}: {filename}"`. Batch operations return `"{changed}/{total} file(s) {verb}."`.

## Limitations

- Assumes single-line value tuples. Multi-line tuple formats require skip logic in the I/O layer.
- Shared I/O layer requires the lib module to be impure, which constrains its dependency graph per lib module conventions.

## Applicability

Any project with multiple schema plugins operating on seed `.sql` files.

## See also

- `ILL.SCHEMA.PLUGIN.BOILERPLATE` — walkthrough of creating a schema plugin with shared I/O
- `PROT.SCHEMA.FORMAT` — seed file format enforced by these plugins
- `PROT.TOOL.HOOKS` — plugin hook registration, tool definition
- `PROT.LIB.PURITY.BOUNDARY` — pure vs impure separation
