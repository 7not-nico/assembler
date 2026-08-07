-- PROT.DOWNLOAD.REGISTRY — DDL for deduplicated wad download records
-- Mirrors .opencode/_schemas/seeds/00-ddl.sql: url UNIQUE dedup, FK-safe shape.
-- Database: schema/wads.db (sqlite3)

CREATE TABLE IF NOT EXISTS wad_sources (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  file       TEXT NOT NULL UNIQUE,        -- archive name in wad/custom/, the record key
  title      TEXT NOT NULL,
  author     TEXT,
  game       TEXT NOT NULL CHECK(game IN ('doom', 'doom2', 'heretic', 'hexen', 'strife')),
  kind       TEXT NOT NULL DEFAULT 'map' CHECK(kind IN ('map', 'maps', 'episode', 'megawad')),
  size_bytes INTEGER NOT NULL,            -- verified archive size on disk
  sha256     TEXT NOT NULL,               -- full archive digest (integrity key)
  date       TEXT,                        -- release date MM/DD/YY from the listing
  source     TEXT NOT NULL,               -- idgames leaf path (mirror-agnostic)
  url        TEXT NOT NULL UNIQUE,        -- full download URL (the paste point)
  header     TEXT NOT NULL CHECK(header IN ('PWAD', 'IWAD')),
  created    TEXT NOT NULL DEFAULT (datetime('now')),
  updated    TEXT NOT NULL DEFAULT (datetime('now'))
);
