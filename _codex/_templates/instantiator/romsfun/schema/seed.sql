-- SHELL.SCHEMA — Seed: hardcoded values for the codex toolchain
-- The ONLY home for hardcoded values. Cited by .sh files; wrapped in
-- wrapper/; cited by the MCP server. No tool hardcodes a value elsewhere.

INSERT OR IGNORE INTO shell_values (key, value, description) VALUES
  -- browsers
  ('CDP_PORT_HEADED', '9222', 'shared Chromium CDP port (headed)'),
  ('CDP_PORT_HEADLESS', '9223', 'shared Chromium CDP port (headless)'),

  -- romsfun console sections (valid-list for browse)
  ('CONSOLE_VALID', 'super-nintendo nintendo-64 nintendo-ds game-boy game-boy-advance game-boy-color nes sega-genesis sega-saturn playstation playstation-portable playstation-2', 'romsfun console section slugs browse accepts'),

  -- timeouts (seconds)
  ('TIMEOUT_BROWSE', '45', 'browse-romsfun default timeout'),
  ('TIMEOUT_FETCH', '60', 'fetch-download default timeout'),

  -- trace evidence
  ('TRACE_HEAD', '20', 'trace-evidence default max evidence lines'),

  -- verify-archive image extensions (multi-console)
  ('IMAGE_EXTS', 'sfc smc iso cso gba gb gbc nds dsi nes gen n64 bin', 'verify-archive accepted image extensions'),

  -- launch
  ('LAUNCH_LOG', '/tmp/opencode/emulator-launch.log', 'launch-emulator default log path'),

  -- fetch-download
  ('FETCH_SELECTOR', 'a[href*="token="]', 'fetch-download default download anchor selector'),

  -- MCP servers
  ('MCP_TIMEOUT', '180', 'MCP server tool-call timeout in seconds');
