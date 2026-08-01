CREATE TABLE IF NOT EXISTS protocols (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  source TEXT,
  protocol TEXT,
  enforcement TEXT,
  status TEXT DEFAULT 'active',
  priority INTEGER DEFAULT 3,
  tags TEXT,
  related TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
