"""Emit — schema SQL generation, pure."""

SCHEMA = (
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
)


def emit(rows):
    """Build the page_sources DDL + INSERT OR IGNORE seed from the row tuples."""
    lines = list(SCHEMA)
    lines.append("")
    lines.append("INSERT OR IGNORE INTO page_sources")
    lines.append("  (page, file, title, chapter, size_bytes, sha256) VALUES")
    values = []
    for page, file, title, chapter, size, sha in rows:
        esc = title.replace("'", "''")
        values.append(f"  ('{page}','{file}','{esc}',{chapter},{size},'{sha}')")
    return "\n".join(lines) + "\n" + ",\n".join(values) + ";\n"


def sections(rows):
    """Build the section_sources DDL + INSERT OR IGNORE seed from the row tuples."""
    lines = [
        "-- PROT.SECTION.SOURCE — skeleton: atomic heading files for the library",
        "CREATE TABLE IF NOT EXISTS section_sources (",
        "  id         INTEGER PRIMARY KEY AUTOINCREMENT,",
        "  order_no   INTEGER NOT NULL UNIQUE,",
        "  page       TEXT NOT NULL,",
        "  file       TEXT NOT NULL UNIQUE,",
        "  level      INTEGER NOT NULL,",
        "  title      TEXT NOT NULL,",
        "  size_bytes INTEGER NOT NULL,",
        "  sha256     TEXT NOT NULL,",
        "  fetched    INTEGER NOT NULL DEFAULT 1,",
        "  created    TEXT NOT NULL DEFAULT (datetime('now')),",
        "  updated    TEXT NOT NULL DEFAULT (datetime('now'))",
        ");",
        "",
        "INSERT OR IGNORE INTO section_sources",
        "  (order_no, page, file, level, title, size_bytes, sha256) VALUES",
    ]
    values = []
    for order_no, page, file, level, title, size, sha in rows:
        esc = title.replace("'", "''")
        values.append(
            f"  ({order_no},'{page}','{file}',{level},'{esc}',{size},'{sha}')"
        )
    return "\n".join(lines) + "\n" + ",\n".join(values) + ";\n"
