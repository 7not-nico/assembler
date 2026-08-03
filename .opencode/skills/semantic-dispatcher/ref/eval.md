# Eval

**Route** — measure retrieval quality over related-ID pairs: MRR, Recall, Precision, Hit, NDCG.

**Target** — load `use-semantic-eval` before quality checks.

**Notes**

- Use `stored` documents for a fast run; `body` re-embeds content columns.
- Vary the query variant — `default`, `raw`, or `passage`.
- Set `k` to the rank cutoff; read overall and per-type metrics.
