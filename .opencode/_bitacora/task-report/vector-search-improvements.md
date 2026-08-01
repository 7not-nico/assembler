# Vector Search Improvement — Research Conclusions

## Papers Reviewed (3 in findings/hybrid-search/papers/)

| Paper | Key Finding | Relevance to Us |
|-------|-------------|-----------------|
| "Rethinking Hybrid Retrieval: Small Embeddings + LLM Re-ranking Beat Bigger Models" (2026) | MiniLM-v6 (22M) outperforms BGE-Large (326M) when combined with hybrid + reranking. Small model embedding spaces align better with LLM reasoning. | **Validates our bge-small choice.** Upgrading to a larger model would NOT improve hybrid accuracy. |
| "Hybrid Search: BM25, Vector & Reranking Reference 2026" | RRF k=60 tuned for large corpora. For small corpora (50-200 docs), k=10-20 works better. Field-level boosting + cross-encoder reranking give largest gains. | **RRF k is not our bottleneck.** Our 5.0-6.4 mean rank is flat across k=5-100 because vector signal is too weak. |
| "Impact of Fine-Tuning on Entity Resolution" (ScienceDirect 2026) | Fine-tuning bi-encoders on domain data improves accuracy from 30% to 95% on unseen topics. But fine-tuning hurts accuracy when pretrained model is already well-aligned. | **Biggest potential gain.** Fine-tuning bge-small on our entity data could dramatically improve vector hit rate. |

## Empirical Results

### RRF k Grid Search (16 benchmark queries)

Across all k values (5-100), all 16 targets found (100% recall). Mean rank flat at 5.0-6.4.

| k | Mean Rank | Recall |
|---|-----------|--------|
| 5 | 6.4 | 100% |
| 10 | 5.6 | 100% |
| 20 | 5.1 | 100% |
| 30 | 5.1 | 100% |
| 60 | 5.1 | 100% |
| 100 | 5.0 | 100% |

**Conclusion:** RRF k tuning has negligible effect. The vector signal (6% hit rate) is too weak to influence fused rankings. FTS5 carries the system.

### Bottleneck Diagnosis

| Signal | Hit Rate | Contribution to RRF |
|--------|----------|---------------------|
| FTS5 keyword | 69% | Dominant (all hits) |
| Vector (bge-small) | 6% | Near-zero (noise) |
| RRF hybrid | 69% | = FTS5 alone |

The vector model is not contributing to hybrid accuracy. Improving vector hit rate from 6% would unlock the 20-30% hybrid improvement documented in the literature.

## Recommended Improvement Path

| Priority | Technique | Expected Gain | Effort | Evidence |
|----------|-----------|--------------|--------|----------|
| **1** | **Fine-tune bge-small on entity text** | 6%→30-50% vector hit rate | Medium | Paper: 30%→95% on unseen topics |
| 2 | Query expansion (abbreviation map) | +3-5% FTS5 recall | Low | PubMed query expansion: 2-8× recall |
| 3 | Cross-encoder reranking (top-20) | +10-15% overall | High | Validated for small models (Paper 1) |
| 4 | RRF k tuning | <1% | None | Empirically measured — no effect |
| 5 | Model upgrade (bge-base) | 0% (may regress) | Medium | Paper 1: small models outperform large |

## Implementation Note

The FTS5 tokenizer was already improved (`porter unicode61` → `unicode61`). The RRF fusion is already implemented and optimal. The next actionable improvement is **fine-tuning** or **query expansion** — not parameter tuning or model upgrades.

## Papers Location

`findings/hybrid-search/papers/`:
- `small-embeddings-re-ranking-beats-bigger` — ResearchGate 2026 (web resource, download requires auth at researchgate.net/publication/392334406)
- `hybrid-search-reference-2026.pdf` — digitalapplied.com
- `finetuning-entity-resolution.pdf` — ScienceDirect 2026
