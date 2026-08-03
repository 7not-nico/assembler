---
name: use-semantic-eval
description: Use this skill when measuring retrieval quality — it computes MRR, Recall, Precision, Hit, and NDCG over related-ID pairs
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

## Tools

```
  Tool            Parameters                                                      Notes
  `semantic_eval` `k?` (default 10), `variant?` (default/raw/passage), `documents?` (stored/title/body)  Measure retrieval quality metrics
```

## Gotchas

- Use `stored` documents for a fast run — `body` re-embeds content columns
- Vary the query variant — `default`, `raw`, or `passage`
- Set `k` to the rank cutoff — read overall and per-type metrics
