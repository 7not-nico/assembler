-- Publications Comparison Investigation
-- Shared schema — additive-only migrations.
-- All tables use TEXT PRIMARY KEY for id-based lookup,
-- INTEGER PRIMARY KEY AUTOINCREMENT for event-log tables.

CREATE TABLE IF NOT EXISTS publications (
    id              TEXT PRIMARY KEY,  -- quanta, natgeo, conversation, aeon
    name            TEXT NOT NULL,
    founded         INTEGER,
    url             TEXT,
    scope           TEXT,
    business_model  TEXT,
    funding_source  TEXT,
    trajectory      TEXT               -- rising, declining, stable
);

CREATE TABLE IF NOT EXISTS dimensions (
    id          TEXT PRIMARY KEY,  -- editorial_model, subject_scope, business_model, audience, quality, funding, trajectory, fact_checking
    name        TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS publication_dimensions (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    publication_id  TEXT NOT NULL REFERENCES publications(id),
    dimension_id    TEXT NOT NULL REFERENCES dimensions(id),
    finding         TEXT,
    rating          TEXT,            -- strong, moderate, weak, degraded, unknown
    source_url      TEXT,
    UNIQUE(publication_id, dimension_id)
);

CREATE TABLE IF NOT EXISTS sources (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    publication_id  TEXT REFERENCES publications(id),
    url             TEXT NOT NULL,
    title           TEXT,
    source_type     TEXT,            -- academic, commercial, institutional, wiki
    search_round    TEXT,            -- round-1, round-A, etc.
    domain          TEXT             -- extracted domain for filtering
);

CREATE TABLE IF NOT EXISTS searches (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    publication_id  TEXT REFERENCES publications(id),
    dimension       TEXT,
    query           TEXT,
    status          TEXT,            -- PASS, WARN, FAIL
    result_count    INTEGER,
    logged_at       TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS awards (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    publication_id  TEXT NOT NULL REFERENCES publications(id),
    year            INTEGER NOT NULL,
    award_name      TEXT NOT NULL,
    category        TEXT,
    notes           TEXT
);

CREATE TABLE IF NOT EXISTS timeline_events (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    publication_id  TEXT NOT NULL REFERENCES publications(id),
    year            INTEGER NOT NULL,
    event_type      TEXT,
    description     TEXT NOT NULL,
    source_url      TEXT
);
