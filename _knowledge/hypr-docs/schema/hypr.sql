-- hypr.sql — Hyprland docs registry schema
-- Database: hypr.db
-- Layer: schema/ — DB design derives from glossary terms (data → container → loader)

CREATE TABLE IF NOT EXISTS glossary (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    term       TEXT NOT NULL UNIQUE,
    definition TEXT NOT NULL,
    related    TEXT,                -- JSON array of related term names
    source     TEXT,                -- note/chapter reference
    created    TEXT NOT NULL DEFAULT (datetime('now')),
    updated    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS notes (
    id         TEXT PRIMARY KEY,    -- ch{NN}-{topic}
    title      TEXT NOT NULL,
    source     TEXT,                -- URL
    chapter    INTEGER
);

CREATE TABLE IF NOT EXISTS reference (
    id         TEXT PRIMARY KEY,    -- conventions, exceptions
    content    TEXT NOT NULL,
    source     TEXT
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_glossary_term ON glossary(term);
CREATE INDEX IF NOT EXISTS idx_notes_chapter ON notes(chapter);
