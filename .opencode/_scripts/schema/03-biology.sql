-- file: 03-biology.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('biology', 'biology', 'encyclopedic', 3);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('biology', 'id',        1, 'string', NULL, '^BIO\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('biology', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('biology', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('biology', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('biology', 'related',   0, 'array',  NULL, NULL, NULL, NULL),
  ('biology', 'reference', 0, 'array',  NULL, NULL, NULL, NULL),
  ('biology', 'precedes',  0, 'array',  NULL, NULL, NULL, NULL),
  ('biology', 'type',      0, 'string', NULL, NULL, NULL, NULL);
