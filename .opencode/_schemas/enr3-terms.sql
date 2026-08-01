CREATE TABLE IF NOT EXISTS terms (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  source TEXT,
  related TEXT,
  tags TEXT,
  reference TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
ALTER TABLE terms ADD COLUMN type TEXT;
