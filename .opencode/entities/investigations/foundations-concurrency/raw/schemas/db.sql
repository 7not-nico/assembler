CREATE TABLE IF NOT EXISTS regions (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    languages TEXT NOT NULL,
    status TEXT CHECK(status IN ('PASS', 'WARN', 'FAIL')) NOT NULL,
    source_count INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS anchors (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS researchers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    institution TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id)
);

CREATE TABLE IF NOT EXISTS gaps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    anchor_id TEXT REFERENCES anchors(id),
    description TEXT NOT NULL,
    severity TEXT CHECK(severity IN ('HIGH', 'MEDIUM', 'LOW')) NOT NULL,
    regions_affected TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS meta_analyses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    anchor_id TEXT REFERENCES anchors(id),
    finding TEXT NOT NULL,
    url TEXT
);

CREATE TABLE IF NOT EXISTS concurrency_models_sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    institution TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id),
    domain_type TEXT CHECK(domain_type IN ('edu', 'ac', 'gov', 'org_academic', 'org_commercial', 'com', 'unknown')),
    key_focus TEXT NOT NULL,
    model_categories TEXT
);

CREATE TABLE IF NOT EXISTS memory_models_sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    institution TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id),
    domain_type TEXT CHECK(domain_type IN ('edu', 'ac', 'gov', 'org_academic', 'org_commercial', 'com', 'unknown')),
    key_focus TEXT NOT NULL,
    model_type TEXT
);

CREATE TABLE IF NOT EXISTS classic_problems_sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    institution TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id),
    domain_type TEXT CHECK(domain_type IN ('edu', 'ac', 'gov', 'org_academic', 'org_commercial', 'com', 'unknown')),
    key_focus TEXT NOT NULL,
    problems_covered TEXT
);

CREATE TABLE IF NOT EXISTS sync_primitives_sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    institution TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id),
    domain_type TEXT CHECK(domain_type IN ('edu', 'ac', 'gov', 'org_academic', 'org_commercial', 'com', 'unknown')),
    key_focus TEXT NOT NULL,
    primitives_covered TEXT
);
