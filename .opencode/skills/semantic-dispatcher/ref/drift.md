# Drift

**Route** — compare patlib.db rows against the vector store: MISSING (db row without embedding), STALE (embedding without db row).

**Target** — load `use-semantic-drift` before consistency checks.

**Notes**

- Omit `type` for the full report; scope it for one table.
- Embed MISSING rows — they lack embeddings.
- Purge STALE rows — they lack db rows.
- Run drift after any DB or vector change — confirm sync.
