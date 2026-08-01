-- file: 02-taxonomies.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('taxonomies', 'taxonomies', 'encyclopedic', 2);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('taxonomies', 'id',        1, 'string', NULL, '^TAX\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('taxonomies', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('taxonomies', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('taxonomies', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('taxonomies', 'related',   0, 'array',  NULL, NULL, NULL, NULL),
  ('taxonomies', 'reference', 0, 'array',  NULL, NULL, NULL, NULL),
  ('taxonomies', 'precedes',  0, 'array',  NULL, NULL, NULL, NULL),
  ('taxonomies', 'rank',      0, 'string', NULL, NULL, NULL, NULL);
