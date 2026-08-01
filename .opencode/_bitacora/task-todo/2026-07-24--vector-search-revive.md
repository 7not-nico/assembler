# Vector Search — Revive

**Date**: 2026-07-24
**Priority**: P0 — 506 lines of tested code, disabled
**Source**: `reports/notes/assembler-language-recommendation/vector-search-status.md`

## Tasks

- [ ] **Flip `enabled: true`** — `opencode.json` line 36: change `"enabled": false` to `true`
- [ ] **Move tools live** — `.opencode/tools/_disabled/*vector*` → `.opencode/tools/`
  - `mcp-patlib-vector/` (directory + all files)
  - `search-vectors.ts`
  - `reindex-vectors.ts`
  - `similar-vectors.ts`
  - `bench-vectors.ts`
- [ ] **Update import paths** — `mcp-patlib-vector/index.ts` imports from `../../_lib/` (currently correct for disabled/ depth, verify after move)
- [ ] **Verify `mcp-patlib-vector/embedder.ts`** — re-exports from `_lib/embedder-onnx.ts`, should still resolve
- [ ] **Restart session** — opencode needs restart to pick up enabled MCP server
- [ ] **Test: `patlib_vector_search --query "knowledge classification" --mode hybrid`**
- [ ] **Test: `patlib_vector_search --query "finite automata" --mode keyword`**
- [ ] **Test: `patlib_vector_reindex` — scans for pending changes**
- [ ] **Test: `patlib_vector_similar --entity-id MAX.DRY`**
- [ ] **Bench: `bun run bench-vectors.ts --full --report`** — compare to 2026-07-23 baseline

## File moves

```bash
# Move MCP server directory
mv .opencode/tools/_disabled/mcp-patlib-vector .opencode/tools/mcp-patlib-vector

# Move CLI tools
mv .opencode/tools/_disabled/search-vectors.ts .opencode/tools/search-vectors.ts
mv .opencode/tools/_disabled/reindex-vectors.ts .opencode/tools/reindex-vectors.ts
mv .opencode/tools/_disabled/similar-vectors.ts .opencode/tools/similar-vectors.ts
mv .opencode/tools/_disabled/bench-vectors.ts .opencode/tools/bench-vectors.ts
```

## Post-reactivation

- [ ] Run `bench-vectors.ts --full --report` → save to `reports/vector-search-performance.md`
- [ ] Verify all todo items in `.opencode/todo/vector-search-audit.md` are checked
- [ ] Update `.opencode/todo/reindex-tool.md` — mark completed checks
- [ ] Accuracy improvement plan (fine-tune bge-small on entity data)
