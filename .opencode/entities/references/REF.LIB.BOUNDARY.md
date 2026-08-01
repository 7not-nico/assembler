---
id: REF.LIB.BOUNDARY
title: "Purity Boundary — Side Effects Define the Line"
source: PROT.LIB.CONTRACT
related: [PROT.LIB.DEPENDENCY.DIRECTION, PROT.LIB.CONTRACT]
summary: "A module is pure when it has no side effects — deterministic, referentially transparent. Impure modules do I/O (filesystem, database, network). Three purity levels: pure, impure DB, impure IO. Practical checklist for determining where a module sits."
ref: "A function is pure if it is deterministic and side-effect-free. Lib modules divide into three purity levels — pure (deterministic), impure DB (database access), impure IO (filesystem access). Each level has a fixed set of allowed imports. Pure modules are leaf nodes in the dependency graph."
tags: [lib, module, architecture, purity, dependency, convention, categorization]
---

The line between deterministic, side-effect-free functions and functions that perform I/O. Every lib module sits on one side.

## Protocol

Deterministic function: same arguments always produce the same return value. Referentially transparent (call can be replaced by its value). Operates on inputs only — filesystem, database, network, stdout, clock, and random calls excluded.

Has observable side effects:

| Side effect | Examples |
|-------------|----------|
| Filesystem | `readFileSync`, `writeFileSync`, `existsSync`, `readdirSync` |
| Database | `new Database(path)`, `.query()`, `.run()`, `.all()` |
| Network | `fetch()`, any HTTP call |
| stdout | `console.log`, `process.stdout.write` |
| Clock | `Date.now()`, `new Date()` |
| Random | `Math.random()`, `crypto.randomUUID` |

### Layer categorization

| Level | Meaning | Imports allowed | Example module |
|-------|---------|-----------------|----------------|
| `pure` | Deterministic, no I/O | Builtins or npm packages only | `string-utils.ts`, `validate-fields.ts`, `error-format.ts` |
| `impure (DB)` | Opens SQLite database | `db-paths.ts`, `bun:sqlite` | `db.ts` |
| `impure (IO)` | Reads/writes filesystem | `fs`, `path`, `db-paths.ts` | `frontmatter.ts`, `ensure.ts` |

The `db.ts` module excluded from `impure (IO)` imports. Subproject `lib/` follows the same pattern. These map to purity declarations in `PROT.LIB.CONTRACT`.

### Purity determination checklist

- Calls `new Database()`, `Bun.file()`, `fetch()`, or `console.log`? → impure
- Reads or writes files? → impure
- Calls another function that does any of the above? → impure (purity is transitive)
- None of the above? → pure

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Importing `db.ts` from a format or validate module | Import scan: format module has `from "./db"` | Pass data as parameters from a caller that opens the DB |
| Adding I/O to a pure module for convenience | Module with `// purity: pure` contains `existsSync` or similar | Extract the I/O to an impure module, inject results as parameters |
| Treating type-only imports as impure | `import type { Database }` flagged incorrectly | Type-only imports are erased at compile time — safe in pure modules. The runtime import, distinct from the type import, determines purity |
| Exporting interface as runtime value | `export { X } from './mod'` where X is an interface | Use `export type { X }` from — interfaces compile to zero runtime code, Bun rejects runtime interface re-exports |

## Enforcement

`audit-lib` walks every import in every lib module and verifies purity alignment per the direction rule in `PROT.LIB.DEPENDENCY.DIRECTION`.

When declaring a new module's purity level (`// purity: pure`, `// purity: db`, or `// purity: io`), confirm every import falls within the allowance matrix defined in `PROT.LIB.DEPENDENCY.DIRECTION`.

Data crossing from impure to pure follows the parameter-passing pattern specified in `PROT.LIB.DEPENDENCY.DIRECTION` — the impure caller opens the DB, queries, and passes results as function arguments.

## Applicability

Any `.opencode/lib/` module. Lib purity (deterministic vs I/O) is distinct from tool IO classification (recognizer, transducer, generator, signal). A recognizer tool only reads data — it calls `connect()` which is an impure lib function. This is by design: tools orchestrate impure operations; lib modules enforce purity boundaries.

## See also

- `PROT.LIB.DEPENDENCY.DIRECTION` — unidirectional dependency vector across the purity boundary
- `PROT.LIB.CONTRACT.VIOLATIONS` — antipattern catalog
- `PROT.LIB.CONTRACT` — the lib module contract, purity declarations
- `PROT.LIB.DIRECTORY.LAYER` — root `_lib/` vs subproject `lib/`
- `ILL.LIB.ENSURE.IO` — impure wrapper walkthrough
- `lib/ensure.ts` — validation helpers (impure, IO)
