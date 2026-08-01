-- file: 06-references.sql
-- mode: upsert
-- depends-on: ddl.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('references', 'references', 'architectonic', 6);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('references', 'id',      1, 'string', NULL, '^REF\.[A-Z][A-Z0-9._]*(?:\.[A-Z][A-Z0-9._]+)*$', NULL, NULL),
  ('references', 'title',   1, 'string', NULL, NULL, 1, NULL),
  ('references', 'source',  1, 'string', NULL, NULL, 1, NULL),
  ('references', 'tags',    1, 'array',  NULL, NULL, NULL, NULL),
  ('references', 'related', 0, 'array',  NULL, NULL, NULL, NULL),
  ('references', 'summary', 0, 'string', NULL, NULL, NULL, NULL),
  ('references', 'ref',	0, 'string',  NULL, NULL, NULL, NULL);
