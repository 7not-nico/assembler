-- file: 02-archives.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('archives', 'archives', 'chronicle', 2);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('archives', 'id',          1, 'string', NULL, '^(PROT|ARC)\..*', NULL, NULL),
  ('archives', 'title',       1, 'string', NULL, NULL, 1, NULL),
  ('archives', 'source',      1, 'string', NULL, NULL, 1, NULL),
  ('archives', 'summary',     1, 'string', NULL, NULL, 1, NULL),
  ('archives', 'protocol',    1, 'string', NULL, NULL, 1, NULL),
  ('archives', 'enforcement', 1, 'string', NULL, NULL, 1, NULL),
  ('archives', 'tags',        1, 'array',  NULL, NULL, NULL, NULL),
  ('archives', 'related',     0, 'array',  NULL, NULL, NULL, NULL),
  ('archives', 'priority',    0, 'integer', NULL, NULL, NULL, 1),
  ('archives', 'archived',    0, 'string', NULL, NULL, NULL, NULL);
