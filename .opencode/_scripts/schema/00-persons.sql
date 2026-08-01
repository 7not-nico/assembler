-- file: 00-persons.sql
-- mode: append
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('persons', 'persons', 'chronicle', 0);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('persons', 'id',      1, 'string', NULL, '^PER\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('persons', 'title',   1, 'string', NULL, NULL, 1, NULL),
  ('persons', 'source',  1, 'string', NULL, NULL, 1, NULL),
  ('persons', 'subtype', 1, 'string', 'physical,jurisdictional', NULL, NULL, NULL),
  ('persons', 'tags',    1, 'array',  NULL, NULL, NULL, NULL);
