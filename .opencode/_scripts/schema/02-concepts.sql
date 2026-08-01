-- file: 02-concepts.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('concepts', 'concepts', 'encyclopedic', 2);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('concepts', 'id',        1, 'string', NULL, '^CON\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('concepts', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('concepts', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('concepts', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('concepts', 'related',   0, 'array',  NULL, NULL, NULL, NULL),
  ('concepts', 'reference', 0, 'array',  NULL, NULL, NULL, NULL),
  ('concepts', 'precedes',  0, 'array',  NULL, NULL, NULL, NULL),
  ('concepts', 'type',      0, 'string', NULL, NULL, NULL, NULL),
  ('concepts', 'mode',      0, 'string', NULL, NULL, NULL, NULL);
