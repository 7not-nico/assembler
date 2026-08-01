# reindex-vectors CLI tool

**Maxim refs:** MAX.CODE.LAYERS (DB-READ + LOCAL-WRITE), MAX.DRY (shared libs), MAX.BUN.ONLY  
**Protocol refs:** PROT.TOOL.AUTOMATON (TRNS), PROT.TOOL.MODEL (rule 8), PROT.SEARCH.EMBEDDING (batch)

## Implementation — .opencode/tools/reindex-vectors.ts
- [ ] shebang, @toolclass TRNS
- [ ] imports: _lib/read-entities, mcp-patlib-vector/embedder, _lib/vector-query, _lib/db
- [ ] CLI args: --type, --all, --force, --help
- [ ] parallel batch: chunk(16), Promise.all(scopes), Promise.all(batches)
- [ ] insert OR REPLACE embeddings, rebuild FTS, cleanupStaleRows

## Verification
- [ ] test: --type patterns → 42 embeddings (14×3)
- [ ] test: --all → all types, sum(items×3) total
- [ ] test: patlib_vector_search returns entities after reindex
