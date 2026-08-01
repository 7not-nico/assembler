// exports: ensureVectorSchema
// purity: io (PRAGMA table_info, ALTER TABLE, CREATE TABLE, CREATE VIRTUAL TABLE)
// depends-on: bun:sqlite
// notes: Called by initVectorDB() after schema SQL file is executed.
//   Handles migration from v1 (UNIQUE(entity_type,entity_id), no field in fts_entities)
//   to v2 (UNIQUE(entity_type,entity_id,seq,field), field in fts_entities).

import { Database } from "bun:sqlite"

export function ensureVectorSchema(vdb: Database): void {
  const embedCols = new Set(
    (vdb.query("SELECT name FROM pragma_table_info('embeddings')").all() as Array<Record<string, unknown>>)
      .map(r => String(r.name)),
  )

  // Detect old embeddings schema (had 'model' column, no 'field' in UNIQUE)
  if (embedCols.has("model")) {
    vdb.run("DROP TABLE IF EXISTS embeddings")
    vdb.run(`CREATE TABLE IF NOT EXISTS embeddings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      seq INTEGER NOT NULL DEFAULT 0,
      field TEXT NOT NULL DEFAULT 'full',
      vector BLOB NOT NULL,
      content_hash TEXT NOT NULL,
      model_version TEXT,
      source_file TEXT,
      source_mtime TEXT,
      updated TEXT NOT NULL DEFAULT (datetime('now')),
      UNIQUE(entity_type, entity_id, seq, field)
    )`)
  }

  // Migration: add source_file + source_mtime columns if missing (v2→v3)
  if (!embedCols.has("source_file")) {
    vdb.run("ALTER TABLE embeddings ADD COLUMN source_file TEXT")
    vdb.run("ALTER TABLE embeddings ADD COLUMN source_mtime TEXT")
  }

  vdb.run("CREATE INDEX IF NOT EXISTS idx_embeddings_lookup ON embeddings(entity_type, entity_id, seq, field)")

  // Detect old fts_entities (no 'field' column)
  const ftsCols = new Set(
    (vdb.query("SELECT name FROM pragma_table_info('fts_entities')").all() as Array<Record<string, unknown>>)
      .map(r => String(r.name)),
  )
  if (!ftsCols.has("field")) {
    vdb.run("DROP TABLE IF EXISTS entities_fts")
    vdb.run("DROP TABLE IF EXISTS fts_entities")
    vdb.run(`CREATE TABLE IF NOT EXISTS fts_entities(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      field TEXT NOT NULL DEFAULT 'full',
      content TEXT NOT NULL
    )`)
    vdb.run(`CREATE VIRTUAL TABLE IF NOT EXISTS entities_fts USING fts5(
      content,
      content='fts_entities',
      content_rowid='id',
      tokenize='porter unicode61'
    )`)
  }

  vdb.run("CREATE INDEX IF NOT EXISTS idx_fts_entities_lookup ON fts_entities(entity_type, entity_id, field)")
}
