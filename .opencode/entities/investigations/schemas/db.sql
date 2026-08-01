-- Semantic Weight — Cross-Region Research Index
-- SQLite

CREATE TABLE IF NOT EXISTS regions (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  region_id TEXT NOT NULL REFERENCES regions(id),
  title TEXT NOT NULL,
  country TEXT,
  institution TEXT,
  key_content TEXT,
  methodology TEXT,
  language TEXT,
  doi_url TEXT,
  year INTEGER,
  tags TEXT
);

CREATE TABLE IF NOT EXISTS researchers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  region_id TEXT NOT NULL REFERENCES regions(id),
  institution TEXT,
  specialisation TEXT
);

CREATE TABLE IF NOT EXISTS fundamentals (
  id TEXT PRIMARY KEY,
  concept TEXT NOT NULL,
  source TEXT,
  key_idea TEXT
);

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  region_id TEXT REFERENCES regions(id),
  summary TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,
  description TEXT NOT NULL,
  regions TEXT
);
