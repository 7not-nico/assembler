CREATE TABLE IF NOT EXISTS apologias (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  source TEXT,
  tags TEXT,
  related TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
