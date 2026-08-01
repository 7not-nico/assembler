-- Schema for research-methodology investigation
-- Additive-only migrations: ALTER TABLE ADD COLUMN only

CREATE TABLE IF NOT EXISTS regions (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('PASS', 'WARN', 'FAIL', 'SKIP')),
    source_count INTEGER,
    surveyed_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sources (
    id TEXT PRIMARY KEY,
    region_id TEXT NOT NULL REFERENCES regions(id),
    title TEXT NOT NULL,
    institution TEXT,
    url TEXT NOT NULL,
    domain_type TEXT CHECK(domain_type IN ('.edu', '.ac.uk', '.ac.*', '.gov', '.org', '.com', 'other')),
    anchor TEXT,
    key_finding TEXT,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS researchers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    institution TEXT,
    focus TEXT,
    region TEXT,
    sources TEXT -- JSON array of source IDs
);

CREATE TABLE IF NOT EXISTS meta_analyses (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    focus TEXT,
    key_finding TEXT,
    source_url TEXT,
    region TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
    id TEXT PRIMARY KEY,
    region_id TEXT REFERENCES regions(id),
    gap_type TEXT CHECK(gap_type IN ('regional', 'cross-cutting')),
    description TEXT NOT NULL,
    severity TEXT CHECK(severity IN ('high', 'medium', 'low'))
);

CREATE TABLE IF NOT EXISTS frameworks (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    domain TEXT NOT NULL,
    description TEXT,
    origin_region TEXT
);
