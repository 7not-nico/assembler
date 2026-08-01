-- schema.sql — SOA semantic analysis metadata store
-- Database: semantics.db

CREATE TABLE IF NOT EXISTS roles (
    id          TEXT PRIMARY KEY,    -- LANGUAGE-ROLE, e.g. C-SUBJECT
    language    TEXT NOT NULL,       -- language name, e.g. C
    role        TEXT NOT NULL CHECK (role IN ('subject', 'object', 'action')),
    title       TEXT NOT NULL,       -- one-line name
    definition  TEXT NOT NULL,       -- core spec quote
    canonical   TEXT,                -- simplest code example
    tags        TEXT,                -- JSON array of keywords
    status      TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'stable')),
    file_path   TEXT,                -- path to markdown file
    created_at  TEXT DEFAULT (datetime('now')),
    updated_at  TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS sources (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    role_id     TEXT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    section     TEXT NOT NULL,       -- spec section reference
    url         TEXT                 -- URL to the spec section
);

CREATE TABLE IF NOT EXISTS precedes (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    role_id     TEXT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    precedes_id TEXT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE(role_id, precedes_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_roles_language ON roles(language);
CREATE INDEX IF NOT EXISTS idx_roles_role ON roles(role);
CREATE INDEX IF NOT EXISTS idx_sources_role_id ON sources(role_id);
CREATE INDEX IF NOT EXISTS idx_precedes_role_id ON precedes(role_id);
