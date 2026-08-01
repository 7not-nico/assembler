---
id: PROT.LIB.CONTRACT.FORMAT
title: "Module Contract — Declaration Format"
source: assembler
summary: "Contract block format for lib modules — the exact comment format and field requirements for exports, purity, and dependencies."
protocol: "Every lib module declares exports, purity level, and dependencies in a contract block at the top. The format uses // exports:, // purity:, // depends-on: comment lines. One concern per file."
enforcement: Convention
status: active
priority: 3
related: []
tags: [lib,module,purity,contract,convention,declaration]
---

Contract block format for lib modules. Abstract rules are in `PROT.LIB.CONTRACT`. This pattern documents the exact declaration format and field values.

## Contract format

Every lib module starts with a contract block in the first 5 lines:

```
// exports: {comma-separated export names}
// purity: {pure | db | io}
// depends-on: {none | module names}
```

### Field values

| Field | Values |
|-------|--------|
| `exports` | Comma-separated names of exported functions or values |
| `purity` | `pure` (deterministic), `db` (SQLite access), or `io` (filesystem access) |
| `depends-on` | `none` or comma-separated module names this module imports from |

## Applicability

Any `.opencode/lib/` module that needs a contract block. All root `_lib/` modules currently have contract blocks. New modules must follow the same format.

## See also

- `PROT.LIB.CONTRACT` — abstract contract rules
- `ILL.LIB.CONTRACT.BLOCK` — walkthrough of creating a contract block
- `PROT.LIB.PURITY.BOUNDARY` — purity definitions
- `PROT.LIB.DEPENDENCY.DIRECTION` — allowance matrix
