-- file: 06-illustrations.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('illustrations', 'illustrations', 'architectonic', 6);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('illustrations', 'id',           1, 'string', NULL, '^ILL\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('illustrations', 'title',        1, 'string', NULL, NULL, 1, NULL),
  ('illustrations', 'source',       1, 'string', NULL, NULL, 1, NULL),
  ('illustrations', 'summary',      1, 'string', NULL, NULL, 1, NULL),
  ('illustrations', 'illustration', 1, 'string', NULL, NULL, 1, NULL),
  ('illustrations', 'illustrates',  0, 'array',  NULL, NULL, NULL, NULL),
  ('illustrations', 'tags',         1, 'array',  NULL, NULL, NULL, NULL),
  ('illustrations', 'related',      0, 'array',  NULL, NULL, NULL, NULL);
