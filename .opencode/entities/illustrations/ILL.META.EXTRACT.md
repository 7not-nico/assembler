---
id: ILL.META.EXTRACT
title: "Domain Extraction — Shared Logic Bloat to Shared Lib"
source: PROT.META.IDENTITY
summary: "Walkthrough of extracting duplicated tool logic from two subprojects into a shared _lib/ module — demonstrating the logic bloat signal, sibling extraction, and parent-gets-leaner rules."
illustration: "Two subprojects each implement the same CSV parsing logic in their tools/. The duplicated code triggers the logic bloat signal: extract to _lib/csv.ts, sibling to both tool directories, then each tool imports from the shared module."
illustrates: [REF.META.DOMAIN.DIRECTORY]
tags: architecture,walkthrough,extraction,decoupling,lib,shared-logic
related: [REF.META.PROJECT.TOPOLOGY, REF.LIB.DIRECTORY.LAYER, MAX.CODE.DRY.PRINCIPLE]
---
## Rationale

The assembler organizes around cognitive boundaries. Five signals (reference density, logic bloat, domain emergence, conceptual weight, external necessity) each trigger a specific container type — from shared lib extraction to full sub-project spin-out. The container form follows the signal's nature.

Two subprojects (`ludoteca/` and `category-theory/`) each have a tool that parses CSV data. Both implement the same `parseCSV` function independently. The duplication triggers the logic bloat signal from PAT.META.DOMAIN.DIRECTORY.

## Before: duplicated logic

```
ludoteca/.opencode/tools/import-games.ts
  — contains: function parseCSV(text: string): string[][] { ... }

category-theory/.opencode/tools/import-definitions.ts
  — contains: function parseCSV(text: string): string[][] { ... }
```

Both functions are identical. Each is 30 lines. Maintenance requires fixing bugs in two places.

## Walkthrough

1. The duplicated `parseCSV` exceeds the bloat threshold — two copies of the same 30-line function across sibling projects.

2. Extract to sibling: create `_lib/csv.ts` at the parent level (`assembler/.opencode/_lib/`), sibling to both subproject `tools/` directories.

3. Each tool replaces its local `parseCSV` with `import { parseCSV } from '../_lib/csv'`.

## After: shared extraction

```
assembler/.opencode/_lib/csv.ts
  — exports function parseCSV(text: string): string[][]

ludoteca/.opencode/tools/import-games.ts
  — imports parseCSV from _lib (no local copy)

category-theory/.opencode/tools/import-definitions.ts
  — imports parseCSV from _lib (no local copy)
```

## Rules applied

| Rule | In this extraction |
|------|--------------------|
| Extract to sibling | `_lib/csv.ts` lives at `assembler/.opencode/_lib/`, sibling to both project `.opencode/tools/` directories |
| Container type follows origin | Logic bloat → shared lib (`_lib/`) |
| Parent gets leaner | Each tool shrinks by 30 lines; `_lib/csv.ts` owns the canonical implementation |
| Extraction is one-way | Future CSV parsing improvements happen in `_lib/csv.ts` only |
| Extract on signal | Bloat detected at duplication count ≥ 2 |

## Key insight

The logic bloat signal produced a sibling extraction (shared lib) rather than a sub-project spin-out (which would follow domain emergence). The container type followed the signal — shared code always goes to `_lib/`; new project directory excluded.

## See also

- `REF.META.DOMAIN.DIRECTORY` — the extraction pattern this illustrates
- `REF.LIB.DIRECTORY.LAYER` — mechanics of shared lib import paths
- `MAX.CODE.DRY.PRINCIPLE` — no duplication, always extract shared
- `REF.META.PROJECT.TOPOLOGY` — modularity principle; extraction preserves project independence
