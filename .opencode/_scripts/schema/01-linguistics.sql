-- file: 01-linguistics.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('linguistics', 'linguistics', 'architectonic', 1);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('linguistics', 'id',        1, 'string', NULL, '^LING\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('linguistics', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('linguistics', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('linguistics', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('linguistics', 'related',   0, 'array',  NULL, NULL, NULL, NULL),
  ('linguistics', 'reference', 0, 'array',  NULL, NULL, NULL, NULL);
