-- Schema: Liberal Arts Education Investigation
-- Derived from meta-audit manifest

CREATE TABLE IF NOT EXISTS regions (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    rating TEXT NOT NULL CHECK(rating IN ('PASS','WARN','FAIL')),
    search_query TEXT,
    source_count INTEGER,
    commercial_count INTEGER DEFAULT 0,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS outcomes (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS region_outcomes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    region_id TEXT REFERENCES regions(id),
    outcome_id TEXT REFERENCES outcomes(id),
    present INTEGER NOT NULL DEFAULT 1,
    evidence_quality TEXT CHECK(evidence_quality IN ('strong','moderate','weak'))
);

CREATE TABLE IF NOT EXISTS sources (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    url TEXT,
    institution TEXT,
    region_id TEXT REFERENCES regions(id),
    domain_suffix TEXT,
    source_type TEXT CHECK(source_type IN ('academic','commercial','government','institutional')),
    key_findings TEXT,
    methodology TEXT
);

CREATE TABLE IF NOT EXISTS researchers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    institution TEXT,
    region_id TEXT REFERENCES regions(id),
    focus_area TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL,
    regions_affected TEXT,
    severity TEXT CHECK(severity IN ('critical','moderate','minor'))
);

CREATE TABLE IF NOT EXISTS meta_analyses (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id),
    key_conclusions TEXT,
    methodology TEXT
);
