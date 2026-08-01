-- file: 04-nexus.sql
-- mode: upsert
-- depends-on: 03-patterns.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('nexus', 'nexus', 'architectonic', 3);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('nexus', 'id',          1, 'string', NULL, '^NEX\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('nexus', 'title',       1, 'string', NULL, NULL, 1, NULL),
  ('nexus', 'source',      1, 'string', NULL, NULL, 1, NULL),
  ('nexus', 'summary',     1, 'string', NULL, NULL, 1, NULL),
  ('nexus', 'composition', 1, 'string', NULL, NULL, 1, NULL),
  ('nexus', 'enforcement', 1, 'string', 'Convention,Tool', NULL, NULL, NULL),
  ('nexus', 'tags',        1, 'array',  NULL, NULL, NULL, NULL),
  ('nexus', 'status',      1, 'string', 'active,draft', NULL, NULL, NULL),
  ('nexus', 'priority',    1, 'integer', NULL, NULL, NULL, 1),
  ('nexus', 'related',     0, 'array',  NULL, NULL, NULL, NULL);
