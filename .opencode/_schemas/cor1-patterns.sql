CREATE TABLE IF NOT EXISTS patterns (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  source TEXT,
  summary TEXT,
  principle TEXT,
  enforcement TEXT,
  status TEXT DEFAULT 'draft',
  priority INTEGER DEFAULT 5,
  tags TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
