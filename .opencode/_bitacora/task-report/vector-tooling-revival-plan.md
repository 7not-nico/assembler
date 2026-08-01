# Vector Tooling Revival Plan

Following MAX.ENTITY.ONTOLOGY, MAX.CODE.LAYERS dependency rings, and MAX.CATALYST.FOR.CHANGE.

## Guiding Maxims

| Maxim | Application |
|-------|-------------|
| MAX.ENTITY.ONTOLOGY | Tools are morphisms: imperative shell around a functional core. Dependencies via `// depends-on:` and `// purity:`. |
| MAX.CODE.LAYERS | Revive in ring order: PURE → DB-READ → LOCAL-READ → REMOTE-READ → LOCAL-WRITE → REMOTE-WRITE → DB-WRITE |
| MAX.ORTHOGONALITY | One thing per tool. Tools import from `_lib/` only. Read and write: separate tools. |
| MAX.DRY | Single source — logic lives in `_lib/`, tools are thin wrappers. |
| MAX.STALL.ENGINE | Never block the runtime. Batch in parallel. If a subprocess is terminated, halve the batch size. |
| MAX.CATALYST.FOR.CHANGE | Ship the smallest useful version first. 80% tool that works today beats 100% tool that ships next quarter. |
| MAX.BATCH.PROCESS | Parallel minimal segments. No full sequential. Each type in its own process. |

## Revival Order

Following MAX.CODE.LAYERS Grouping 1 (dependency rings) from innermost to outermost:

```
Phase 1: PURE / DB-READ    ───  _lib/ modules (functional core)
Phase 2: DB-READ / LOCAL-READ  ───  Reader tools (RECG class)
Phase 3: LOCAL-WRITE / DB-WRITE ───  Writer tools (TRNS class)
```

Each phase must be verified before proceeding to the next.

---

## Phase 1: Revive `_lib/` Modules (Functional Core)

Order follows dependency rings inward → outward.

### Step 1.1: PURE modules (no I/O)

These modules have no side effects and no imports from other project files. Safest to revive first.

| Module | Purity | LOC | Imports | Status |
|--------|--------|-----|---------|--------|
| `_lib/embedder.ts` | PURE | 45 | None (registry pattern) | ✅ Already clean |
| `_lib/vector-query.ts` | PURE | 52 | None | ✅ Already clean |
| `_lib/rank.ts` | PURE | 40 | None | ✅ Already clean |

**Action**: Verify purity annotations. No changes needed.

### Step 1.2: DB-READ modules

These read from databases only. Depend on pure modules.

| Module | Purity | LOC | Imports | Status |
|--------|--------|-----|---------|--------|
| `_lib/entity-lookup.ts` | DB-READ | 13 | `bun:sqlite`, `_lib/vector-query` | ✅ Already clean |
| `_lib/vector-queries.ts` | DB-READ | 63 | `bun:sqlite` | ✅ Already clean |
| `_lib/read-entities.ts` | DB-READ | ~50 | `bun:sqlite`, `_lib/db`, `_lib/entity-text` | ✅ Already clean |

**Action**: Verify purity annotations and import rings. No changes needed.

### Step 1.3: LOCAL-READ modules

| Module | Purity | LOC | Imports | Status |
|--------|--------|-----|---------|--------|
| `_lib/entity-paths.ts` | LOCAL-READ | 58 | `bun:sqlite`, `fs`, `path`, `_lib/vector-query` | ✅ Already clean |
| `_lib/ensure-vector-schema.ts` | LOCAL-READ | 67 | `bun:sqlite` | ✅ Already clean |

### Step 1.4: DB-WRITE / LOCAL-WRITE modules

| Module | Purity | LOC | Imports | Status |
|--------|--------|-----|---------|--------|
| `_lib/vector-db.ts` | DB-WRITE | 27 | `bun:sqlite`, `fs`, `path`, `_lib/paths`, `_lib/ensure-vector-schema` | ✅ Already clean |
| `_lib/reindex-entity.ts` | DB-WRITE | 130 | `bun:sqlite`, `_lib/read-entities`, `_lib/vector-query`, `_lib/entity-paths` | ✅ Already clean |
| `_lib/embedder-onnx.ts` | LOCAL-WRITE | 52 | `_lib/embedder`, `@xenova/transformers` (lazy) | ✅ Already clean |
| `_lib/vector-bench.ts` | DB-READ | 119 | `bun:sqlite`, `_lib/embedder-onnx`, `_lib/db` | ✅ Already clean |

**Phase 1 result**: All `_lib/` modules are already compliant. No fixes needed. The functional core is sound.

---

## Phase 2: Revive Reader Tools (RECG / DB-READ)

MAX.CODE.LAYERS Grouping 2: tool behavior classes. Reader tools are Acceptors or Classifiers (RECG) — they read and produce output without writing.

### Tools to convert

| Tool | Current format | Target format | Class | Priority |
|------|---------------|---------------|-------|----------|
| `similar-vectors.ts` | shebang CLI ❌ | Plugin RECG | RECG | High — no embedder needed |
| `search-vectors.ts` | shebang CLI ❌ | Plugin RECG | RECG | High — needs embedder for vector mode |
| `bench-vectors.ts` | shebang CLI ❌ | Plugin RECG | RECG | Low — diagnostic only |

### Conversion template (MAX.CATALYST.FOR.CHANGE — ship smallest first)

Start with `similar-vectors.ts` (no embedder dependency, simplest).

```typescript
// @toolclass RECG
import { tool } from "@opencode-ai/plugin"
import { initDB } from "../_lib/db"
import { initVectorDB } from "../_lib/vector-db"
import { cosineSearch, SCOPE_MODES } from "../_lib/vector-query"
import { queryEntityEmbedding, queryEmbeddingVectors } from "../_lib/vector-queries"
import { getEntityTitle } from "../_lib/entity-lookup"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "Find entities semantically similar to a given entity by ID",
  args: {
    entity_id: tool.schema.string().describe("Entity ID (e.g. MAX.DRY)"),
    type: tool.schema.string().optional().describe("Filter by entity type"),
    scope: tool.schema.string().optional().default("full").describe("Search scope: full, meta, body"),
    limit: tool.schema.number().optional().default(10).describe("Max results (max 50)"),
  },
  async execute(args) {
    crashOnError()
    const scope = args.scope ?? "full"
    const limit = Math.min(Math.max(1, args.limit ?? 10), 50)

    const vdb = initVectorDB()
    const patlib = initDB()
    try {
      const rows = queryEntityEmbedding(vdb, args.entity_id, args.type, scope)
      if (rows.length === 0) {
        return { content: [{
          type: "text" as const,
          text: JSON.stringify({ error: `Entity "${args.entity_id}" not found in vector index` }),
        }]}
      }
      const source = rows[0]
      const queryVec = new Float32Array(source.vector)
      const parsed = queryEmbeddingVectors(vdb, args.type, scope)
      const scored = cosineSearch(queryVec, parsed, limit)
      const sourceTitle = getEntityTitle(patlib, String(source.entity_type), String(source.entity_id))
      const results = scored.map(s => ({
        entity_type: s.entity_type,
        entity_id: s.entity_id,
        title: getEntityTitle(patlib, s.entity_type, s.entity_id),
        score: Math.round(s.score * 1000) / 1000,
        source: s.entity_id === args.entity_id,
      }))
      return { content: [{ type: "text" as const, text: JSON.stringify({ source: { entity_id: args.entity_id, entity_type: String(source.entity_type), title: sourceTitle }, scope, results }) }] }
    } finally {
      vdb.close()
      patlib.close()
    }
  },
})
```

Then `search-vectors.ts` (needs embedder, more complex — defer or ship minimal keyword-only first).

---

## Phase 3: Revive Writer Tools (TRNS / DB-WRITE)

| Tool | Current format | Target format | Class | Priority |
|------|---------------|---------------|-------|----------|
| `reindex-vectors.ts` | shebang CLI ❌ | Plugin TRNS | TRNS | High — needed before readers can find data |

### Conversion template

```typescript
// @toolclass TRNS
import { tool } from "@opencode-ai/plugin"
import { initDB } from "../_lib/db"
import { initVectorDB } from "../_lib/vector-db"
import { reindexEntityType } from "../_lib/reindex-entity"
import { crashOnError } from "../_lib/errors"

export default tool({
  description: "Recompute embeddings for one entity type",
  args: {
    type: tool.schema.string().describe("Entity type (e.g. maxims, patterns, terms)"),
    force: tool.schema.boolean().optional().default(false).describe("Ignore source_mtime, full recompute"),
  },
  async execute(args) {
    crashOnError()
    const { embedBatch, computeHashAsync, getModel } = await import("../_lib/embedder-onnx")
    const patlib = initDB()
    const vdb = initVectorDB()
    try {
      const result = await reindexEntityType(patlib, vdb, args.type, embedBatch, computeHashAsync, getModel, { force: args.force })
      return { content: [{ type: "text" as const, text: JSON.stringify({ type: args.type, inserted: result.inserted, skipped: result.skipped, total: result.total }) }] }
    } finally {
      vdb.close()
      patlib.close()
    }
  },
})
```

---

## Verification Gates

After each phase, verify before proceeding:

```
Phase 1 complete → smoke test: bun build --no-bundle _lib/*.ts → 0 errors
Phase 2 complete → smoke test: start fresh opencode session → no startup errors
Phase 3 complete → end-to-end: reindex → search → similar
```

---

## Execution Plan (MAX.CATALYST.FOR.CHANGE)

| Step | Action | Files | Effort |
|------|--------|-------|--------|
| 1 | Convert `similar-vectors.ts` to plugin RECG | `_disabled/similar-vectors.ts` → `tools/similar-vectors.ts` | ~5 min |
| 2 | Verify: fresh session no errors | — | ~1 min |
| 3 | Convert `reindex-vectors.ts` to plugin TRNS | `_disabled/reindex-vectors.ts` → `tools/reindex-vectors.ts` | ~5 min |
| 4 | Verify: `bun run write-sync.ts --type maxims` | — | ~1 min |
| 5 | Reindex maxims | `reindex-vectors --type maxims` | ~30s |
| 6 | Convert `search-vectors.ts` to plugin RECG (keyword-only first) | `_disabled/search-vectors.ts` → `tools/search-vectors.ts` | ~5 min |
| 7 | Verify: keyword search works | `search-vectors --query "dry" --mode keyword` | ~1 min |
| 8 | Add vector/hybrid modes to search-vectors | edit `tools/search-vectors.ts` | ~5 min |
| 9 | End-to-end: reindex → search → similar | all tools | ~2 min |
| 10 | Clean up stale config | `opencode.json`, rules, protocols | ~5 min |

**Total: ~30 min to revive all 3 tools in plugin-compliant format.**
