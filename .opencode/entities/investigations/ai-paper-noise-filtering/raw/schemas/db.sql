-- Database schema for AI Paper Noise Filtering investigation

CREATE TABLE regions (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    pass_status TEXT NOT NULL CHECK(pass_status IN ('PASS', 'WARN', 'FAIL')),
    language TEXT NOT NULL,
    total_sources INTEGER NOT NULL DEFAULT 0,
    distinct_tools INTEGER NOT NULL DEFAULT 0,
    key_gap TEXT
);

CREATE TABLE tools (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    region_id TEXT NOT NULL REFERENCES regions(id),
    method TEXT NOT NULL,
    key_metric TEXT,
    cost_model TEXT NOT NULL CHECK(cost_model IN ('free', 'api-costs', 'commercial', 'research')),
    tool_type TEXT NOT NULL CHECK(tool_type IN ('screening', 'indexing', 'verification', 'detection', 'review')),
    url TEXT
);

CREATE TABLE indexers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    region_id TEXT NOT NULL REFERENCES regions(id),
    coverage TEXT NOT NULL,
    key_feature TEXT NOT NULL,
    platform_type TEXT NOT NULL CHECK(platform_type IN ('global', 'national', 'domain-specific')),
    url TEXT
);

CREATE TABLE sources (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    institution TEXT,
    region_id TEXT NOT NULL REFERENCES regions(id),
    source_type TEXT NOT NULL CHECK(source_type IN ('platform', 'tool', 'paper', 'report', 'policy')),
    domain_suffix TEXT NOT NULL CHECK(domain_suffix IN ('.edu', '.ac.*', '.gov', '.com', '.org', 'github')),
    commercial_flag INTEGER NOT NULL DEFAULT 0,
    key_finding TEXT,
    url TEXT
);

CREATE TABLE gaps (
    id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    region_id TEXT REFERENCES regions(id),
    severity TEXT NOT NULL CHECK(severity IN ('high', 'medium', 'low'))
);

CREATE TABLE researchers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    institution TEXT,
    region_id TEXT NOT NULL REFERENCES regions(id),
    focus TEXT NOT NULL
);

CREATE TABLE quality_frameworks (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    region_id TEXT NOT NULL REFERENCES regions(id),
    scope TEXT NOT NULL,
    dimensions TEXT NOT NULL
);
