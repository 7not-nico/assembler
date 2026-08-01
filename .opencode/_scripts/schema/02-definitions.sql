-- file: 02-definitions.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('definitions', 'definitions', 'encyclopedic', 2);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('definitions', 'id',        1, 'string', NULL, '^DEF\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('definitions', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('definitions', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('definitions', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('definitions', 'related',   1, 'array',  NULL, NULL, NULL, NULL),
  ('definitions', 'reference', 0, 'array',  NULL, NULL, NULL, NULL),
  ('definitions', 'precedes',  0, 'array',  NULL, NULL, NULL, NULL),
  ('definitions', 'type',      0, 'string', NULL, NULL, NULL, NULL),
  ('definitions', 'nature',    0, 'string', NULL, NULL, NULL, NULL),
  ('definitions', 'origin',    0, 'string', NULL, NULL, NULL, NULL),
  ('definitions', 'activity',  0, 'string', NULL, NULL, NULL, NULL);
