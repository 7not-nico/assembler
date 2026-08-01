CREATE TABLE IF NOT EXISTS chem (
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
ALTER TABLE chem ADD COLUMN type TEXT;
ALTER TABLE chem ADD COLUMN precedes TEXT;
