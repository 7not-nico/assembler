---
id: PAT.EMBEDDING.BATCH
title: Sequential Embedding Batches — Bound Memory and Engine Stability
source: PROT.SEARCH.EMBEDDING
summary: Process embedding inputs in bounded sequential batches so model memory remains stable and each batch yields observable progress.
morphism: TRNS — embedding inputs → bounded batches → stable vectors
enforcement: Convention
tags: embedding, batching, memory, stability, metrics
status: active
priority: 2
---

Embedding inputs → bounded batches → stable vectors.

## Rules

1. Select a bounded batch size before embedding a document collection.
2. Process one batch at a time through the embedding model.
3. Emit progress after every completed batch.
4. Record batch size, input count, model, and elapsed result in the metrics report.
5. Resume the next document or variant after the current batch sequence completes.
6. Reduce batch size when engine memory or runtime stability degrades.

## Applicability

Apply this pattern to semantic indexing, evaluation studies, document-vector variants, and embedding workflows whose input collection exceeds a safe single-call size.

## See also

- `PROT.SEARCH.EMBEDDING` — vector-search embedding contract
- `PAT.TRACER.PRACTICE` — validate a thin end-to-end path before growth
- `PAT.SCHEMA.RELOAD` — repeatable staged data loading
- `.opencode/tools/semantic-eval.ts` — sequential batch implementation
