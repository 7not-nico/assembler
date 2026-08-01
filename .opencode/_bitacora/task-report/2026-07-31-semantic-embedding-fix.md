# Semantic embedding fix

## Completed

- CLS pooling replaced mean pooling for BGE document and query vectors.
- BGE retrieval instruction prefix added to query encoding.
- 558 entities re-embedded.
- Drift check passed: 0 missing, 0 stale across 28 tables.
- Metrics written to `report/2026-07-31-semantic-embedding-metrics.md`.

## Decision

Current search ranks `PROT.COGNITION.SCHEMA` first for `cognition computer science`; the report records the before/after movement.

## Open edges

- MRR@10 baseline remains pending.
- Chunking, field vectors, model comparison, hybrid FTS remain pending.
