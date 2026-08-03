# Embed

**Route** — embed patlib entities into the vector store (upsert). Full run re-embeds all tables in about a minute.

**Target** — load `use-semantic-embed` before vector-store writes.

**Notes**

- Scope with `type` to bound the run; omit for all tables.
- Set `force` to re-embed existing rows; leave false for new rows only.
- Run embed after new or edited entities land in patlib.db.
