---
name: use-semantic-drift
description: Use this skill when checking patlib/vector consistency — it reports MISSING and STALE rows per table
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

## Tools

```
  Tool             Parameters  Notes
  `semantic_drift` `type?`     Compare db rows against the vector store; report MISSING/STALE
```

## Gotchas

- Omit `type` for the full report — scope it for one table
- Embed MISSING rows — they lack embeddings
- Purge STALE rows — they lack db rows
- Run drift after any DB or vector change — confirm sync
