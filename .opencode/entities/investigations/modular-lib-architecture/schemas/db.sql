-- Modular Library Architecture — Global Research Index Schema
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
  sample_size TEXT,
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

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  scope TEXT,
  key_finding TEXT NOT NULL,
  effect_size TEXT,
  sample_size TEXT,
  doi_url TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,
  region_name TEXT NOT NULL,
  status TEXT NOT NULL,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS fundamentals (
  id TEXT PRIMARY KEY,
  concept TEXT NOT NULL,
  source TEXT NOT NULL,
  key_idea TEXT NOT NULL
);
