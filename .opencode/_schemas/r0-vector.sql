CREATE TABLE IF NOT EXISTS embeddings (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type TEXT NOT NULL,
  entity_id   TEXT NOT NULL,
  seq         INTEGER NOT NULL DEFAULT 0,
  field       TEXT NOT NULL DEFAULT 'full',
  vector      BLOB NOT NULL,
  content_hash TEXT NOT NULL,
  model_version TEXT,
  source_file TEXT,
  source_mtime TEXT,
  updated     TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE(entity_type, entity_id, seq, field)
);

CREATE INDEX IF NOT EXISTS idx_embeddings_lookup
  ON embeddings(entity_type, entity_id, seq, field);

CREATE TABLE IF NOT EXISTS fts_entities(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  field TEXT NOT NULL DEFAULT 'full',
  content TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_fts_entities_lookup ON fts_entities(entity_type, entity_id, field);

CREATE VIRTUAL TABLE IF NOT EXISTS entities_fts USING fts5(
  content,
  content='fts_entities',
  content_rowid='id',
  tokenize='unicode61'
);
