CREATE TABLE IF NOT EXISTS persons (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subtype TEXT NOT NULL CHECK(subtype IN ('physical', 'jurisdictional')),
  source TEXT,
  tags TEXT,
  body TEXT NOT NULL,
  created TEXT NOT NULL,
  modified TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS events (
  id    TEXT PRIMARY KEY,
  title TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS person_events (
  person_id TEXT NOT NULL REFERENCES persons(id),
  event_id TEXT NOT NULL REFERENCES events(id),
  year INTEGER NOT NULL,
  month INTEGER,
  day INTEGER,
  location TEXT,
  description TEXT,
  PRIMARY KEY (person_id, event_id, year)
);
