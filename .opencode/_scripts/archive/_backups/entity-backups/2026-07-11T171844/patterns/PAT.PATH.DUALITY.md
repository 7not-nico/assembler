---
id: PAT.PATH.DUALITY
title: Path Duality — Absolute for Static Sources, Relative for Subproject Data
source: assembler
summary: Two resolution strategies coexist — anchor static source paths to the tool's own location via import.meta.dir; route subproject data paths as relative offsets from PATLIB_ROOT. Distinguish by context; is it a source bound to the tool, or data that moves with the project?
principle: Static source paths (schemas, DBs, directory constants) resolve via import.meta.dir — absolute from the tool's own location. Subproject data paths resolve as relative offsets from PATLIB_ROOT — preserving subproject portability across machines and environments.
enforcement: Convention
tags: [tooling, architecture, paths, resolution, portability, convention]
patterns: [PAT.ANCHORED.PATHS, PAT.ASSEMBLER.ARCHITECTURE, PAT.SHARED.LIB]
terms: []
status: active
priority: 4
---

## Context

Subprojects under `assembler/` are portable — they move between machines, archives, and workspaces. Their data paths must be relative offsets from assembler root, not absolute filesystem locks. Tools that fetch static sources (schemas, DBs, directory indices) must resolve independently of CWD — anchoring to the tool's own location via `import.meta.dir`.

Two resolution modes, one guiding question: *is this a source bound to the tool, or data that moves with the project?*

## Strategies

| Context | Resolver | Guarantee |
|---------|----------|-----------|
| Static source fetch — schema SQL, DB files, directory constants | `findRoot('_lib/db.ts')` — walk up from `import.meta.dir` looking for unique marker | CWD-independent + session-independent. Survives any launch directory AND ancestor tool loading |
| Subproject data routing — args.path, file write/read targets | `join(PATLIB_ROOT, args.path)` | Portable. Paths stay relative to assembler root |

Example — `_lib/db.ts`:
```typescript
function findRoot(marker: string): string {
  let dir = import.meta.dir
  while (dir !== '/') {
    if (existsSync(join(dir, '.opencode', marker))) return dir
    dir = dirname(dir)
  }
  return join(import.meta.dir, '..', '..') // fallback
}

export const PATLIB_ROOT = findRoot('_lib/db.ts')
// PATLIB_ROOT: absolute from marker file location, survives virtualized module paths
// DB_PATH / SCHEMA_PATH: derived via join(PATLIB_ROOT, ...)

// subproject path: join(PATLIB_ROOT, args.path) → relative from root
```

## Rules

- Static source paths: `import.meta.dir` for anchor derivation. `PATLIB_ROOT` is set once from the anchor and never mutated.
- Subproject data paths: relative from `PATLIB_ROOT`. Tools accepting a `--path` arg document "relative to assembler root" in their parameter description.
- `process.cwd()`: excluded for static path resolution — CWD changes with OpenCode launch context; resolution must survive any invocation directory.
- Hardcoded absolute filesystem paths: excluded for subproject data — they break portability when the project moves. Use `PATLIB_ROOT` + relative offset instead.
- Anchored constants (`DB_PATH`, `SCHEMA_PATH`, `PATTERNS_DIR`): grouped in `_lib/db.ts` so downstream tools import derived constants, never reconstruct paths independently.

## Gotchas

| Violation | Consequence | Redirect |
|-----------|-------------|----------|
| `process.cwd()` for static paths | CWD-dependent resolution; fails when OpenCode launches from subproject | `join(import.meta.dir, '..', '..')` — anchored to tool, independent of CWD |
| Hardcoded absolute path for subproject data (e.g., `"/home/eddyr/assembler/..."`) | Breaks on other machines or after relocation | `join(PATLIB_ROOT, "relative/path")` — portable, stays within assembler root |
| Mixing both resolution strategies in the same path constant | Reader cannot tell if the path is tool-bound or project-data | Separate categories: `_lib/db.ts` for static anchors, tool args for subproject paths |
| `import.meta.dir` for static paths when tools loaded from ancestor `.opencode/tools/` | OpenCode virtualizes module path to session directory; `join(import.meta.dir, '..', '..')` resolves to wrong root | Walk up from `import.meta.dir` looking for unique marker file (e.g., `_lib/db.ts`). Works from any session context — root, subproject, or ancestor |

## Applicability

Every tool under `assembler/.opencode/tools/` that resolves filesystem paths — read tools, write tools, audit tools. Root `_lib/` modules that set path constants.

## See also

- PAT.ANCHORED.PATHS — established anchored-to-self principle; this pattern extends with subproject-relative corollary
- PAT.ASSEMBLER.ARCHITECTURE — modular, each project is independent
- PAT.SHARED.LIB — `_lib/` vs `lib/` distinction
