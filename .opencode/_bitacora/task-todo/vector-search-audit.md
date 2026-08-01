- [ ] confirm patlib-vector.db is WAL mode
- [ ] verify all 13 entity types have embeddings >0
- [ ] verify FTS index rebuilt and queryable
- [ ] test: patlib_vector_search --query "knowledge classification" --mode hybrid
- [ ] test: patlib_vector_search --query "finite automata" --mode keyword
- [ ] verify: entity not found returns clear error, not crash
- [ ] verify: search across cognitions/concepts/definitions after classification
- [ ] benchmark: query latency per mode

## Verification results
- [x] cognitions reindexed: 12 items, 36 embeddings (12×3)
- [x] concepts reindexed: 20 items, 60 embeddings (20×3)
- [x] terms reindexed: 44 items, 132 embeddings (44×3)
- [x] vectors present for migrated entities
- [x] entity lookup resolves correct titles
