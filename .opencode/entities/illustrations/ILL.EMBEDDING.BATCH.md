---
id: ILL.EMBEDDING.BATCH
title: Sequential Embedding Batches — Semantic Evaluation Walkthrough
source: PROT.ILLUSTRATION.SCHEMA
summary: Trace semantic evaluation through bounded embedding batches after the concurrent engine run stalls.
illustration: "semantic-eval.ts processes 259 query vectors and 558 document vectors in sequential batches of 8, emits progress after each batch, and records MRR@10 0.1163, Recall@10 0.2399, Hit@10 0.3629, and NDCG@10 0.1324."
illustrates: [PAT.EMBEDDING.BATCH]
tags: embedding,batching,metrics,stability,walkthrough
related: [PROT.SEARCH.EMBEDDING]
---

## Rationale

Concurrent embedding of the full document collection stalled the engine. Sequential batches bound each model call and expose progress.

## Walkthrough

### Step 1: Query batch

Command:

```bash
bun run .opencode/tools/semantic-eval.ts \
  --k 10 \
  --variant default \
  --documents body \
  --batch-size 8
```

`semantic-eval.ts` embeds 259 related-ID query titles in ordered groups of 8.

```text
embedded batch 8/259
embedded batch 16/259
...
embedded batch 259/259
```

### Step 2: Document batch

`semantic-eval.ts` embeds 558 document vectors in ordered groups of 8.

```text
embedded batch 8/558
embedded batch 16/558
...
embedded batch 558/558
```

Each completed batch yields a progress marker. The next batch starts after the prior batch returns.

### Step 3: Metric output

The completed body-vector run reports:

| Metric | Value |
|---|---:|
| MRR@10 | 0.1163 |
| Recall@10 | 0.2399 |
| Precision@10 | 0.0456 |
| Hit@10 | 0.3629 |
| NDCG@10 | 0.1324 |
| Self-hit@10 | 259/259 |

## See also

- `PAT.EMBEDDING.BATCH` — bounded sequential embedding morphism
- `PROT.SEARCH.EMBEDDING` — vector-search embedding contract
- `.opencode/tools/semantic-eval.ts` — batch implementation
- `report/2026-07-31-document-variant-metrics.md` — recorded metrics
