-- Investigations: Agentskills.io Skill Format Evaluation
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
  description TEXT NOT NULL,
  our_equivalent TEXT NOT NULL,
  verdict TEXT NOT NULL
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
  title TEXT NOT NULL,
  section TEXT NOT NULL,
  key_content TEXT NOT NULL,
  url TEXT
);

CREATE TABLE IF NOT EXISTS researchers (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  region_id TEXT NOT NULL REFERENCES regions(id),
  name TEXT NOT NULL,
  role TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  title TEXT NOT NULL,
  key_finding TEXT NOT NULL,
  our_status TEXT NOT NULL,
  priority TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  description TEXT NOT NULL,
  severity TEXT NOT NULL CHECK (severity IN ('high', 'medium', 'low')),
  status TEXT NOT NULL CHECK (status IN ('native_surveys_absent', 'sources_absent', 'surfaced_disabled', 'searched_disabled'))
);

-- Additive migrations
-- ALTER TABLE sources ADD COLUMN doi TEXT;
