---
id: ILL.TOOL.READ
title: "Read Handler — IO and Pure Separation in a Tool"
source: PROT.TOOL.DEFINITION
summary: "Walkthrough of creating a read handler for a tool — io handler reads from DB, pure format module returns structured data."
illustration: "A read-projection tool uses two modules: an io handler that queries the database and a pure format module that structures the response."
illustrates: [NEX.LIB.STACK]
tags: tool,handler,walkthrough,purity,io,read
related: [PROT.LIB.HANDLER, REF.LIB.PURITY.BOUNDARY, ILL.LIB.ENSURE.IO]
---
## Rationale

A tool needs to read entity projections from patlib. The tool handler must separate the database query (io) from the response formatting (pure). Two modules: one impure handler that queries, one pure formatter that structures.

## Walkthrough

1. Create the io handler at `_lib/projection-query.ts`. This module opens the database, executes a SELECT query, and returns raw rows.

```
// exports: queryEntity
// purity: db
// depends-on: db-paths
export function queryEntity(type: string, id: string): EntityRow {
  const db = connect()
  return db.query(
    'SELECT * FROM entities WHERE entity_type = ? AND entity_id = ?'
  ).get(type, id)
}
```

2. Create the pure format module at `_lib/projection-format.ts`. This module receives raw rows and structures them into a response map.

```
// exports: formatProjection
// purity: pure
// depends-on: none
export function formatProjection(row: EntityRow): Projection {
  return { id: row.entity_id, type: row.entity_type, title: row.title, body: row.body }
}
```

3. The tool orchestrator imports both modules. It calls `queryEntity()` to get the raw data, then `formatProjection()` to structure it. The tool file stays thin — imports, calls, returns.

```
import { queryEntity } from '../_lib/projection-query'
import { formatProjection } from '../_lib/projection-format'

export default tool({
  async execute(args) {
    const row = queryEntity(args.type, args.id)
    return formatProjection(row)
  }
})
```

4. Testing the pure format module requires no database setup — pass a mock row, assert the returned projection structure matches expectations.

## Key insight

The handler pattern creates three files with one concern each: the tool orchestrates (thin), the io handler queries (impure), the format module structures (pure). The separation makes the format module testable in isolation and the io handler replaceable without changing formatting logic.

## See also

- `NEX.LIB.STACK` — handler pattern
- `REF.LIB.PURITY.BOUNDARY` — purity definitions
- `ILL.LIB.ENSURE.IO` — impure wrapper walkthrough
- `ILL.LIB.FORMAT.GAME` — pure format function walkthrough
