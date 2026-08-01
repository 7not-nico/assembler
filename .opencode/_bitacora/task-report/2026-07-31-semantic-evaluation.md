# Semantic evaluation

## Completed

- Added `.opencode/tools/semantic-eval.ts`.
- Added `default`, `raw`, and `passage` query variants.
- Added Hit@K and NDCG@K metrics.
- Added sequential embedding chunks with configurable `--batch-size` after the concurrent body run stalled.
- Evaluated 259 related-ID query pairs over 558 vectors.
- Recorded MRR@1, MRR@5, MRR@10, Recall, Precision, and self-hit metrics.
- Saved results to `report/2026-07-31-semantic-evaluation.md`.

## Finding

BGE query instruction prefix produced the strongest tested K=10 result: MRR 0.1163, Recall 0.2399, Hit 0.3629, NDCG 0.1324. Raw query produced MRR 0.1000, Hit 0.3282, NDCG 0.1152. `passage:` produced MRR 0.0773, Hit 0.2625, NDCG 0.0862.

## Open edges

Related-ID labels approximate relevance. Human-labeled query sets remain the next validation step.
