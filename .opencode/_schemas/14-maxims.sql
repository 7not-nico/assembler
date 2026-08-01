CREATE TABLE IF NOT EXISTS maxims (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  source TEXT,
  summary TEXT,
  principle TEXT,
  enforcement TEXT,
  status TEXT DEFAULT 'active',
  priority INTEGER DEFAULT 2,
  tags TEXT,
  related TEXT,
  body TEXT NOT NULL,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
