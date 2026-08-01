-- file: 02-protocols.sql
-- mode: upsert
-- depends-on: 01-maxims.sql

INSERT OR REPLACE INTO entity_types (id, name, ring_group, ring) VALUES ('protocols', 'protocols', 'architectonic', 4);

INSERT OR REPLACE INTO fields (entity_type_id, name, required, field_type, enum_values, pattern, min_length, minimum) VALUES
  ('protocols', 'id',          1, 'string', NULL, '^PROT\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*$', NULL, NULL),
  ('protocols', 'title',       1, 'string', NULL, NULL, 1, NULL),
  ('protocols', 'source',      1, 'string', NULL, NULL, 1, NULL),
  ('protocols', 'summary',     1, 'string', NULL, NULL, 1, NULL),
  ('protocols', 'protocol',    1, 'string', NULL, NULL, 1, NULL),
  ('protocols', 'enforcement', 1, 'string', 'Sealed,Accord,Formality', NULL, NULL, NULL),
  ('protocols', 'tags',        1, 'array',  NULL, NULL, NULL, NULL),
  ('protocols', 'status',      1, 'string', 'active,draft', NULL, NULL, NULL),
  ('protocols', 'priority',    1, 'integer', NULL, NULL, NULL, 1),
  ('protocols', 'related',     0, 'array',  NULL, NULL, NULL, NULL),
  ('protocols', 'reference',   0, 'string', NULL, NULL, NULL, NULL);
