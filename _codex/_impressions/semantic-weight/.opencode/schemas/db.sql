-- Semantic Weight — Cross-Region Research Index
-- SQLite

CREATE TABLE IF NOT EXISTS fundamentals (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  summary TEXT,
  source TEXT,
  key_idea TEXT
);

CREATE TABLE IF NOT EXISTS fundamentals_tags (
  id TEXT NOT NULL,
  value TEXT NOT NULL,
  PRIMARY KEY (id, value)
);

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  region_id TEXT NOT NULL REFERENCES regions(id),
  country TEXT,
  institution TEXT,
  key_content TEXT,
  methodology TEXT,
  language TEXT,
  doi_url TEXT,
  year INTEGER
);

CREATE TABLE IF NOT EXISTS sources_tags (
  id TEXT NOT NULL,
  value TEXT NOT NULL,
  PRIMARY KEY (id, value)
);

CREATE TABLE IF NOT EXISTS researchers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  institution TEXT,
  region_id TEXT NOT NULL REFERENCES regions(id),
  specialisation TEXT
);

CREATE TABLE IF NOT EXISTS regions (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,
  description TEXT NOT NULL,
  regions TEXT
);

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  summary TEXT,
  region_id TEXT REFERENCES regions(id)
);
