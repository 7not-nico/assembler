---
name: use-semantic-stats
description: Use this skill when inspecting vector-store embedding counts — it reports per-table counts and totals
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

## Tools

```
  Tool             Parameters  Notes
  `semantic_stats` `type?`     Report embedding counts per entity table
```

## Gotchas

- Omit `type` for the full per-table count — scope it for one table
- Read the total alongside the per-table rows
- Use stats to spot empty tables before a search or eval run
