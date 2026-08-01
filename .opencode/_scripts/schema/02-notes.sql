-- file: 02-notes.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('notes', 'notes', 'chronicle', 2);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('notes', 'id',      0, 'string', NULL, '^NOTE\..*', NULL, NULL),
  ('notes', 'title',   0, 'string', NULL, NULL, 1, NULL),
  ('notes', 'tags',    0, 'array',  NULL, NULL, NULL, NULL);
