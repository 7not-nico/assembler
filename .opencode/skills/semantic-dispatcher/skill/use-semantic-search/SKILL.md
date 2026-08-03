---
name: use-semantic-search
description: Use this skill when searching patlib entities by meaning — it embeds natural-language queries and reads ANN top-k matches with titles
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

## Tools

```
  Tool              Parameters                              Notes
  `semantic_search` `query`, `k?` (1-50, default 10), `type?`  Embed the query; return ANN top-k matches with titles
```

## Gotchas

- Describe the query in natural language — the embedder matches meaning, not keywords
- Scope with `type` when the entity kind is known — omit for a full-corpus sweep
- Set `k` to the result bound — 1 to 50, default 10
- Read the ranked hits with scores — the score shows semantic distance
