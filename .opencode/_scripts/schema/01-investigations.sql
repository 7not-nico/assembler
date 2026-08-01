-- file: 01-investigations.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('investigations', 'investigations', 'chronicle', 1);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('investigations', 'id',      0, 'string', NULL, '^(INV|MANIFEST)\..*', NULL, NULL),
  ('investigations', 'title',   0, 'string', NULL, NULL, 1, NULL),
  ('investigations', 'summary', 0, 'string', NULL, NULL, 1, NULL),
  ('investigations', 'tags',    0, 'array',  NULL, NULL, NULL, NULL),
  ('investigations', 'tables',  0, 'array',  NULL, NULL, NULL, NULL);
