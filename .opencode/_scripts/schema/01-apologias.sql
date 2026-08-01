-- file: 01-apologias.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('apologias', 'apologias', 'chronicle', 1);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('apologias', 'id',        1, 'string', NULL, '^APO\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('apologias', 'title',     1, 'string', NULL, NULL, 1, NULL),
  ('apologias', 'source',    1, 'string', NULL, NULL, 1, NULL),
  ('apologias', 'tags',      1, 'array',  NULL, NULL, NULL, NULL),
  ('apologias', 'related',   0, 'array',  NULL, NULL, NULL, NULL);
