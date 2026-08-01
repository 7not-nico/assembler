-- templates.sql — _templates registry + semantic store
-- Database: templates.db (registry), templates-vector.db (embeddings)
-- Layer: schema/ — DB design derives from template set contents
-- Additive-only migrations: ALTER TABLE ADD COLUMN, never drops.

-- Registry: one row per template artifact
CREATE TABLE IF NOT EXISTS templates (
    id         TEXT PRIMARY KEY,     -- file basename, e.g. note-template.md
    layer      TEXT NOT NULL,        -- format/precept/procedure/... or bootstrap/infrastructure
    purpose    TEXT,                 -- one-line purpose from the file header
    file_path  TEXT NOT NULL,        -- path relative to _templates/
    kind       TEXT DEFAULT 'template', -- template | report | script | schema
    chain_pos  INTEGER,              -- position in 13-layer chain (1=format..13=practice); NULL for infra
    tags       TEXT,                 -- JSON array — discriminative keywords (parse body headings/terms)
    composes   TEXT,                 -- JSON array — "Composes with" references from header
    governs    TEXT,                 -- JSON array — what this artifact governs (Governs section)
    input      TEXT,                 -- what it consumes (Prerequisites/Prerequisites section)
    output     TEXT,                 -- what it produces (Steps/Verify/outcome)
    created    TEXT NOT NULL DEFAULT (datetime('now')),
    updated    TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Reports: session reports (improvement loop)
CREATE TABLE IF NOT EXISTS reports (
    id         TEXT PRIMARY KEY,     -- YYYYMMDD-HHMMSS.md
    project    TEXT,                 -- knowledge project studied
    date       TEXT,                 -- session date YYYY-MM-DD (from **Date:** header)
    errors     INTEGER DEFAULT 0,    -- count of errors found
    findings   INTEGER DEFAULT 0,    -- count of findings
    error_text TEXT,                 -- joined error summaries (first clause each)
    file_path  TEXT NOT NULL,
    created    TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_templates_layer ON templates(layer);
CREATE INDEX IF NOT EXISTS idx_templates_chain ON templates(chain_pos);
CREATE INDEX IF NOT EXISTS idx_reports_project ON reports(project);
CREATE INDEX IF NOT EXISTS idx_reports_date ON reports(date);
