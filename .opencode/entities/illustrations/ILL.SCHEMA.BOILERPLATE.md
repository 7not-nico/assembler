---
id: ILL.SCHEMA.BOILERPLATE
title: "Schema Plugin Boilerplate Walkthrough — Using Shared I/O for a Seed Transformation"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of creating a schema plugin using shared boilerplate — pure transformation function, shared I/O layer, standard tool interface."
illustration: "A new schema plugin needs to rename a column in seed files. The agent creates only a pure transformation function and registers it with the shared I/O layer and standard tool interface."
illustrates: [REF.SCHEMA.PLUGIN.BOILERPLATE]
tags: schema,plugin,walkthrough,boilerplate,seed
related: [PROT.SCHEMA.FORMAT, PROT.TOOL.HOOKS]
---
## Rationale

Shared boilerplate eliminates copy-paste — one I/O layer serves all schema plugins. Pure transformation functions are independently testable without file system setup. Consistent tool interface reduces agent confusion across schema operations. Uniform result format enables scriptable batch operations.

A new schema plugin needs to rename a column in seed files — changing `genre` to `category` across all INSERT statements. The shared boilerplate lib already provides file I/O, seed-directory resolution, and hook registration. The agent writes only the pure transformation function.

## Walkthrough

### Step 1: Write the pure transformation function

The transformation function receives a file's content as a string and returns the modified content. No file I/O, no side effects:

```
function renameGenreToCategory(content: string): string
```

The function uses a regex or string replacement to find INSERT lines containing `genre` and replace with `category`.

### Step 2: Import from shared I/O layer

The shared lib exports:
- `readSeedFile(path)` — reads a seed file as string
- `writeSeedFile(path, content)` — writes modified content back
- `getSeedDir()` — resolves the seed directory path
- `isSeedFile(path)` — checks file extension and directory

The plugin imports these functions rather than implementing its own file operations.

### Step 3: Create the tool with standard interface

The plugin exposes a tool with three standard arguments:
- `file` — single-file operation: transform one seed file
- `all` — batch mode: transform all seed files
- `dryRun` — preview: show changes without writing

Per rule 3, every schema plugin follows this interface.

### Step 4: Register the auto-correction hook

The plugin registers a `file.edited` hook that guards for `.sql` extension and seed-directory path. When a seed file is edited and saved in the opencode editor, the hook checks whether it contains the old column name and applies the transformation automatically.

Scope note: `file.edited` fires on opencode editor saves only. Agent Write/Bash tool edits to seed files do NOT trigger this hook. For agent-driven seed edits, register a companion `tool.execute.after` handler that checks the same guard conditions. The two hooks serve complementary trigger sources — see `PROT.PLUGIN.LIFECYCLE` hook matrix.

Per rule 4, the hook fires only when the target file extension and directory match.

### Step 5: Verify uniform result format

Single-file operation returns `renamed: 02-seed.sql`. Batch mode returns `3/5 file(s) renamed.` — two files skipped because they had no `genre` column.

Per rule 5, the result format is consistent across all schema plugins.

## Key insight

The boilerplate pattern reduces each new schema plugin to a single pure function plus registration. The shared I/O layer handles all filesystem interaction. Adding a new schema operation means writing 10 lines of transformation logic plus 10 lines of plugin registration — the boilerplate stays unchanged.

## See also

- `REF.SCHEMA.PLUGIN.BOILERPLATE` — the boilerplate pattern this illustrates
- `PROT.SCHEMA.FORMAT` — seed file format enforced by these plugins
- `PROT.TOOL.HOOKS` — plugin hook registration, tool definition
