-- file: 01-terms.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('terms', 'terms', 'encyclopedic', 3);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('terms', 'id',        1, 'string', NULL, '^TERM\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('terms', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('terms', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('terms', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('terms', 'reference', 1, 'array',  NULL, NULL, NULL, NULL),
  ('terms', 'related',   1, 'array',  NULL, NULL, NULL, NULL),
  ('terms', 'type',      0, 'string', NULL, NULL, NULL, NULL),
  ('terms', 'precedes',  0, 'array',  NULL, NULL, NULL, NULL);
