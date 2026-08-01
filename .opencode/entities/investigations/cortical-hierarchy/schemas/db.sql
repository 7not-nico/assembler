-- Cortical Hierarchy Category Coding — Database Schema
-- SQLite

CREATE TABLE IF NOT EXISTS regions (
  id TEXT PRIMARY KEY,              -- e.g. 'v1-v3', 'v4', 'loc-itc', 'mtl', 'lip-parietal', 'mfc', 'pfc-ofc'
  name TEXT NOT NULL,
  hierarchy_level INTEGER NOT NULL, -- 1=earliest sensory → 7=highest frontal
  status TEXT NOT NULL              -- PASS, WARN, FAIL
);

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  region_id TEXT NOT NULL REFERENCES regions(id),
  title TEXT NOT NULL,
  url TEXT,
  year INTEGER,
  species TEXT,                     -- human, macaque, mouse, rat
  methodology TEXT,                 -- single-unit, fMRI, MEG, EEG, optogenetic, lesion
  key_finding TEXT,
  category_tuning_strength TEXT,    -- none, weak, moderate, strong
  population_level BOOLEAN,         -- true if category only at population level
  single_neuron_level BOOLEAN       -- true if category at single-neuron level
);

CREATE TABLE IF NOT EXISTS researchers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  region_id TEXT NOT NULL REFERENCES regions(id),
  institution TEXT,
  focus_area TEXT
);

CREATE TABLE IF NOT EXISTS meta_analyses (
  id TEXT PRIMARY KEY,
  citation TEXT NOT NULL,
  scope TEXT NOT NULL,
  key_finding TEXT NOT NULL,
  url TEXT
);

CREATE TABLE IF NOT EXISTS gaps (
  id TEXT PRIMARY KEY,
  area TEXT NOT NULL,
  description TEXT NOT NULL,
  severity TEXT                     -- high, medium, low
);

CREATE TABLE IF NOT EXISTS fundamentals (
  id TEXT PRIMARY KEY,
  concept TEXT NOT NULL,
  source TEXT NOT NULL,
  key_idea TEXT NOT NULL
);
