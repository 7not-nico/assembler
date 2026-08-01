---
id: PROT.TOOL.STRUCTURE
title: "Plugin Structure — Directory, Export Pattern, Concerns, Imports"
source: NEX.PLUGIN.LAYER
related: [PROT.TOOL.HOOKS, PROT.TOOL.DEFINITION]
summary: "Plugin files live in .opencode/plugins/{name}.ts. Named async function exports, no export default. Each plugin addresses one behavioral axis. Context destructuring uses project, client, $, directory, worktree. Imports from _lib/ (root) or lib/ (subproject). Filename: lowercase-kebab-case, 2-60 chars."
protocol: "Plugins reside in .opencode/plugins/{name}.ts (project-level) or ~/.config/opencode/plugins/{name}.ts (global). Named async function exports — export default excluded. Export count: 1-5 per file. Filename: lowercase-kebab-case, .ts extension, 2-60 characters. One behavioral axis per plugin. Context parameters: project, client, $, directory, worktree. Imports from _lib/ (root) or lib/ (subproject). File size under 200 lines. Hook handlers under 80 lines."
enforcement: Formality
status: draft
priority: 3
tags: [tooling, architecture, opencode, convention, plugin, structure, directory]
---

Plugin files, export patterns, context conventions, and import rules for opencode plugins.

## Protocol

1. **Plugin directory** — project-level plugins at `.opencode/plugins/{name}.ts`. Global plugins at `~/.config/opencode/plugins/{name}.ts`. npm plugins declared in `opencode.json` `"plugin"` array auto-install at startup. Plugin filenames use lowercase-kebab-case with `.ts` extension. Filename length between 2 and 60 characters.

2. **Named export pattern** — each file exports one or more async functions returning a hooks object. Export count stays between 1 and 5 named functions per file:
   ```ts
   export const MyPlugin = async function({ project, client, $, directory, worktree }) {
     return { /* hooks */ }
   }
   ```
   `export default` excluded. Filename determines plugin identity.

3. **Context destructuring** — plugin receives `{ project, client, $, directory, worktree }`. Use `client.app.log()` for structured logging (levels: debug, info, warn, error). Use `$` for shell commands via Bun's shell API. Context destructuring uses the exact parameter names listed. Hook handler functions stay under 80 lines. Test count matches hook count per plugin.

4. **One concern per plugin** — each plugin addresses one behavioral axis: intercept bash execution, inject env vars, register domain-specific tools, or handle session events. Split cross-concern logic into separate plugin files.

5. **Import from `_lib/` or `lib/`** — plugins at root level import from `_lib/` modules, same convention as Custom IPC tools and MCP servers per `REF.LIB.DIRECTORY.LAYER`. Subproject plugins import from that project's `lib/` instead. Plugin imports stay in `lib/` modules. Cross-plugin and tool-file imports use their own layer. File size stays under 200 lines including gotchas table.

## Gotchas

- Plugin file in `.opencode/tools/` instead of `.opencode/plugins/`: Move to `.opencode/plugins/` — plugins have their own directory (Export is named function; `export default tool({})` absent)
- Plugin attempts long-running background work: Extract to MCP server for read-heavy long-running work. Plugin stays valid for write-heavy or event-driven long-running work per `PROT.TOOL.MODEL`. (Blocking `await` or `setInterval` in hook handler)

## Enforcement

`audit-tool` scans `.opencode/plugins/` — verifies named export pattern, no `export default`, no shebang. Flags files exceeding 200 lines or exporting more than 5 functions.

## See also

- `PROT.TOOL.HOOKS` — plugin lifecycle registry
- `PROT.TOOL.HOOKS` — companion skills, tool registration, behavior interception
- `PROT.TOOL.DEFINITION` — alternative layer for stateless tools
- `REF.LIB.DIRECTORY.LAYER` — _lib/ vs lib/ import convention
- `TERM.OPENCODE.PLUGIN` — opencode plugin term definition
