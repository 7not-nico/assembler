---
id: ILL.TRACER.PATH
title: "Tracer Bullets Walkthrough — Building a read-game Tool End-to-End"
source: NEX.TOOL.CHOICE
summary: "Walk through building a read-game tool as a tracer bullet: write the thinnest bun shell script printing JSON to stdout, validate the path works, then layer schema validation, error handling, and MCP server wrapper."
illustration: "An agent builds a ludoteca read-game tool as a tracer bullet — thin shell script first, validate with Halo query, then add shebang, CLI args, schema validation, and MCP wrapper incrementally"
illustrates: [PAT.TRACER.BULLETS.PRACTICE]
tags: workflow,prototyping,iteration,walkthrough,tracer
related: [PROT.PLUGIN.CANDIDATE.SCORING, PROT.TOOL.MODEL]
---
## Rationale

The ludoteca subproject needs a tool to query games by name. The end-to-end path (database query → formatted output) is the uncertain part — the schema, database connection, and query format require validation before adding structure.

## Walkthrough

### Step 1: Thinnest path — inline script

The agent writes the minimal working path:

```bash
bun -e "
import { Database } from 'bun:sqlite'
const db = new Database('.opencode/ludoteca.db')
const rows = db.query('SELECT * FROM games WHERE name LIKE ?').all('%Halo%')
console.log(JSON.stringify(rows))
"
```

This is the tracer bullet — one command, one query, one output format. No shebang, no CLI args, no error handling.

### Step 2: Validate the path works

```bash
bun -e "...above..." 
```

Output:

```
[{"id":1,"name":"Halo: Combat Evolved","platform":"Xbox"},{"id":7,"name":"Halo 3","platform":"Xbox 360"}]
```

The path works. The tracer bullet validates the database connection, query syntax, and JSON serialization.

### Step 3: Layer — shebang and file

The agent moves the script to a proper file:

```ts
#!/usr/bin/env bun
import { Database } from "bun:sqlite"
const db = new Database(".opencode/ludoteca.db")
const rows = db.query("SELECT * FROM games WHERE name LIKE ?").all("%Halo%")
console.log(JSON.stringify(rows))
```

Invocation: `bun run .opencode/tools/read-game.ts`. The file is the retained tracer bullet — it grows and persists.

### Step 4: Layer — CLI argument

The hardcoded `Halo` becomes a parameter:

```ts
#!/usr/bin/env bun
import { Database } from "bun:sqlite"
const name = process.argv[2] || "Halo"
const db = new Database(".opencode/ludoteca.db")
const rows = db.query("SELECT * FROM games WHERE name LIKE ?").all(`%${name}%`)
console.log(JSON.stringify(rows))
```

### Step 5: Layer — error handling

Add guard for missing argument:

```ts
const name = process.argv[2]
if (name === undefined) { console.error("Usage: read-game <name>"); process.exit(1) }
```

### Step 6: Layer — MCP wrapper

After the CLI tool stabilizes, an MCP server wraps the query for agent use:

```ts
server.tool(
  "ludoteca_search",
  { query: z.string() },
  async ({ query }) => {
    const db = new Database(".opencode/ludoteca.db")
    const rows = db.query("SELECT * FROM games WHERE name LIKE ?").all(`%${query}%`)
    return { content: [{ type: "text", text: JSON.stringify(rows) }] }
  }
)
```

The tracer bullet pattern: the original thin script evolved through 5 layers, each added only after the previous layer worked.

## Key insight

The tracer bullet approach prevents premature structuring. The thinnest path validates the uncertain part (DB query, format) before any scaffolding (shebang, args, error handling, MCP). Each layer adds production quality while the core path remains unchanged — the bullet grew, retained throughout.

## See also

- `PAT.TRACER.BULLETS.PRACTICE` — the tracer bullet pattern this walkthrough illustrates
- `PROT.PLUGIN.CANDIDATE.SCORING` — scoring criteria that determine when tool warrants plugin layer
- `PROT.TOOL.MODEL` — CLI vs IPC format (tracer bullet starts as CLI, wraps as IPC or MCP)
