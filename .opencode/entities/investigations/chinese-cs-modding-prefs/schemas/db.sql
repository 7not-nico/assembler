CREATE TABLE IF NOT EXISTS regions (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    language TEXT NOT NULL,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS sources (
    id TEXT PRIMARY KEY,
    region_id TEXT NOT NULL REFERENCES regions(id),
    title TEXT NOT NULL,
    institution TEXT,
    url TEXT,
    language TEXT NOT NULL,
    type TEXT,
    accessed_date TEXT
);

CREATE TABLE IF NOT EXISTS researchers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    affiliation TEXT,
    region_id TEXT REFERENCES regions(id),
    expertise TEXT,
    contact TEXT
);

CREATE TABLE IF NOT EXISTS meta_analyses (
    id TEXT PRIMARY KEY,
    topic TEXT NOT NULL,
    method TEXT NOT NULL,
    finding TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id),
    source_ids TEXT,
    confidence TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
    id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('high', 'medium', 'low')),
    status TEXT NOT NULL CHECK (status IN ('native_surveys_absent', 'sources_absent', 'surfaced_disabled', 'searched_disabled')),
    region_id TEXT REFERENCES regions(id),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS fundamentals (
    id TEXT PRIMARY KEY,
    claim TEXT NOT NULL,
    evidence TEXT NOT NULL,
    confidence TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id)
);
