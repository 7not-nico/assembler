---
id: REF.LIB.RESOLUTION
title: "Path Resolution — Absolute for Static Sources, Relative for Subproject Data"
source: PROT.LIB.CONTRACT
related: []
summary: "Two resolution strategies coexist — anchor static source paths to the tool's own location via import.meta.dir; route subproject data paths as relative offsets from PATLIB_ROOT."
ref: "Static source paths (schemas, DBs, directory constants) resolve via import.meta.dir from the tool's own location. Subproject data paths resolve as relative offsets from PATLIB_ROOT. Two resolution modes, one guiding question: is this a source bound to the tool, or data that moves with the project?"
tags: [tooling, architecture, paths, resolution, portability, convention]
---

Static source paths anchor to the tool's own location. Subproject data paths stay relative to assembler root.

## Protocol

1. **Resolve static source paths via `import.meta.dir`** — schemas, DB files, and directory constants use `findRoot('_lib/db.ts')` walking up from `import.meta.dir` looking for a unique marker file. This guarantees CWD-independent and session-independent resolution.
2. **Route subproject data paths as relative offsets from `PATLIB_ROOT`** — `join(PATLIB_ROOT, args.path)` for file write and read targets. Paths stay relative to assembler root, preserving portability across machines and environments.
3. **Set `PATLIB_ROOT` once from the anchor, treat as immutable** — anchored constants are grouped in `_lib/db.ts`. Downstream tools import derived constants, reconstruct paths via `join(PATLIB_ROOT, ...)` only.
4. **Document path resolution strategy per tool** — tools accepting a `--path` arg document "relative to assembler root" in their parameter description.
5. **Use `import.meta.dir` for data file resolution instead of `context.worktree`** — `context.worktree` resolves only when a `.git` directory exists. In git-less projects, it is undefined. `import.meta.dir` from the tool's own location resolves correctly regardless of version control state.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Using `process.cwd()` for static paths | Tool resolves paths via `process.cwd()` | Use `join(import.meta.dir, '..', '..')` — anchored to tool, independent of CWD |
| Hardcoded absolute path for subproject data | Path contains `/home/eddyr/assembler/...` or similar | Use `join(PATLIB_ROOT, "relative/path")` — portable, stays within assembler root |
| Using `context.worktree` for path resolution | Tool resolves paths via `context.worktree` | Use `import.meta.dir` anchored resolution — `context.worktree` fails outside git repos |
| Mixing both resolution strategies in one path constant | Same variable used for both static anchors and subproject data | Separate into distinct categories — `_lib/db.ts` for static anchors, tool args for subproject paths |
| `import.meta.dir` resolution fails when tools loaded from ancestor directory | OpenCode virtualizes module path to session directory; simple `join(import.meta.dir, '..')` resolves to wrong root | Walk up from `import.meta.dir` looking for unique marker file — works from any session context: root, subproject, or ancestor |

## Enforcement

`audit-tool` scans tool files for path resolution patterns. It flags `process.cwd()`, `context.worktree`, and hardcoded absolute paths. It verifies that anchored constants are grouped in `_lib/db.ts` rather than reconstructed per tool. Run `audit-tool` on each push.

## Applicability

Every tool under `assembler/.opencode/tools/` that resolves filesystem paths — read tools, write tools, audit tools. Root `_lib/` modules that set path constants.

## See also

- `PROT.LIB.DIRECTORY.LAYER` — `_lib/` vs `lib/` distinction
- `PROT.TOOL.DEFINITION` — tool structure that uses path resolution for DB and file access
- `PROT.META.PROJECT.TOPOLOGY` — modular, each project is independent
- `MAX.CODE.DRY.PRINCIPLE` — single authoritative representation for path constants
