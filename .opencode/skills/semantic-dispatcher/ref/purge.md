# Purge

**Route** — delete vector-store rows whose entity no longer exists in patlib.db.

**Target** — load `use-semantic-purge` before stale-row cleanup.

**Notes**

- Review the dry run first; set `apply` to delete.
- Run purge after rows leave patlib.db; confirm with drift.
