CREATE TABLE IF NOT EXISTS entity_terms (
  source_type TEXT NOT NULL CHECK(source_type IN ('skill', 'command', 'rule', 'pattern', 'term', 'protocol', 'illustration')),
  source_id TEXT NOT NULL,
  term_id TEXT NOT NULL REFERENCES terms(id),
  PRIMARY KEY (source_type, source_id, term_id)
);

CREATE TABLE IF NOT EXISTS entity_patterns (
  source_type TEXT NOT NULL CHECK(source_type IN ('skill', 'command', 'rule', 'pattern', 'term', 'protocol', 'illustration')),
  source_id TEXT NOT NULL,
  pattern_id TEXT NOT NULL REFERENCES patterns(id),
  PRIMARY KEY (source_type, source_id, pattern_id)
);
