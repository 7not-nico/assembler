-- Abortion Investigation Schema
-- 7 tables per search-geo convention + oath_traditions

CREATE TABLE IF NOT EXISTS regions (
  id TEXT PRIMARY KEY,          -- e.g. 'NA', 'EU', 'LATAM'
  name TEXT NOT NULL,           -- full name
  coverage_note TEXT
);

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,          -- region-prefixed e.g. 'NA.ROE'
  region_id TEXT NOT NULL REFERENCES regions(id),
  title TEXT NOT NULL,
  institution TEXT,
  key_content TEXT,
  language TEXT DEFAULT 'EN',
  url TEXT,
  year INTEGER
);

CREATE TABLE IF NOT EXISTS researchers (
  id TEXT PRIMARY KEY,          -- e.g. 'R.PRABHAT.JHA'
  name TEXT NOT NULL,
  region_id TEXT REFERENCES regions(id),
  institution TEXT,
  specialisation TEXT
);

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,          -- 'MA.*' prefixed
  title TEXT NOT NULL,
  scope TEXT,
  key_finding TEXT,
  effect_size TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,          -- 'GAP.*' prefixed
  region TEXT NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('native_surveys_absent', 'sources_absent', 'surfaced_disabled', 'searched_disabled')),
  notes TEXT
);

CREATE TABLE IF NOT EXISTS fundamentals (
  id TEXT PRIMARY KEY,          -- 'F.*' prefixed
  concept TEXT NOT NULL,
  source TEXT NOT NULL,
  key_idea TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS oath_traditions (
  id TEXT PRIMARY KEY,          -- 'OATH.*' prefixed
  oath_name TEXT NOT NULL,
  body TEXT NOT NULL,
  stance TEXT NOT NULL,
  key_detail TEXT
);
