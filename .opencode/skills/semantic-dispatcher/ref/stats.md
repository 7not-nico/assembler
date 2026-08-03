# Stats

**Route** — report embedding counts per entity table in the vector store.

**Target** — load `use-semantic-stats` before vector-store inspection.

**Notes**

- Omit `type` for the full per-table count; scope it for one table.
- Read the total alongside the per-table rows.
- Use stats to spot empty tables before a search or eval run.
