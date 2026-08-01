---
id: ILL.LIB.BLOCK
title: "Contract Block — Module Declaration Walkthrough"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of declaring a lib module contract — exports, purity, and depends-on fields with concrete file paths."
illustration: "A new lib module gets its contract block at the top — three comment lines declaring exports, purity level, and dependencies."
illustrates: [PROT.LIB.CONTRACT]
tags: lib,module,contract,walkthrough,declaration,purity
related: [REF.LIB.PURITY.BOUNDARY, REF.LIB.DEPENDENCY]
---
## Rationale

A developer creates a new utility module in `_lib/` for formatting emulator details. The module needs to format emulator data for display. It receives structured data and returns strings — pure function, no I/O.

## Walkthrough

1. Choose the module location — `_lib/emulator-format.ts` under the root shared library directory.

2. Determine purity level by examining the module's operations. The module receives `EmulatorRow` objects and returns formatted strings. No database calls, no filesystem access, no network. Purity: `pure`.

3. Identify imports. The module imports only from builtins (`string` methods) or TypeScript types. No I/O module imports. Dependencies: `none`.

4. List exported functions — `formatEmulator`, `formatEmulatorDetail`.

5. Write the contract block at the top:

```
// exports: formatEmulator, formatEmulatorDetail
// purity: pure
// depends-on: none
```

6. Verify every import falls within the purity allowance matrix. Pure modules import only from other pure modules. The module imports nothing from `db.ts` or `ensure.ts`.

7. After writing, run `audit-lib` to confirm the contract block parses correctly and the import graph remains acyclic.

## Key insight

The contract block makes dependencies visible at a glance. A three-line comment at the top of the file answers every question a reader has: what does this module export, what purity level does it operate at, and what other modules does it depend on. The reader scans the contract block before reading any implementation.

## See also

- `PROT.LIB.CONTRACT` — concrete contract format examples
- `PROT.LIB.CONTRACT` — abstract contract rules
- `ILL.LIB.FORMAT.GAME` — pure format function walkthrough
- `REF.LIB.PURITY.BOUNDARY` — layer categorization
