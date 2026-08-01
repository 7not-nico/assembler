---
id: PAT.PURITY.BOUNDARY
title: Purity Boundary — Side Effects Define the Line
source: assembler
summary: A module is pure when it has no side effects. Same input, same output every time. Impure modules do I/O (filesystem, database, network). The boundary determines dependency direction.
principle: A function is pure if it is deterministic and side-effect-free. An impure function performs observable I/O. Pure modules depend only on other pure modules.
enforcement: Convention (audit-lib tool)
tags: [lib, module, architecture, purity, dependency, convention]
patterns: [PAT.LIB.CONTRACT, PAT.LIB.GOTCHA, PAT.SHARED.LIB]
terms: []
status: active
priority: 3
---

**Purity Boundary** — the line between deterministic, side-effect-free functions and functions that perform I/O. Every lib module sits on one side. Pure modules depend only on other pure modules.

## Definition

**Pure function** — deterministic, no observable side effects. Same arguments always produce the same return value. Referentially transparent (call can be replaced by its value). No I/O of any kind.

**Impure function** — has observable side effects. Examples:

| Side effect | Examples |
|-------------|----------|
| Filesystem | `readFileSync`, `writeFileSync`, `existsSync`, `readdirSync` |
| Database | `new Database(path)`, `.query()`, `.run()`, `.all()` |
| Network | `fetch()`, any HTTP call |
| stdout | `console.log`, `process.stdout.write` |
| Clock | `Date.now()`, `new Date()` |
| Random | `Math.random()`, `crypto.randomUUID` |

## Why purity matters

1. **Testability** — pure functions need no setup, no mocks, no fixtures. Pass args, assert return value.
2. **Reasoning** — pure functions have no hidden state. Read the signature, understand behavior.
3. **Dependency direction** — pure modules depend on nothing. Impure modules depend on pure modules. Reverse is never allowed — a pure module importing an impure module breaks determinism.

## Purity levels in ludoteca

| Level | Meaning | Imports allowed | Example module |
|-------|---------|-----------------|----------------|
| `pure` | Deterministic, no I/O | Builtins or npm packages only | `string-utils.ts`, `validate-fields.ts`, `error-format.ts` |
| `impure (DB)` | Opens SQLite database | `db-paths.ts`, `bun:sqlite` | `db.ts` |
| `impure (IO)` | Reads/writes filesystem | `fs`, `path`, `db-paths.ts` (not `db.ts`) | `frontmatter.ts`, `ensure.ts` |

These map to the purity declarations in `PAT.LIB.CONTRACT`.

## The boundary rule

A pure module imports only modules declared as pure. The `audit-lib` tool checks this — it walks every import in every lib module and verifies purity alignment.

When adding a new lib module:
1. Declare its purity level using a comment block: `// purity: pure`, `// purity: db`, or `// purity: io`
2. List every import. For each imported module, confirm the import is allowed per the purity level table above
3. If a pure module needs data from the database, extract the impure operation into a separate module and pass the data as a parameter

## Determining purity in practice

Checklist for any lib function:

- Does it call `new Database()`, `Bun.file()`, `fetch()`, or `console.log`? → impure
- Does it read or write files? → impure
- Does it call another function that does any of the above? → impure (purity is transitive)
- None of the above? → pure

## Gotchas

1. **Importing `db.ts` from a `format-*` or `validate-*` module** — breaks determinism. Formatting functions that touch the database cannot be tested without a live DB. *Fix: pass data as parameters from a caller that opens the DB.*
2. **Adding I/O to a pure module for "convenience"** — the one small `existsSync` check today becomes a full DB query tomorrow. *Fix: extract the I/O to an impure module, inject results as parameters.*
3. **Treating type-only imports as impure** — `import type { Database } from "bun:sqlite"` is erased at compile time and carries no runtime side effects. These are safe in pure modules. *Exception: `ensure.ts` uses both type-only and runtime imports — the runtime `existsSync` call is what makes it impure.*

## Tools purity is a separate dimension

Lib purity (deterministic vs I/O) is distinct from tool IO classification (recognizer, transducer, generator, signal). A `recognizer` tool only reads data — but it calls `connect()` which is an impure lib function. This is by design: tools orchestrate impure operations, lib modules enforce purity boundaries.

## See also

- PAT.LIB.CONTRACT — the lib module contract, purity declarations
- PAT.LIB.GOTCHA — antipatterns to avoid
- PAT.SHARED.LIB — root _lib/ vs subproject lib/
- `lib/ensure.ts` — validation helpers (impure, IO)
