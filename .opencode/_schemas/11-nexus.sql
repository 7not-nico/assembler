CREATE TABLE IF NOT EXISTS nexus (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  source TEXT,
  summary TEXT,
  nexus TEXT,
  composition TEXT,
  status TEXT DEFAULT 'draft',
  priority INTEGER DEFAULT 5,
  tags TEXT,
  related TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
