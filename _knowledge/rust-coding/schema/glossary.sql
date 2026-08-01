CREATE TABLE IF NOT EXISTS glossary (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    term      TEXT NOT NULL UNIQUE,
    definition TEXT NOT NULL,
    chapter   TEXT NOT NULL,
    source    TEXT,
    created   TEXT NOT NULL DEFAULT (datetime('now')),
    updated   TEXT NOT NULL DEFAULT (datetime('now'))
);
