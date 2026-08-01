-- Investigations: LLM Specification — Gotcha vs Contraction
-- Additive migrations only: ALTER TABLE ADD COLUMN, never DROP

CREATE TABLE IF NOT EXISTS investigations (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  summary TEXT NOT NULL,
  tags TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fundamentals (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  title TEXT NOT NULL,
  principle TEXT NOT NULL,
  mechanism TEXT NOT NULL,
  example TEXT NOT NULL,
  evidence TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS regions (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  name TEXT NOT NULL,
  description TEXT
);

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  region_id TEXT NOT NULL REFERENCES regions(id),
  institution TEXT NOT NULL,
  title TEXT NOT NULL,
  key_content TEXT NOT NULL,
  methodology TEXT,
  url TEXT
);

CREATE TABLE IF NOT EXISTS researchers (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  region_id TEXT NOT NULL REFERENCES regions(id),
  name TEXT NOT NULL,
  institution TEXT NOT NULL,
  focus TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  title TEXT NOT NULL,
  key_finding TEXT NOT NULL,
  methodology TEXT NOT NULL,
  sample_description TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  description TEXT NOT NULL,
  severity TEXT NOT NULL CHECK (severity IN ('high', 'medium', 'low')),
  status TEXT NOT NULL CHECK (status IN ('no native surveys', 'no sources', 'not surfaced', 'not searched'))
);

-- Additive migrations
-- ALTER TABLE sources ADD COLUMN doi TEXT;
-- ALTER TABLE meta_analyses ADD COLUMN citation TEXT;
