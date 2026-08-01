-- 25-manifests.sql — manifests table DDL
-- manifests are Chronicle R1 entities (MAN.* prefix)
-- Backmatter format: free-form body + trailing YAML block

CREATE TABLE IF NOT EXISTS manifests (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  source TEXT DEFAULT '',
  tags TEXT DEFAULT '[]',
  related TEXT DEFAULT '[]',
  created TEXT DEFAULT (datetime('now')),
  modified TEXT DEFAULT (datetime('now'))
);
