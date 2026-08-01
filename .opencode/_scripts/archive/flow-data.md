---
description: Show data flow of .opencode tools
subtask: true
---

Show data flow for `$ARGUMENTS`

1. Read all `.ts` files in `.opencode/tools/` and `.opencode/_lib/`
2. For each tool — trace imports: which `_lib/` module, which DB (`patlib.db` or `mcp-search.db`), direction (read/write/filesystem)
3. Present shared library modules with their exports

```
db.ts      — initDB(), initMCPDB(), queryAll(), queryOne() — opens DBs, runs schema, parameterized queries
parse.ts   — FRONTMATTER_RE, BACKMATTER_RE, normalizeArray, normalizeReferences — YAML extraction from .md
sync.ts    — parsePatternFile, parseTermFile, syncAll() — filesystem → patlib.db upsert
errors.ts  — crashOnError() — global unhandled rejection/exception handler, imported by every tool
```

4. Present patlib tools and their data flow

```
write-sync (TRNS)       — patlib.db — writes via syncAll()
read-selection (RECG)   — patlib.db — reads via queryAll()
read-projection (RECG)  — patlib.db — reads via queryOne()
read-validate (RECG)    — filesystem — reads via FRONTMATTER_RE/BACKMATTER_RE
section-extract (RECG)  — filesystem — reads via FRONTMATTER_RE/BACKMATTER_RE
```

5. Present MCP search tools and their data flow

```
mcp-log-search (GENR)  — mcp-search.db — writes to mcp_searches + mcp_results
mcp-features (RECG)    — mcp-search.db — reads mcp_features
mcp-compare (RECG)     — mcp-search.db — reads mcp_searches
mcp-verify (SGNL)      — mcp-search.db — reads mcp_results, writes mcp_signal
```
