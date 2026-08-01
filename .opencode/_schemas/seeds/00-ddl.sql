-- PROT.ENTITY.REFERENCES — DDL for deduplicated entity references

CREATE TABLE IF NOT EXISTS ref_sources (
  id    INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  url   TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS reference_roles (
  id    TEXT PRIMARY KEY,
  label TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS entity_references (
  entity_type TEXT NOT NULL CHECK(entity_type IN ('term', 'pattern')),
  entity_id   TEXT NOT NULL,
  source_id   INTEGER NOT NULL REFERENCES ref_sources(id),
  position    INTEGER NOT NULL DEFAULT 0,
  role        TEXT NOT NULL REFERENCES reference_roles(id),
  PRIMARY KEY (entity_type, entity_id, source_id)
);
