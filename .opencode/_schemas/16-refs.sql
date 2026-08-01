CREATE TABLE IF NOT EXISTS refs (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  source TEXT,
  ref_text TEXT,
  tags TEXT,
  related TEXT,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);
