CREATE TABLE IF NOT EXISTS cli (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  type TEXT,
  body TEXT NOT NULL,
  source TEXT,
  tags TEXT,
  reference TEXT,
  precedes TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
