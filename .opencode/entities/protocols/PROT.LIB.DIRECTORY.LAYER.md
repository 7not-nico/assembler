---
id: PROT.LIB.DIRECTORY.LAYER
title: "Lib Directory Layer — Root _lib/ vs Subproject lib/"
source: assembler
related: [PROT.LIB.CONTRACT, REF.LIB.DIRECTORY.LAYER]
summary: "Root tools import shared modules from .opencode/_lib/; subproject tools import from their own lib/. Each layer owns its dependency set."
protocol: "Root tools import from .opencode/_lib/ (shared lib modules). Subproject tools import from their own lib/. Subprojects keep their dependency declarations local. Cross-subproject shared code belongs in the root _lib/ layer."
enforcement: Convention
status: active
priority: 3
tags: [lib, directory, layer, structure, shared, subproject]
---

Two library layers carry the toolchain: the root `_lib/` and per-subproject `lib/`. Each layer declares its own dependencies and imports within its boundary.

## Protocol

1. **Root tools import from `../_lib/`** — shared lib modules live in `.opencode/_lib/`; root tools reference them relative.
2. **Subproject tools import from `lib/`** — subproject `.opencode/tools/` files import from `../lib/db` and siblings.
3. **Subprojects declare local dependencies** — each subproject's `package.json` carries its own dependency set.
4. **Shared behavior belongs in the root layer** — code used by two or more subprojects moves to `.opencode/_lib/`.
5. **Layers stay distinct** — a subproject imports from its own `lib/` or the root `_lib/`, never from another subproject's layer.

## Gotchas

- Subproject importing a sibling's module: move the shared behavior to the root `_lib/` layer.
- Root tool importing from a subproject `lib/`: reference the root `_lib/` equivalent instead.
- Dependency declared in the wrong layer: relocate the declaration to the layer that owns the module.

## Enforcement

Convention — the `audit-tool` skill and `REF.LIB.DIRECTORY.LAYER` reference define the layer layout. Review flags imports crossing layers.

## Applicability

Applies to tool and lib placement across the assembler root and its subprojects. Excluded: domain aggregator contents, which run their own repos and layer rules.

## See also

- `PROT.LIB.CONTRACT` — module shape and boundary declaration
- `REF.LIB.DIRECTORY.LAYER` — layer reference
- `PROT.TOOL.DEFINITION` — tool file shape
