**Purity Protocol** — annotation convention for lib modules declaring their side-effect boundary. Every `.ts` file in `.opencode/lib/` carries a `// purity:` annotation with one of three levels, and a `// depends-on:` annotation listing internal dependencies with their declared purity.

## Levels

- **`pure`** — deterministic, I/O-free. Function output depends only on explicit inputs. Examples: `read-query.ts`, `format-*.ts`, `validate-*.ts`.
- **`io`** — manages its own I/O lifecycle (calls `connect()`/`close()`, reads filesystem, accesses `process`). Examples: `entity-search.ts`, `db.ts`, `frontmatter.ts`.
- **`db`** — receives a `Database` handle and executes queries on it. Connection lifecycle managed externally. A subset of io with explicit DB parameter. Examples: `validate-fk.ts`, `migrate.ts`, `verify-mcp-data.ts`.

## `depends-on` annotation

Format: `// depends-on: ./relative-path (purity), ./other-path (purity)`

Stdlib, external packages, and type-only imports stay outside the annotation. Only project-internal imports into `lib/` or `_lib/` are declared.

## Enforcement

The `verify-purity` tool enforces:
1. Every lib file includes `// purity:`
2. Every internal import has a matching `depends-on` entry
3. Every `depends-on` entry resolves with correct purity
4. `pure` modules depend only on other `pure` modules
5. Dependency graph stays acyclic
6. Every `depends-on` entry matches an actual import

## Example

```typescript
// purity: io
// depends-on: ./db (io), ./read-entities (pure), ./read-query (pure)
import { connect, initDB, queryRows } from "./db"
import { getEntityMeta } from "./read-entities"
import { buildEntityQuery } from "./read-query"
```

## See also

- `REF.LIB.PURITY.BOUNDARY` — layer categorization and purity checklist
- `ILL.LIB.ENSURE.IO` — impure wrapper walkthrough

---

id: TERM.PURITY.PROTOCOL
title: Purity Protocol
source: CON.DECOUPLING
tags: [lib, purity, convention, architecture, module, annotation]
related: [TERM.LIB.MODULE]
reference:
  - title: verify-purity tool
    url: https://github.com/eddyr/assembler/tree/main/one-timers/ludoteca/.opencode/tools/verify-purity.ts
---
