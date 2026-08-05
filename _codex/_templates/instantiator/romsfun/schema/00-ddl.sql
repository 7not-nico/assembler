-- SHELL.SCHEMA — DDL: the shell_values table
-- The ONLY home for hardcoded values in the codex toolchain.
-- shell/schema/seed.sql seeds this table; .sh files cite it; wrapper/
-- wraps the tools; the MCP server cites the wrappers.

CREATE TABLE IF NOT EXISTS shell_values (
  key         TEXT PRIMARY KEY,
  value       TEXT NOT NULL,
  description TEXT
);
