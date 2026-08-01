---
id: ILL.LIB.PATH
title: "Lib Resolve Path — Static and Data Path Resolution"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of path resolution for a tool — static source paths via import.meta.dir, subproject data paths via PATLIB_ROOT."
illustration: "A read-projection tool needs its patlib.db path. Static anchor: _lib/db.ts finds PATLIB_ROOT via import.meta.dir walking up for a marker file. Data path: join(PATLIB_ROOT, args.path)."
illustrates: [REF.LIB.PATH.RESOLUTION]
tags: lib,path,resolution,walkthrough,import.meta.dir
related: [REF.LIB.DIRECTORY.LAYER, PROT.TOOL.DEFINITION, ILL.TOOL.HANDLER.READ]
---
## Context

A `read-projection` tool needs to open `patlib.db` and read a file from a subproject path. The tool must resolve both paths correctly regardless of current working directory or git repository state.

## Walkthrough

1. The static anchor path (`patlib.db`) resolves via `import.meta.dir` in `_lib/db.ts`. The `findRoot()` function walks up from the tool's location looking for a unique marker file.

```ts
function findRoot(marker: string): string {
  let dir = import.meta.dir
  while (dir !== '/') {
    if (existsSync(join(dir, '.opencode', marker))) return dir
    dir = dirname(dir)
  }
  return join(import.meta.dir, '..', '..')
}
```

2. `PATLIB_ROOT` is set once from the anchor and treated as immutable. All downstream tools import derived constants from `_lib/db.ts` rather than reconstructing paths.

```ts
export const PATLIB_ROOT = findRoot('_lib/paths.ts')
export const DB_PATH = join(PATLIB_ROOT, "patlib.db")
```

3. The subproject data path resolves as a relative offset from `PATLIB_ROOT`. The tool accepts a `--path` argument documented as "relative to assembler root."

```ts
const dataPath = join(PATLIB_ROOT, args.path)
```

4. The tool handler uses both paths: `DB_PATH` for the database connection, `dataPath` for file read or write.

## Key insight

Two resolution strategies, one guiding question: is this a source bound to the tool, or data that moves with the project? Static anchors use `import.meta.dir` walking up for a marker — survives any launch directory. Subproject data uses `PATLIB_ROOT` offsets — portable across machines. `context.worktree` is excluded — it depends on `.git` directory existence.

## See also

- `REF.LIB.PATH.RESOLUTION` — abstract path resolution rules
- `REF.LIB.DIRECTORY.LAYER` — root _lib/ vs subproject lib/ convention
- `ILL.TOOL.HANDLER.READ` — read handler walkthrough
