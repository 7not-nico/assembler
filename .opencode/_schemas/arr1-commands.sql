CREATE TABLE IF NOT EXISTS commands (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  source TEXT,
  tags TEXT,
  related TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
