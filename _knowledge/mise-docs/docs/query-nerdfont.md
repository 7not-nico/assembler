---
name: query-nerdfont
description: Use this skill when referencing Nerd Font glyphs — it enforces nerdfont/sets/ as the authoritative source and excludes training memory and external references
state-profile: stateful-reader
type: reference
---

**Gotchas**

- Always query the DB for icon names, codepoints, and set membership. Training memory disabled for this scope — query instead
- Use `nerdfont/sets/` files and the DB for glyph data. External sources excluded
- When a glyph is unavailable — report absent. Guessing excluded
- The nerdfont project has its own `.opencode/` — tools must run with `workdir` set correctly
