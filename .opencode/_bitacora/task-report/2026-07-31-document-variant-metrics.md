# Document variant metrics

## Evaluation

The evaluation used 259 related-ID query pairs, 558 indexed entities, BGE query instruction prefix, and K=10.

## Results

| Document vector | MRR@10 | Recall@10 | Precision@10 | Hit@10 | NDCG@10 | Self-hit@10 |
|---|---:|---:|---:|---:|---:|---:|
| Stored title + body | 0.1163 | 0.2399 | 0.0456 | 0.3629 | 0.1324 | 259/259 |
| Title only | 0.0943 | 0.2087 | 0.0398 | 0.3243 | 0.1112 | 259/259 |
| Body text | 0.1163 | 0.2399 | 0.0456 | 0.3629 | 0.1324 | 259/259 |

## Finding

Stored title-plus-body vectors beat title-only vectors across every completed retrieval metric. Title-only vectors still produce perfect self-hit, so self-hit does not measure related-entity quality.

## Execution state

Sequential batch execution completed the body variant. Body text matches the stored title-plus-body construction, so all metrics match exactly.

## Stall fix

The evaluator now embeds sequential chunks with `--batch-size N` (default `16`). Example:

```bash
bun run .opencode/tools/semantic-eval.ts --documents body --batch-size 8
```
