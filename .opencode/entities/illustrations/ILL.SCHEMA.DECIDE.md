---
id: ILL.SCHEMA.DECIDE
title: "Schema Ownership Decide — Three-Condition DB Criterion"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of deciding whether a subproject needs its own .db using the three-condition ownership criterion."
illustration: "A new subproject stores domain query results that survive across sessions, need structured joins and filters, and are separate from patlib infrastructure. All three conditions met — create the .db."
illustrates: [REF.SCHEMA.DATABASE.OWNERSHIP]
tags: schema,ownership,walkthrough,decision,database,criterion
related: [REF.SCHEMA.DATABASE.PRAGMA, REF.LIB.MUTATION.STRATEGY, ILL.SCHEMA.PRAGMA.CONFIGURE]
---
## Context

A new subproject tracks tool invocation metrics. The data includes tool name, invocation timestamp, and result status. The project needs to decide whether this data earns its own `.db` file or should be stored elsewhere.

## Walkthrough

1. Check condition (a): data survival across tool invocations. The metrics must persist beyond a single session — each invocation contributes a row that later invocations query. Condition met.

2. Check condition (b): structured query requirement. The project needs to `SELECT` metrics by tool name, `JOIN` with tool metadata, and `GROUP BY` for aggregation reports. Flat files with manual grep would not suffice. Condition met.

3. Check condition (c): domain-specific data separate from cross-project infrastructure. The metrics are specific to this project — they do not belong in `patlib.db` (which stores architecture). Condition met.

4. All three conditions met. Create the `.db` file with an `initDB()` call in the project's `lib/db.ts`.

```ts
export function initDB(): Database {
  const db = new Database("metrics.db")
  db.exec("PRAGMA journal_mode=WAL")
  db.exec("PRAGMA foreign_keys=ON")
  db.exec(/* DDL */)
  return db
}
```

5. If condition (b) fails (no structured querying needed), use flat files instead. If condition (c) fails (data belongs to patlib), store in `patlib.db` instead. If condition (a) fails (ephemeral), keep in memory.

## Key insight

The `.db` file is justified by the data's need for persistent structured querying. A tool that runs once and produces results that no future tool reads does not need a `.db`. A tool that accumulates records over days and joins across them does. The three conditions together prevent both over-engineering (DB for config) and under-engineering (flat files for queryable data).

## See also

- `REF.SCHEMA.DATABASE.OWNERSHIP` — abstract DB ownership rules
- `REF.SCHEMA.DATABASE.PRAGMA` — PRAGMA configuration
- `ILL.SCHEMA.PRAGMA.CONFIGURE` — PRAGMA setup walkthrough
- `REF.LIB.MUTATION.STRATEGY` — append vs upsert for project DB tables
