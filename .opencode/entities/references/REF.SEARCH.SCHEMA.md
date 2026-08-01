---
id: REF.SEARCH.SCHEMA
title: "Vector Search Schema — Separate DB, Embeddings Table, FTS5 Tables, PRAGMAs"
source: PROT.SEARCH.QUERY
related: [PROT.SCHEMA.DATABASE.PRAGMA, PROT.SCHEMA.DATABASE.OWNERSHIP, PROT.SEARCH.EMBEDDING, PROT.SEARCH.EMBEDDING, PROT.SEARCH.QUERY, PROT.SCHEMA.AUGMENT]
summary: "Vector index in separate .opencode/patlib-vector.db derived cache. Two tables: embeddings (vector store with source file tracking) and fts_entities (external content for FTS5). entities_fts is a content-sync FTS5 virtual table. PRAGMAs per PROT.SCHEMA.DATABASE.PRAGMA. Existing DBs migrate via ensure-vector-schema.ts."
ref: "Two tables in patlib-vector.db: embeddings (entity vectors with source tracking) and fts_entities (FTS5 external content). entities_fts is a content-sync FTS5 virtual table. Schema defined in _schemas/patlib-vector.sql. PRAGMAs on connection per PROT.SCHEMA.DATABASE.PRAGMA. Migration via _lib/ensure-vector-schema.ts using PRAGMA table_info."
tags: [search, vector, schema, database, patlib, index, migration, fts5]
---

Vector index at `.opencode/patlib-vector.db`, a derived cache separate from `patlib.db`.

## Protocol

### 1. Separate DB for vector data

`patlib-vector.db` at `.opencode/patlib-vector.db`. Derived cache — fully recomputable from source. `patlib.db` remains the authoritative entity store. Delete `patlib-vector.db` to force a full rebuild.

### 2. Embeddings table

| Column | Type | Required | Default | Purpose |
|--------|------|----------|---------|---------|
| `id` | INTEGER PK | Yes | | Row ID |
| `entity_type` | TEXT | Yes | | Entity type (patterns, terms, ...) |
| `entity_id` | TEXT | Yes | | Entity ID (MAX.CODE.DRY.PRINCIPLE, IDENTITY.MCP, ...) |
| `seq` | INTEGER | Yes | 0 | Chunk sequence; 0 = single vector |
| `field` | TEXT | Yes | 'full' | Embedding scope: 'full', 'meta', 'body' |
| `vector` | BLOB | Yes | | 384-dim float32 embedding binary |
| `content_hash` | TEXT | Yes | | SHA-256 of source text (backward compat) |
| `model_version` | TEXT | No | | Resolved model ID at embedding time |
| `source_file` | TEXT | No | | Absolute path to source entity file |
| `source_mtime` | TEXT | No | | File mtime timestamp for change detection |
| `updated` | TEXT | Yes | datetime('now') | Last update timestamp |

Unique constraint: `UNIQUE(entity_type, entity_id, seq, field)` — one row per entity per scope.

Index: `idx_embeddings_lookup` on `(entity_type, entity_id, seq, field)`.

### 3. FTS5 external content table

`fts_entities` — regular SQLite table that stores the text content for FTS5 indexing:

| Column | Type | Purpose |
|--------|------|---------|
| `id` | INTEGER PK | Row ID (mapped to FTS5 rowid via content_rowid) |
| `entity_type` | TEXT | Entity type |
| `entity_id` | TEXT | Entity ID |
| `field` | TEXT | Scope identifier ('full', 'meta', 'body') |
| `content` | TEXT | Full text for FTS5 indexing |

Index: `idx_fts_entities_lookup` on `(entity_type, entity_id, field)`.

### 4. FTS5 virtual table

`entities_fts` — content-sync FTS5 virtual table:

```sql
CREATE VIRTUAL TABLE entities_fts USING fts5(
    content,
    content='fts_entities',
    content_rowid='id',
    tokenize='porter unicode61'
)
```

- `content='fts_entities'` — external content source (no data duplication)
- `content_rowid='id'` — maps FTS5 rowid to fts_entities.id
- `tokenize='porter unicode61'` — English stemming + Unicode-aware tokenizer

After bulk INSERT/UPDATE/DELETE on `fts_entities`, the FTS5 index is rebuilt via:
```sql
INSERT INTO entities_fts(entities_fts) VALUES('rebuild')
```

### 5. Schema source

`_schemas/patlib-vector.sql` defines both tables and the FTS5 virtual table. New databases created from this file. Existing databases migrate via `_lib/ensure-vector-schema.ts`.

### 6. Migration

`ensureVectorSchema()` in `_lib/ensure-vector-schema.ts` (purity: io):
1. Checks `PRAGMA table_info('embeddings')` for missing columns
2. ALTER TABLE ADD COLUMN for each missing column
3. Creates `idx_embeddings_entity_seq` index if absent
4. CREATE TABLE IF NOT EXISTS for `fts_entities`
5. CREATE VIRTUAL TABLE IF NOT EXISTS for `entities_fts`

Follows `PROT.SCHEMA.AUGMENT` (additive-only ALTER TABLE).

### 7. PRAGMAs

`initVectorDB()` sets `PRAGMA journal_mode=WAL` and `PRAGMA foreign_keys=ON` per `PROT.SCHEMA.DATABASE.PRAGMA`. Applied before schema execution and migration.

## Applicability

All vector search deployments. Subprojects follow the same schema pattern with their own `patlib-vector.db` at `.opencode/patlib-vector.db`.

## See also

- `PROT.SEARCH.EMBEDDING` — vector search registry
- `PROT.SEARCH.EMBEDDING` — embedding model, entity text composition
- `PROT.SEARCH.QUERY` — query modes, tool invocations
- `PROT.SCHEMA.DATABASE.PRAGMA` — WAL mode and FK enforcement standard
- `PROT.SCHEMA.DATABASE.OWNERSHIP` — DB creation criterion
- `PROT.SCHEMA.AUGMENT` — additive-only migration
- `_lib/ensure-vector-schema.ts` — migration implementation
- `_schemas/patlib-vector.sql` — canonical schema SQL
