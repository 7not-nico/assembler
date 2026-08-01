CREATE TABLE IF NOT EXISTS skills (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT,
  description TEXT NOT NULL,
  trigger TEXT,
  procedure TEXT,
  gotchas TEXT,
  rules TEXT,
  skill TEXT NOT NULL,
  state_profile TEXT NOT NULL,
  related TEXT
);
