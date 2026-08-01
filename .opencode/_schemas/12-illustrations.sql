CREATE TABLE IF NOT EXISTS illustrations (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  summary TEXT,
  illustration TEXT,
  illustrates TEXT,
  tags TEXT,
  source TEXT,
  related TEXT,
  body TEXT NOT NULL,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
