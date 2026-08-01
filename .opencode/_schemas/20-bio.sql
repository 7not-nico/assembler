CREATE TABLE IF NOT EXISTS bio (
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
ALTER TABLE bio ADD COLUMN type TEXT;
ALTER TABLE bio ADD COLUMN precedes TEXT;
