-- file: 03-patterns.sql
-- mode: upsert
-- depends-on: 02-protocols.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('patterns', 'patterns', 'architectonic', 5);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('patterns', 'id',          1, 'string', NULL, '^PAT\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('patterns', 'title',       1, 'string', NULL, NULL, 1, NULL),
  ('patterns', 'source',      1, 'string', NULL, NULL, 1, NULL),
  ('patterns', 'summary',     1, 'string', NULL, NULL, 1, NULL),
  ('patterns', 'morphism',   1, 'string', NULL, NULL, 1, NULL),
  ('patterns', 'enforcement', 1, 'string', 'Convention', NULL, NULL, NULL),
  ('patterns', 'tags',        1, 'array',  NULL, NULL, NULL, NULL),
  ('patterns', 'status',      1, 'string', 'active,draft', NULL, NULL, NULL),
  ('patterns', 'priority',    1, 'integer', NULL, NULL, NULL, 1),
  ('patterns', 'related',     0, 'array',  NULL, NULL, NULL, NULL);
