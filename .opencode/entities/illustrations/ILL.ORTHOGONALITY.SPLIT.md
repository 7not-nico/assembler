---
id: ILL.ORTHOGONALITY.SPLIT
title: "Orthogonality — Splitting a Multi-Concern Tool"
source: PROT.TOOL.AUTOMATON
summary: "A read-selection tool both queries the DB and formats output. The agent splits it — one tool reads, one tool formats. Shared lib holds the query logic."
illustration: "A composite read tool queries patlib.db and formats markdown output. The agent splits read from format, extracts the query builder into lib/, and leaves both tools independent."
illustrates: [MAX.CODE.ORTHOGONALITY.PRINCIPLE]
tags: walkthrough,orthogonality,split,refactor,separation,lib
related: [MAX.CODE.DRY.PRINCIPLE, PROT.TOOL.DEFINITION, REF.LIB.DIRECTORY.LAYER]
---
## Context

`MAX.CODE.ORTHOGONALITY.PRINCIPLE` says each tool does one thing. A `read-selection` tool both queries the SQLite DB and formats results as markdown tables. Changing the format (e.g., to JSON) requires modifying the same tool that queries — two concerns coupled in one entry point. Adding a new output format means touching the query tool. The orthogonality metric (files touched per feature) is 1 — but it should be 0 for unrelated concerns.

## Walkthrough

### Step 1: Identify the coupling

The tool handler has two responsibilities:

```ts
// read-selection.ts
export default async function (args: Args) {
  const rows = db.query(sql).all();       // concern A: query
  const table = formatMarkdown(rows);      // concern B: format
  return { content: table };
}
```

Changing the query (add a join) and changing the format (switch to JSON) both require edits in `read-selection.ts`. The concerns are coupled.

### Step 2: Extract shared query logic into lib

The SQL builder and query execution move to `.opencode/lib/query-patlib.ts`:

```ts
// lib/query-patlib.ts
export function queryEntities(type: string, filter: Filter) {
  const sql = buildQuery(type, filter);
  return db.query(sql).all() as EntityRow[];
}
```

Now `read-selection.ts` is a thin shell:

```ts
import { queryEntities } from "../lib/query-patlib";

export default async function (args: Args) {
  const rows = queryEntities(args.type, args.filter);
  return { content: formatMarkdown(rows) };
}
```

### Step 3: Create the formatter tool

A new `format-output` tool depends on the same lib:

```ts
// tools/format-output.ts
import { queryEntities } from "../lib/query-patlib";

export default async function (args: Args) {
  const rows = queryEntities(args.type, args.filter);
  return { content: JSON.stringify(rows, null, 2) };
}
```

### Step 4: Verify orthogonality

The orthogonality check: how many files change when adding JSON format support?

- Before split: 1 file (`read-selection.ts`) — but the change is in an unrelated concern
- After split: 1 new file (`format-output.ts`) — no changes to existing tools

### Step 5: Each tool now does one thing

- `read-selection` → queries + formats as markdown (legacy bundling, migrated over time)
- `format-output` → queries + formats as JSON (new, serves JSON consumers)
- `lib/query-patlib` → shared query logic (neither tool's concern)

The long-term fix: both tools call the same lib, and when `read-selection` drops markdown support, a pure formatter tool replaces it.

## Key insight

A tool that reads and formats does two things. The shared query layer (lib) is the orthogonal separation: query logic lives once, both tools import it. Changing the format mechanism never touches the query. Adding a new format creates a new file — no cascading changes. The orthogonality metric stays 0 for unrelated concerns.

## See also

- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — the maxim this illustrates
- `MAX.CODE.DRY.PRINCIPLE` — shared lib replaces duplicated query logic
- `PROT.TOOL.DEFINITION` — tool shape conventions
- `REF.LIB.DIRECTORY.LAYER` — lib structure for shared components
