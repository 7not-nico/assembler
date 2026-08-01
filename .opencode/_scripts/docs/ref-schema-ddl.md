# Schema DDL — `schema/schemas.db`

SQLite database at `schema/schemas.db` in WAL mode, auto-created by `SeedDB` on first run.

## Tables

```sql
entity_types (id TEXT PK, name, ring_group, ring)
fields       (entity_type_id FK→entity_types, name, required, field_type, enum_values, pattern, min_length, minimum)
schema_runs  (id INTEGER PK, script, passed, violations, ran_at)
```

## WAL mode

`PRAGMA journal_mode = WAL` enables concurrent reads without blocking.
- `.db-wal` and `.db-shm` files appear during active writes
- Auto-checkpointed on connection close
- WAL is persistent — set once, survives reconnect
- `PRAGMA busy_timeout = 5000` set on each connection

## Run logging

Every audit script logs to `schema_runs`:
```sql
INSERT INTO schema_runs (script, passed, violations) VALUES (?, ?, ?)
```

Query recent runs:
```ruby
db.execute("SELECT script, passed, violations, ran_at FROM schema_runs ORDER BY ran_at DESC LIMIT 10")
```
