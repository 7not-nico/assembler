CREATE TABLE IF NOT EXISTS precepts (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  source TEXT,
  summary TEXT,
  precept TEXT NOT NULL,
  enforcement TEXT,
  status TEXT DEFAULT 'active',
  priority INTEGER DEFAULT 3,
  tags TEXT,
  related TEXT,
  body TEXT NOT NULL,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
