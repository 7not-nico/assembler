CREATE TABLE IF NOT EXISTS files (
  id          INTEGER PRIMARY KEY,
  domain      TEXT NOT NULL,
  slug        TEXT NOT NULL,
  title       TEXT NOT NULL,
  concern     TEXT NOT NULL,
  path        TEXT NOT NULL,
  checksum    TEXT,
  created_at  TEXT DEFAULT (datetime('now')),
  modified_at TEXT DEFAULT (datetime('now')),
  UNIQUE(domain, slug)
);

CREATE TABLE IF NOT EXISTS concepts (
  id      INTEGER PRIMARY KEY,
  file_id INTEGER NOT NULL REFERENCES files(id),
  concept TEXT NOT NULL,
  category TEXT
);

CREATE TABLE IF NOT EXISTS practices (
  id        INTEGER PRIMARY KEY,
  file_id   INTEGER NOT NULL REFERENCES files(id),
  path      TEXT NOT NULL,
  passed    INTEGER DEFAULT 0,
  failed    INTEGER DEFAULT 0,
  last_run  TEXT
);
