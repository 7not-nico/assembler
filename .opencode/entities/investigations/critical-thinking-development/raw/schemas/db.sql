-- Schema: Critical Thinking Development Investigation

CREATE TABLE IF NOT EXISTS pedagogies (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    region TEXT,
    core_activity TEXT,
    evidence_rating TEXT CHECK(evidence_rating IN ('strong','moderate','emerging'))
);

CREATE TABLE IF NOT EXISTS evidence_sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedagogy_id TEXT REFERENCES pedagogies(id),
    title TEXT NOT NULL,
    author TEXT,
    institution TEXT,
    url TEXT,
    key_finding TEXT,
    design TEXT,
    effect_size TEXT
);

CREATE TABLE IF NOT EXISTS mechanisms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS pedagogy_mechanisms (
    pedagogy_id TEXT REFERENCES pedagogies(id),
    mechanism_id INTEGER REFERENCES mechanisms(id),
    PRIMARY KEY (pedagogy_id, mechanism_id)
);

CREATE TABLE IF NOT EXISTS gaps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL,
    severity TEXT CHECK(severity IN ('critical','moderate','minor'))
);

CREATE TABLE IF NOT EXISTS researchers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    institution TEXT,
    focus_area TEXT
);
