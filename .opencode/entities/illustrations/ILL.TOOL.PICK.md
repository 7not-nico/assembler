---
id: ILL.TOOL.PICK
title: "Tool Invocation Walkthrough — Shebang CLI Promotion to Custom IPC"
source: PROT.TOOL.DEFINITION
summary: "Walk through a subproject read-game tool written as Shebang CLI, then promoted to root Custom IPC Tool — demonstrating audience-based choice, lib extraction, and I/O prefix naming."
illustration: "A ludoteca read-game tool starts as Shebang CLI for humans; agent requirements emerge, shared logic extracts to lib/, the tool promotes to root Custom IPC Tool format"
illustrates: [PROT.TOOL.MODEL]
tags: tooling,invocation,cli,ipc,walkthrough,shebang,promotion
related: [PROT.TOOL.DEFINITION, NEX.TOOL.CHOICE, REF.LIB.PURITY.BOUNDARY]
---
## Context

The ludoteca subproject has a tool for querying games by name. Initially written for human terminal use, it uses Shebang CLI format. Later, an agent needs the same query. Following the invocation model, the tool promotes to Custom IPC Tool at root level. The model provides a clear migration path — extract lib, preserve CLI, add IPC.

## Walkthrough

### Step 1: Shebang CLI in subproject

The initial tool lives at `one-timers/ludoteca/.opencode/tools/read-game.ts`:

```ts
#!/usr/bin/env bun
import { Database } from "bun:sqlite"

const name = process.argv[2]
if (name === undefined) { console.error("Usage: read-game <name>"); process.exit(1) }

const db = new Database(".opencode/ludoteca.db")
const rows = db.query("SELECT * FROM games WHERE name LIKE ?").all(`%${name}%`)
console.log(JSON.stringify(rows, null, 2))
```

Features:
- Line 1: `#!/usr/bin/env bun` — shebang for `bun run`
- `process.argv[2]` — human passes name as CLI argument
- `console.log` — output to stdout for terminal reading
- Permissions: `rw-r--r--` (644)

Invocation: `bun run one-timers/ludoteca/.opencode/tools/read-game.ts "Halo"`

### Step 2: Agent requirements emerge

The agent needs to call `read-game` during research workflows. Shebang CLI works via `bash` tool while `export default tool({...})` provides schema validation and structured returns.

Per the protocol rule 6: **Promote rather than duplicate**.

### Step 3: Extract shared logic to lib

The DB query logic moves to the subproject's shared lib:

```ts
// one-timers/ludoteca/.opencode/lib/game-queries.ts
import { initDB } from "./db"

export function queryGames(name: string) {
  const db = initDB()
  return db.query("SELECT * FROM games WHERE name LIKE ?").all(`%${name}%`)
}
```

The Shebang CLI now wraps the lib function:

```ts
#!/usr/bin/env bun
import { queryGames } from "../lib/game-queries"
const name = process.argv[2]
if (name === undefined) { console.error("Usage: read-game <name>"); process.exit(1) }
console.log(JSON.stringify(queryGames(name), null, 2))
```

### Step 4: Promote to root Custom IPC Tool

A new root-level tool at `assembler/.opencode/tools/read-game.ts`:

```ts
import { tool } from "@opencode-ai/plugin"
import { queryGames } from "../../one-timers/ludoteca/.opencode/lib/game-queries"

export default tool({
  name: "read-game",
  description: "Query games by name from ludoteca database",
  args: { name: { type: "string", description: "Game name search term" } },
  execute: async ({ name }) => {
    return JSON.stringify(queryGames(name))
  }
})
```

Differences from Shebang version:
- No shebang → `export default tool({...})`
- No `process.argv` → typed `args` schema
- No `console.log` → `return` string
- Auto-discovered by OpenCode filesystem scan
- Root location: `assembler/.opencode/tools/` — subproject `tools/` excluded for IPC format

### Step 5: Both audiences served

| Audience | Tool | Invocation |
|----------|------|------------|
| Human | Shebang CLI (subproject) | `bun run .../tools/read-game.ts "Halo"` |
| Agent | Custom IPC (root) | Agent calls `read-game` with `{name: "Halo"}` |

Both use the same `queryGames()` lib function. The CLI prefix `read-` signals read-only I/O direction per protocol rule 7.

## Key insight

The two invocation formats serve two different consumers — humans (Shebang CLI, terminal output) and agents (Custom IPC, structured return). The promotion path (Shebang CLI → lib extraction → Custom IPC) prevents duplication while serving both. The prefix naming (`read-*`, `write-*`, `audit-*`) makes I/O direction discoverable from filename alone.

## See also

- `PROT.TOOL.MODEL` — the invocation model this walkthrough illustrates
- `PROT.TOOL.DEFINITION` — Custom IPC Tool format and architecture
- `NEX.TOOL.CHOICE` — layer choice decision flow
- `REF.LIB.PURITY.BOUNDARY` — purity tiers for lib modules
- `PROT.TOOL.AUTOMATON` — automata I/O model for tools
