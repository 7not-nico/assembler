---
id: PAT.ANCHORED.PATHS
title: Anchored Paths — Resolve from Self, Independent of Context
source: patlib
summary: Tools must resolve data file paths relative to their own location, not from context.worktree, which depends on a git repository.
principle: Every tool that reads or writes data files must anchor path resolution to its own location using import.meta.dir — context.worktree is unreliable outside git repositories.
enforcement: Convention
tags: [tooling, architecture, data-flow, paths, resolution, convention]
patterns: [PAT.DRY, PAT.ORTHOGONALITY, PAT.PLUGIN.IPC.TOOL, PAT.SHARED.LIB, PAT.PATH.DUALITY]
terms: []
status: active
priority: 4
---

Every tool that reads or writes data files must anchor path resolution to its own location using `import.meta.dir` — `context.worktree` is unreliable outside git repositories.

## Context

OpenCode agents run in non-git environments. `context.worktree` resolves only when a `.git` directory exists — it returns the workspace root. In git-less AMANDA projects, it's undefined. Using `import.meta.dir` from the tool's own location guarantees correct resolution regardless of version control state.

## Rules

- Use `import.meta.dir` to locate sibling directories from `.opencode/tools/`
- Never pass `context.worktree` to `join()` for data file resolution
- `.opencode/` is the anchor — tools resolve `..` from `.opencode/tools/`
- Consistent with `db.ts` which resolves `patlib.db` via `import.meta.dir`

## Applicability

All non-git projects — any environment where tools may run outside a git repository.

## See also

- PAT.DRY
- PAT.ORTHOGONALITY
- PAT.PLUGIN.IPC.TOOL
- PAT.SHARED.LIB
- PAT.PATH.DUALITY — complements anchored-to-self with subproject-relative routing
