---
name: use-semantic-embed
description: Use this skill when embedding patlib entities — it upserts rows into the vector store, scoped or full
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

## Tools

```
  Tool             Parameters                  Notes
  `semantic_embed` `type?`, `force?` (default false)  Embed patlib entities into the vector store (upsert)
```

## Gotchas

- Scope with `type` to bound the run — omit for all tables
- Set `force` to re-embed existing rows — leave false for new rows only
- Run embed after new or edited entities land in patlib.db
