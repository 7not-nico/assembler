---
id: PROT.LIB.PURITY
title: "Purity Boundary — Layer Categorization and Checklist"
source: assembler
summary: "Concrete layer categorization and purity checklists for lib modules — pure, impure DB, impure IO levels with example modules and determination steps."
protocol: "Lib modules divide into three purity levels — pure (deterministic), impure DB (database access), impure IO (filesystem access). Each level has a fixed set of allowed imports. A practical checklist determines where a module sits."
enforcement: Convention
status: active
priority: 3
related: []
tags: [lib,module,purity,convention,layer,categorization]
---

Concrete layer categorization for lib modules. Abstract purity definitions are in `PROT.LIB.PURITY.BOUNDARY`. This pattern documents the three-level split with example modules and a practical determination checklist.

## Layer categorization

| Level | Meaning | Imports allowed | Example module |
|-------|---------|-----------------|----------------|
| `pure` | Deterministic, no I/O | Builtins or npm packages only | `string-utils.ts`, `validate-fields.ts`, `error-format.ts` |
| `impure (DB)` | Opens SQLite database | `db-paths.ts`, `bun:sqlite` | `db.ts` |
| `impure (IO)` | Reads/writes filesystem | `fs`, `path`, `db-paths.ts` | `frontmatter.ts`, `ensure.ts` |

The `db.ts` module excluded from `impure (IO)` imports. These map to the purity declarations in `PROT.LIB.CONTRACT`.

## Purity determination checklist

- Calls `new Database()`, `Bun.file()`, `fetch()`, or `console.log`? → impure
- Reads or writes files? → impure
- Calls another function that does any of the above? → impure (purity is transitive)
- None of the above? → pure

## Applicability

Any `.opencode/lib/` module where purity level needs determination. Root `_lib/` and subproject `lib/` both follow the same three-level split.

## See also

- `PROT.LIB.PURITY.BOUNDARY` — abstract purity definitions and side-effect rules
- `PAT.LIB.DEPENDENCY.DIRECTION` — unidirectional dependency vector across the purity boundary
- `PROT.LIB.CONTRACT` — module contract format with purity declarations
- `ILL.LIB.ENSURE.IO` — walkthrough of ensuring an impure function stays behind the boundary
- `ILL.LIB.FORMAT.GAME` — walkthrough of a pure format function separated from I/O
