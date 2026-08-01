CREATE TABLE IF NOT EXISTS concepts (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  mode TEXT,
  source TEXT,
  tags TEXT,
  related TEXT,
  reference TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
