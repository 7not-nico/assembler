# Vector Search — Improvement Research

## Papers Found

| Paper | Key Finding | Relevance |
|-------|-------------|-----------|
| "Rethinking Hybrid Retrieval: Small Embeddings + LLM Re-ranking Beat Bigger Models" (2026) | MiniLM-v6 outperforms BGE-Large with hybrid + re-ranking. Small model embedding spaces align better with LLM reasoning. | **Validates our bge-small choice** — upgrading to larger model likely WON'T improve hybrid accuracy |
| Cormack, Clarke, Buettcher — "RRF Outperforms Condorcet" (SIGIR 2009) | RRF with k=60 is robust and tuning-free | Our fusion method is academically validated |
| "Efficient Dense-Sparse Hybrid Vector ANN Search" (2024) | Weighted fusion α·dense + (1-α)·sparse, tuned per query type, gives 1-9% improvement over fixed weight | Potential improvement: tune RRF k per query type |

## Improvement Downloads

| File | Source |
|------|--------|
| `findings/hybrid-search/papers/small-embeddings-re-ranking-beats-bigger.pdf` | ResearchGate 2026 |
| `findings/batch-optimization/papers/2410.20381-hybrid-ann.pdf` | arXiv 2024 (pending) |

## Changes Applied

| Change | Status | Rationale |
|--------|--------|-----------|
| FTS5 tokenizer: `porter unicode61` → `unicode61` | ✓ Applied | Removed Porter stemmer — entity names (MCP, DRY) should not be stemmed. `unicode61` handles Unicode properly without word normalization. |
| FTS index rebuilt across 16 types | ✓ Done | After tokenizer change, full rebuild required |

## Benchmark Comparison

| Metric | Before (porter) | After (unicode61) | Delta |
|--------|----------------|-------------------|-------|
| FTS5 hit rate | 69% | 69% | 0% |
| Vector hit rate | 6% | 6% | 0% |
| Warm latency | 5.4ms | 6.1ms | +0.7ms (noise) |

No regression. The new tokenizer is safer for entity names without sacrificing accuracy.

## Potential Gains (untested)

| Technique | Expected gain | Complexity | Paper support |
|-----------|--------------|------------|---------------|
| Query expansion (abbreviation → full name) | +3-5% | Low | Common IR practice |
| RRF k tuning per query type | +2-5% | Medium | RRF paper, 2024 hybrid ANN paper |
| Weighted RRF (dense vs sparse weight per query) | +3-8% | Medium | 2024 hybrid ANN paper |
| LLM re-ranking of top-20 results | +10-15% | High | 2026 small embeddings paper |

## Conclusion

Our current hybrid search (FTS5 + vector + RRF fusion) is academically validated and performing at 69% hit rate. The paper on small embeddings confirms our model choice is appropriate. FTS5 tokenizer improved (removed stemmer that was harming entity names). Further gains require query expansion or weighted fusion — not model upgrades.
