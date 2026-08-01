-- file: 01-maxims.sql
-- mode: append
-- depends-on: 00-ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('maxims', 'maxims', 'architectonic', 0);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('maxims', 'id',          1, 'string', NULL, '^MAX\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('maxims', 'title',       1, 'string', NULL, NULL, 1, NULL),
  ('maxims', 'source',      1, 'string', NULL, NULL, 1, NULL),
  ('maxims', 'summary',     1, 'string', NULL, NULL, 1, NULL),
  ('maxims', 'principle',   1, 'string', NULL, NULL, 1, NULL),
  ('maxims', 'enforcement', 1, 'string', 'Convention,Tool,Review', NULL, NULL, NULL),
  ('maxims', 'tags',        1, 'array',  NULL, NULL, NULL, NULL),
  ('maxims', 'status',      1, 'string', 'active,draft', NULL, NULL, NULL),
  ('maxims', 'priority',    1, 'integer', NULL, NULL, NULL, 1);
