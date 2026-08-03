---
name: use-semantic-purge
description: Use this skill when cleaning stale vector-store rows — it deletes embeddings whose entity no longer exists in patlib.db
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

## Tools

```
  Tool             Parameters            Notes
  `semantic_purge` `type?`, `apply?` (default false)  Delete vector-store rows whose entity no longer exists
```

## Gotchas

- Review the dry run first — `apply` performs the delete
- Run purge after rows leave patlib.db — confirm with drift
