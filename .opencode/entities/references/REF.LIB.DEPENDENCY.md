---
id: REF.LIB.DEPENDENCY
title: "Dependency Direction — Allowance Matrix"
source: PROT.LIB.CONTRACT
summary: "Allowance matrix for the impure-depends-on-pure rule — what imports each purity level permits."
ref: "Dependencies flow unidirectionally from impure to pure. The allowance matrix makes the vector explicit: pure modules import only from other pure modules. Impure modules import from any module."
related: []
tags: [lib,module,purity,dependency,convention,matrix]
---

Allowance matrix for the impure-depends-on-pure rule. Abstract rules are in `PROT.LIB.DEPENDENCY.DIRECTION`.

## Allowance matrix

| Import from | Import to pure | Import to impure |
|-------------|---------------|-----------------|
| Pure        | ✓             | —               |
| Impure      | ✓             | ✓               |

The `—` in the upper-right cell marks the excluded direction. Pure modules import only from pure modules.

## Applicability

Any `.opencode/lib/` directory where modules declare `// purity:` tags. Root `_lib/` and subproject `lib/` follow the same matrix.

## See also

- `PROT.LIB.DEPENDENCY.DIRECTION` — abstract direction rules
- `PROT.LIB.PURITY.BOUNDARY` — purity definitions
- `ILL.LIB.FORMAT.GAME` — walkthrough of a pure format function
- `ILL.LIB.ENSURE.IO` — walkthrough of an impure wrapper
