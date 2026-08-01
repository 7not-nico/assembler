# Mutation patterns — Append vs Upsert

## Comparison

| Dimension | Append | Upsert |
|-----------|--------|--------|
| Pattern | `INSERT` only | `INSERT ... ON CONFLICT(id) DO UPDATE SET ...` |
| Primary key | `INTEGER PRIMARY KEY AUTOINCREMENT` | `TEXT PRIMARY KEY` |
| Re-run semantics | Appends duplicate rows (meaningful — each is a separate event) | Replaces matching row (idempotent — same result every time) |
| Data shape | Event/time-series | Registry/snapshot |
| Source of truth | The tool call itself | The `.md` file on disk |
| History | Preserved forever | Only latest state |
| Example tool | `mcp-log-search` | `write-sync` |

## When to use which

- **Append** when every occurrence is a distinct, meaningful event. Re-running the same query should create a new record.
- **Upsert** when the file system is the source of truth and the DB is a queryable mirror. Re-running a sync should produce the same state.

## Schema signatures

**Append** (`mcp-log-search` → `mcp_searches`):
```sql
CREATE TABLE IF NOT EXISTS mcp_searches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  mcp TEXT NOT NULL,
  tool TEXT NOT NULL,
  query TEXT NOT NULL,
  result_summary TEXT,
  result_count INTEGER,
  status TEXT NOT NULL DEFAULT 'success',
  error_code TEXT,
  timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);
```

**Upsert** (`write-sync` → `patterns`, `terms`):
```sql
CREATE TABLE IF NOT EXISTS patterns (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  ...
);
```

```typescript
db.query(`
  INSERT INTO patterns (id, title, body, ...)
  VALUES ($id, $title, $body, ...)
  ON CONFLICT(id) DO UPDATE SET title = $title, body = $body, ...
`)
```

## Anti-patterns

| Mistake | Consequence |
|---------|-------------|
| Upsert on event data | Lost search history — re-running `mcp-log-search` would overwrite the previous result |
| Append on registry data | Duplicate rows on every `write-sync` — same entity appears N times |
| `DELETE` or `DROP` in a schema | Breaks old tools — violates additive-only constraint |
| Read+write in one tool | Unclear contract, harder to test, side effects hidden |

## See also

- `bootstrap-db` skill — step 0 (mutation pattern decision)
- `PROT.TOOL.DEFINITION` — read/write separation
- `REF.LIB.DIRECTORY.LAYER` — crashOnError, shared library convention
- `guide-architecture` — layer hierarchy
- `commands/data-flow.md` — full tool data flow trace
