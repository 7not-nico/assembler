-- MCP Search Logging — Schema + Seed Data

CREATE TABLE IF NOT EXISTS mcp_searches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  mcp TEXT NOT NULL,
  tool TEXT NOT NULL,
  query TEXT NOT NULL,
  result_summary TEXT,
  result_count INTEGER,
  status TEXT NOT NULL DEFAULT 'success',
  error_code TEXT,
  timestamp TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS mcp_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  search_id INTEGER NOT NULL,
  url TEXT NOT NULL,
  title TEXT,
  snippet TEXT,
  position INTEGER,
  FOREIGN KEY (search_id) REFERENCES mcp_searches(id)
);

CREATE TABLE IF NOT EXISTS mcp_features (
  mcp TEXT PRIMARY KEY,
  active INTEGER NOT NULL DEFAULT 1,
  pricing TEXT NOT NULL,
  default_results INTEGER,
  source_types TEXT,
  data_format TEXT,
  strengths TEXT,
  weaknesses TEXT
);

CREATE TABLE IF NOT EXISTS mcp_signal (
  result_id INTEGER NOT NULL,
  score REAL NOT NULL,
  consensus_score REAL,
  details TEXT,
  verified_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
  PRIMARY KEY (result_id),
  FOREIGN KEY (result_id) REFERENCES mcp_results(id)
);

INSERT OR IGNORE INTO mcp_features (mcp, active, pricing, default_results, source_types, data_format, strengths, weaknesses) VALUES
  ('exa', 1, 'Free 20K/mo, then $7/1K', 3,
   'Wikipedia, docs sites, blogs',
   'Structured infobox with precise dates',
   'Clean authoritative metadata; native language results; semantic matching; sub-200ms latency',
   'Limited source diversity, 2-3 sources per query'),
  ('parallel', 1, '$5/1K searches', 10,
   'Arch Wiki, Linux docs, blogs, forums, GitHub',
   'Broad excerpts from diverse community sources',
   'Source diversity; community knowledge; 9.7 avg results; 100% success',
   'Some noise from irrelevant results'),
  ('brave', 0, 'Paid API key required', NULL,
   NULL,
   NULL,
   'Multi-tool suite (image, video, news, summarizer, place search)',
   'Requires paid subscription key; auth failures in tests');
