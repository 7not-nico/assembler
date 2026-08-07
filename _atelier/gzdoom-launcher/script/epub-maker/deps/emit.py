"""Emit — schema SQL generation, pure."""


def emit(rows):
    """Build the page_sources DDL + INSERT OR IGNORE seed from the row tuples."""
    lines = [
        "-- PROT.PAGE.SOURCE — skeleton: DDL + seed for the fetched reference chapters",
        "CREATE TABLE IF NOT EXISTS page_sources (",
        "  id         INTEGER PRIMARY KEY AUTOINCREMENT,",
        "  page       TEXT NOT NULL UNIQUE,",
        "  file       TEXT NOT NULL UNIQUE,",
        "  title      TEXT NOT NULL,",
        "  chapter    INTEGER NOT NULL,",
        "  size_bytes INTEGER NOT NULL,",
        "  sha256     TEXT NOT NULL,",
        "  fetched    INTEGER NOT NULL DEFAULT 1,",
        "  created    TEXT NOT NULL DEFAULT (datetime('now')),",
        "  updated    TEXT NOT NULL DEFAULT (datetime('now'))",
        ");",
        "",
        "INSERT OR IGNORE INTO page_sources",
        "  (page, file, title, chapter, size_bytes, sha256) VALUES",
    ]
    values = []
    for page, file, title, chapter, size, sha in rows:
        esc = title.replace("'", "''")
        values.append(f"  ('{page}','{file}','{esc}',{chapter},{size},'{sha}')")
    return "\n".join(lines) + "\n" + ",\n".join(values) + ";\n"
