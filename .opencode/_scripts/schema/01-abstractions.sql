-- file: 01-abstractions.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('abstractions', 'abstractions', 'architectonic', 1);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('abstractions', 'id',        1, 'string', NULL, '^ABS\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('abstractions', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('abstractions', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('abstractions', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('abstractions', 'related',   0, 'array',  NULL, NULL, NULL, NULL),
  ('abstractions', 'reference', 0, 'array',  NULL, NULL, NULL, NULL);
