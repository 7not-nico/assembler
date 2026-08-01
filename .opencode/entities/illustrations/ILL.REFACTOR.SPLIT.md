---
id: ILL.REFACTOR.SPLIT
title: "Refactor Early, Refactor Often — Splitting a Growing Module Before It Hardens"
source: PROT.TOOL.HOOKS
summary: "A sync module grows past 300 lines with three distinct responsibilities. The agent refactors at the first sign of bloat — splits into sync-read, sync-write, and sync-validate before the structure hardens."
illustration: "A single sync.ts module handles read, write, and validate — 300 lines, three concerns. The agent splits it into sync-read.ts, sync-write.ts, and sync-validate.ts at the first sign of structural decay, before downstream consumers depend on the monolithic shape."
illustrates: [MAX.REFACTOR.EARLY.OFTEN]
tags: walkthrough,refactor,split,module,structure,maintainability
related: [MAX.BROKEN.WINDOW.CASCADE, MAX.CODE.DRY.PRINCIPLE, MAX.CODE.ORTHOGONALITY.PRINCIPLE]
---
## Context

`MAX.REFACTOR.EARLY.OFTEN` says to refactor at the first sign of structural decay. A `sync.ts` module starts as a clean 80-line file. Over three iterations, it grows to 300 lines with three interleaved responsibilities: reading entities from `.md` files, writing them to the DB, and validating the write results. The first sign of bloat: a bug fix in the validation logic requires tracing through read and write code paths.

## Walkthrough

### Step 1: Identify the structural decay

The module exports three main functions:

```ts
export function readEntities(type: string): Entity[] { ... }
export function writeEntities(entities: Entity[]): void { ... }
export function validateWrite(type: string): ValidationResult { ... }
```

The file is 300 lines. `validateWrite` imports internal helpers from `readEntities` that are not exported. `writeEntities` has inline SQL that duplicates logic from `readEntities`. Each function shares internal state through mutable module-level variables.

Signs of decay:
- Three concerns in one module (read, write, validate)
- Internal state shared through module scope
- Inline SQL duplicated across read and write paths
- A bug fix in validate required reading read+write code

### Step 2: Split immediately — before consumers depend on the shape

The agent splits before any downstream tool imports from sync.ts directly. Three new files:
```ts
import { readFile } from "fs/promises";
import { parseFrontmatter } from "./parse";

export function readEntities(type: string): Entity[] { ... }
```
```ts
import { Database } from "bun:sqlite";

export function writeEntities(entities: Entity[]): void { ... }
```
```ts
import { readEntities } from "./sync-read";
import { Database } from "bun:sqlite";

export function validateWrite(type: string): ValidationResult { ... }
```

### Step 3: Extract shared SQL into a query module

The SQL that was duplicated across read and write moves to `lib/sync-queries.ts`:

```ts
export const SELECT_ENTITIES = "SELECT id, title, body FROM entities WHERE type = ?";
export const UPSERT_ENTITY = "INSERT OR REPLACE INTO entities ...";
```

### Step 4: Verify each module is single-responsibility

| Module | Responsibility | Lines |
|--------|---------------|-------|
| `sync-read.ts` | Read entities from markdown files | 60 |
| `sync-write.ts` | Write entities to DB | 50 |
| `sync-validate.ts` | Validate write results | 40 |
| `sync-queries.ts` | Shared SQL constants | 10 |

Each module is under 60 lines. Each does one thing.

### Step 5: Result

The next iteration adds a new entity type. The change touches only `sync-read.ts` (add a parser case) and `sync-queries.ts` (add a query). No cascade — the orthogonality check passes.

## Key insight

Refactoring at 300 lines cost 20 minutes. Refactoring at 500 lines (when three downstream consumers import from sync.ts) would cost hours — each consumer would need import path updates, and the internal state sharing would require a compatibility shim. The exponential cost curve is real: early refactoring cost is the module's size; deferred refactoring cost includes every consumer's coupling.

## See also

- `MAX.REFACTOR.EARLY.OFTEN` — the maxim this illustrates
- `MAX.BROKEN.WINDOW.CASCADE` — an un-refactored module invites more structural decay
- `MAX.CODE.DRY.PRINCIPLE` — extracted SQL queries replace duplicated inline SQL
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — each split module does one thing
