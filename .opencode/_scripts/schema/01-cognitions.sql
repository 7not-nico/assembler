-- file: 01-cognitions.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('cognitions', 'cognitions', 'encyclopedic', 1);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('cognitions', 'id',        1, 'string', NULL, '^COG\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('cognitions', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('cognitions', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('cognitions', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('cognitions', 'related',   0, 'array',  NULL, NULL, NULL, NULL),
  ('cognitions', 'reference', 0, 'array',  NULL, NULL, NULL, NULL),
  ('cognitions', 'precedes',  0, 'array',  NULL, NULL, NULL, NULL);
