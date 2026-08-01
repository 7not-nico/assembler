-- Investigations: LLM Logical Operators vs Semantic Phrasing
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
  finding TEXT NOT NULL,
  evidence TEXT NOT NULL,
  confidence TEXT NOT NULL CHECK (confidence IN ('High','Medium','Low'))
);

CREATE TABLE IF NOT EXISTS regions (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  name TEXT NOT NULL,
  languages TEXT,
  searches INTEGER,
  sources_found INTEGER,
  status TEXT NOT NULL CHECK (status IN ('PASS','WARN','FAIL'))
);

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  region_id TEXT NOT NULL REFERENCES regions(id),
  title TEXT NOT NULL,
  authors TEXT,
  institution TEXT,
  key_finding TEXT NOT NULL,
  methodology TEXT,
  url TEXT,
  doi TEXT,
  year INTEGER,
  venue TEXT
);

CREATE TABLE IF NOT EXISTS operators (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  symbol TEXT NOT NULL,
  name TEXT NOT NULL,
  verdict TEXT NOT NULL,
  mechanism TEXT,
  fidelity_range TEXT
);

CREATE TABLE IF NOT EXISTS operator_fidelity (
  id TEXT PRIMARY KEY,
  operator_id TEXT NOT NULL REFERENCES operators(id),
  model_name TEXT NOT NULL,
  fidelity_pct REAL NOT NULL,
  task_type TEXT NOT NULL,
  source_id TEXT
);

CREATE TABLE IF NOT EXISTS failure_modes (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  name TEXT NOT NULL,
  prevalence_pct REAL,
  mechanism TEXT NOT NULL,
  affected_operators TEXT NOT NULL,
  mitigation TEXT
);

CREATE TABLE IF NOT EXISTS researchers (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  region_id TEXT NOT NULL REFERENCES regions(id),
  name TEXT NOT NULL,
  institution TEXT,
  focus TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  title TEXT NOT NULL,
  source_count INTEGER,
  coverage TEXT,
  key_conclusion TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,
  investigation_id TEXT NOT NULL REFERENCES investigations(id),
  description TEXT NOT NULL,
  severity TEXT NOT NULL CHECK (severity IN ('High','Medium','Low')),
  suggested_research TEXT
);
