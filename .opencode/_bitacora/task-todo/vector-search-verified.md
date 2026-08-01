# Vector search — verified

- [x] 1061 embeddings across all 16 entity types
- [x] FTS5 keyword: 69% hit rate at 0.01ms
- [x] Vector only: 6% hit rate (bge-small, 384-dim)
- [x] Cold start: 269ms (model load)
- [x] Warm query: 5.4ms total (3.5 embed + 1.94 cosine + 0.01 FTS5)
- [x] Engine analysis: not suboptimal at this scale
- [x] sqlite-vec would save <1.6ms — marginal
- [x] Papers: MTEB benchmark, throughput metrics, dynamic batching, OSDI tradeoff
