---
id: ILL.SEED.FLOW
title: "Seed Pipeline Walkthrough — Compute-Execute Layer Split"
source: PROT.SCHEMA.FORMAT
summary: "Walk through a seed data insert: an MCP tool computes INSERT SQL after DDL validation, passes the SQL string to a plugin handler, which appends to the seed file and executes against the database."
illustration: "An agent inserts a new platform seed row via the two-layer pipeline — MCP compute validates DDL and generates SQL, plugin execute appends to seed file and runs INSERT"
illustrates: [NEX.SCHEMA.PIPELINE]
tags: schema,seed,pipeline,mcp,plugin,walkthrough
related: [PROT.SCHEMA.FORMAT, REF.SCHEMA.SEED.MUTATION, PAT.MCP.READONLY, PROT.PLUGIN.WRITE]
---
## Context

The ludoteca subproject has a `platforms` table with seed data in `.opencode/schemas/seeds/02-platforms.sql`. An agent needs to add `"PS5"` as a new platform. The seed pipeline splits the task into a compute phase (MCP, read-only) and an execute phase (plugin, write-only). The SQL string is the handoff boundary.

## Walkthrough

### Step 1: Compute layer (MCP, read-only)

The MCP tool `ludoteca_validate` inspects the DDL and generates the INSERT SQL:

```
patlib_get --id NEX.SCHEMA.PIPELINE
```

The agent reads the `platforms` DDL from schema:

```sql
CREATE TABLE platforms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  short TEXT NOT NULL UNIQUE,
  created TEXT DEFAULT (datetime('now'))
);
```

The MCP compute tool validates:
- `platforms` is a seed-managed table (present in seed registry)
- `name: PS5` passes the UNIQUE constraint check (no existing row)
- `short: ps5` passes format check (lowercase, no spaces)

It generates the INSERT SQL:

```sql
INSERT INTO platforms (name, short) VALUES ('PS5', 'ps5');
```

Output: the SQL string via `return { content: [{ type: "text", text: sql }] }`.

### Step 2: SQL string crosses the contract boundary

The MCP tool returns the SQL string. The agent inspects it before passing to the execute layer:

```
Generated SQL: INSERT INTO platforms (name, short) VALUES ('PS5', 'ps5');
Table: platforms
Seed file: .opencode/schemas/seeds/02-platforms.sql
```

The SQL string is the contract boundary per Protocol rule 4. Agent validates correctness before calling execute.

### Step 3: Execute layer (plugin, write-only)

The plugin handler `onSeedExecute` receives the SQL string and appends to the seed file:

```ts
export const SeedAppend = async function({ client }) {
  return {
    'tool.execute.after': async (event) => {
      if (event.tool === 'seed_insert' && event.args.table === 'platforms') {
        const sql = event.args.sql
        const seedPath = ".opencode/schemas/seeds/02-platforms.sql"
        
        // Safety check: verify table is seed-managed
        const seedTables = ["platforms", "genres", "publishers"]
        if (!seedTables.includes(event.args.table)) {
          return { error: "Table not in seed-managed list" }
        }
        
        // Append to seed file
        const file = Bun.file(seedPath)
        const existing = await file.text()
        const newContent = existing.trimEnd() + "\n" + sql + "\n"
        await Bun.write(seedPath, newContent)
        
        // Execute against database
        const db = new Database(".opencode/ludoteca.db")
        db.run(sql)
        
        client.app.log("info", `Seed appended: ${sql}`)
        return { success: true, rowsAffected: 1 }
      }
    }
  }
}
```

### Step 4: Verify

```
read-selection --query "PS5" --type terms
```

The platform `PS5` is now present in the database and in the seed file.

## Key insight

The compute-execute pipeline mirrors the broader MCP-read/plugin-write tier separation. The SQL string acts as an explicit, auditable contract boundary — the agent inspects compute output before calling execute. Compute handles correctness (DDL validation, constraint checks); execute handles safety (seed-managed table check, file append, DB run). Layer overlap excluded.

## See also

- `NEX.SCHEMA.PIPELINE` — the seed pipeline protocol this walkthrough illustrates
- `PROT.SCHEMA.FORMAT` — seed file format conventions
- `REF.SCHEMA.SEED.MUTATION` — seed file mutation strategy
- `PAT.MCP.READONLY` — MCP read-only contract (compute layer)
- `PROT.PLUGIN.WRITE` — plugin write-only contract (execute layer)
