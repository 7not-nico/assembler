CREATE TABLE IF NOT EXISTS specifications (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  source TEXT,
  summary TEXT,
  tags TEXT,
  related TEXT,
  reference TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
