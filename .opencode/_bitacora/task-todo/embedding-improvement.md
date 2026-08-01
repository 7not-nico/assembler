# Embedding improvement — semantic search quality

Status: in progress (2026-07-31). Items 1, 2, 8 complete; levers 3–7 pending.

Goal: raise retrieval quality of `semantic-search` over 558 indexed patlib entities. Current: `bge-small-en-v1.5`, 384-dim, CLS pooling, single `full` vector per entity, BGE query prefix, flat cosine scan.

## Priority order

- [x] 1. pooling mean → CLS — `_lib/embed.ts` (`pooling: "cls"`); BGE model card mandates CLS
- [x] 2. query instruction prefix — `Represent this sentence for searching relevant passages: {query}` in `semantic-search.ts`; documents plain
- [ ] 3. text cleanup — drop `{id}: ` prefix from embed text (`semantic-embed.ts` line 87); title-weighted construction
- [ ] 4. chunking — long bodies → 512-token chunks, 50% overlap, max-sim aggregation; schema `seq` supports it
- [ ] 5. field embeddings — title/summary/body separate vectors, weighted fusion `w_t·sim(title)+w_b·sim(body)`
- [ ] 6. model upgrade — `bge-base-en-v1.5` (MTEB ~53.3 vs ~51.7) or `nomic-embed-text-v1.5` 768-dim; 2× storage
- [ ] 7. hybrid FTS fusion — RRF over existing `fts_entities` table + vector scores
- [x] 8. eval harness — `.opencode/tools/semantic-eval.ts`; MRR/Recall/Precision/Hit/NDCG@K over `related` pairs + query/document variants

## Verification

- [x] re-embed all: `bun run .opencode/tools/semantic-embed.ts --force` — 558 entities
- [x] drift check: `bun run .opencode/tools/semantic-drift.ts --check` — 0 missing, 0 stale
- [x] spot queries: `semantic-search --query "cognition computer science" --k 10` — PROT.COGNITION.SCHEMA 0.7469 rank 1
- [x] MRR@10 baseline recorded — prefix variant 0.1163 vs raw 0.1000 vs passage 0.0773

## Notes

- Schema already supports multi-vector: `UNIQUE(entity_type, entity_id, seq, field)`
- `fts_entities` exists unused — excluded via `Internal` set in `semantic-embed.ts`
- Pooling bug fixed: `embed.ts` now uses CLS; BGE usage is `model_output[0][:, 0]`
- Stalled engine fixed: sequential batches via `--batch-size N` in `semantic-eval.ts` → `PAT.EMBEDDING.BATCH` + `ILL.EMBEDDING.BATCH`
- Reports: `report/2026-07-31-semantic-embedding-metrics.md`, `report/2026-07-31-semantic-evaluation.md`, `report/2026-07-31-document-variant-metrics.md`
- Priority 1+2 = one-file change, no schema impact; 3–6 require reindex
