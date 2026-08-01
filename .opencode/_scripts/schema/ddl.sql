-- file: 00-ddl.sql
-- mode: ddl
-- creates tables, no dependencies

CREATE TABLE IF NOT EXISTS entity_types (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  ring_group TEXT NOT NULL,
  ring INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type_id TEXT NOT NULL REFERENCES entity_types(id),
  name TEXT NOT NULL,
  required INTEGER NOT NULL DEFAULT 0,
  field_type TEXT NOT NULL,
  enum_values TEXT,
  pattern TEXT,
  min_length INTEGER,
  minimum INTEGER,
  UNIQUE(entity_type_id, name)
);

CREATE TABLE IF NOT EXISTS schema_runs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  script TEXT NOT NULL,
  passed INTEGER NOT NULL DEFAULT 0,
  violations INTEGER NOT NULL DEFAULT 0,
  ran_at TEXT DEFAULT (datetime('now'))
);

PRAGMA journal_mode = WAL;
