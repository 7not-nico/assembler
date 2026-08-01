# Data Flow — Semantic Search

Trace of `bun run .opencode/tools/semantic-search.ts --query TEXT [--k N] [--type TABLE]`.

## Pipeline Overview

```
query text
  → 1. embed (Xenova/bge-small-en-v1.5, 384-dim)
  → 2. pool read (patlib-vector.db embeddings)
  → 3. Rust ANN top-k (assemble hit)
  → 4. title join (patlib.db per entity table)
  → 5. ranked table output
```

## Stage 1 — Query Embed

| Key | Value |
|-----|-------|
| Module | `.opencode/_lib/embed.ts:12` (`vector`) |
| Model | `Xenova/bge-small-en-v1.5` |
| Dimension | 384 |
| Config | `{ pooling: "mean", normalize: true }` |
| Output | `Float32Array[384]` |

Pipeline lazy-loads on first call (`embed.ts:13-15`), cached in `pipe` module-level.

## Stage 2 — Pool Read

| Key | Value |
|-----|-------|
| Source | `.opencode/patlib-vector.db` → table `embeddings` |
| Query | `SELECT entity_id, entity_type, vector FROM embeddings ORDER BY id` (`semantic-search.ts:36`) |
| Filter | optional `WHERE entity_type = ?` when `--type` set |
| Shape | BLOB → `Float32Array` view on `.buffer` (`semantic-search.ts:48`) |
| Side arrays | `entry[]` = `{id, type}`, `pool[]` = vectors |

Empty pool → exit `"no embeddings found. run semantic-embed first."`

## Stage 3 — Rust ANN Top-k

| Key | Value |
|-----|-------|
| Module | `.opencode/_lib/ann.ts:17` (`hit`) |
| Transport | `Bun.spawn([Bin, "hit"])`, JSON over stdin/stdout (`ann.ts:40-48`) |
| Payload | `{ query: [384], vector: [[584×384]], k }` |
| Backend | `_rustlib/target/release/assemble hit` |
| Math | cosine similarity, sort desc, top-k (`_lib/score.ts:9` in-process mirror) |
| Output | `[{ index, score }]` |

Spawn is safe: CLI runs as standalone process (`import.meta.main` guard, `semantic-search.ts:84`). IPC tools use in-process `_lib/score.ts` — no spawn, no server lock.

## Stage 4 — Title Join

| Key | Value |
|-----|-------|
| Source | `.opencode/patlib.db` |
| Query | `SELECT title FROM "<entity_type>" WHERE id = ?` (`semantic-search.ts:72`) |
| Entity types | `specifications`, `precepts`, `skills`, `rules`, … per table |
| Fallback | id used as title when row missing |

## Stage 5 — Output

```
RANK  SCORE    TYPE        ID
1     0.7518   specifications SPEC.CODE.RING.TOPOLOGY
       Code Ring Topology — Script Classification and Verification Order
...
10 semantic matches for "spec on ring" (584 indexed)
```

## File Map

| Concern | File | Ring |
|---------|------|------|
| Query embed | `.opencode/_lib/embed.ts` | pure-io |
| ANN transport | `.opencode/_lib/ann.ts` | io |
| Pure math mirror | `.opencode/_lib/score.ts` | pure |
| Paths/store | `.opencode/_lib/paths.ts` | io |
| CLI parse | `.opencode/_lib/cli.ts` | io |
| Tool orchestration | `.opencode/tools/semantic-search.ts` | io |

## Embedded Entities

Embeddings produced by `embed-entity` (TRNS IPC) or `semantic-embed` CLI; drift/coverage checked via `semantic-drift`. Store journal mode: DELETE — no WAL sidecars.
