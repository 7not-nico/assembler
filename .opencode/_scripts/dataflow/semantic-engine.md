# Semantic Engine — Embed + Search Dataflow

## Overview

The root semantic engine (`/home/eddyr/assembler/.opencode/`) embeds patlib entities into vector form and answers similarity queries. Two paths share one model pipeline and one vector store: **embed** (write) and **search** (read). Rust and TypeScript scorers are semantic twins — same cosine math, two execution contexts.

## Input

Source: 25 entity tables in `.opencode/patlib.db` (patterns, terms, rules, protocols, skills, concepts, specifications, nexus, maxims, persons, illustrations, …). Each table carries `id TEXT` + `title TEXT` plus body text columns.

Vector store: `.opencode/patlib-vector.db` — `embeddings(entity_type, entity_id, seq, field, vector, content_hash, model_version, source_file, source_mtime, updated)`, UNIQUE per `(entity_type, entity_id, seq, field)`, journal mode DELETE (no WAL, no sidecars).

Model: `Xenova/bge-small-en-v1.5`, 384-dim, mean pooling + L2 normalization.

## Flow — Embed (write path)

```
patlib.db (25 entity tables)
│
│  tools/semantic-embed.ts  (CLI, --type TABLE, --force)
│  tools/embed-entity.ts    (IPC twin)
│
│  1. Discovery: sqlite_master — tables with 'id TEXT' + 'title TEXT',
│     minus internal (embeddings, fts_entities, meta, notes, sqlite_sequence)
│
▼
Per table:
│
│  2. Text columns: SELECT * LIMIT 1 → first-row keys minus MetaCols
│     (id, source, tags, status, reference, type, created, modified,
│      enforcement, priority)
│  3. SELECT id + text columns
│  4. Per entity: "ID: Title. body1. body2…" (body cols truncated 2000)
│  5. Exists-check (entity_type, entity_id, seq=0, field='full') — skip
│     unless --force
│
▼
combined full-text per entity
│
│  _lib/embed.batch(texts)
│  @huggingface/transformers pipeline 'feature-extraction'
│  (lazy singleton — one model load per process)
│  mean pool + L2 normalize → Float32Array 384-dim
│
▼
upsert (idempotent):
│  INSERT ... seq=0, field='full', vector BLOB,
│  content_hash = sha256(text), model_version
│  ON CONFLICT(entity_type, entity_id, seq, field) DO UPDATE
│
▼
patlib-vector.db — one row per entity
```

## Flow — Search (read path)

```
query text
│
│  tools/semantic-search.ts  (CLI only: --query, --k, --type)
│  _lib/vector(query) — same cached pipeline → 384-dim normalized
│
▼
patlib-vector.db:
│  SELECT entity_id, entity_type, vector FROM embeddings
│  [WHERE entity_type = ?]  ORDER BY id
│  → idMap[index] = {id, type}; BLOBs → Float32Array[]
│
▼
_lib/ann.hit(query, vectors, k):
│  JSON payload → spawn _rustlib/target/release/assemble hit
│  (stdin/stdout pipe; Rust: cosine score, sort, top-k)
│
▼
hits [{index, score}]
│
│  title join: SELECT title FROM "<entity_type>" WHERE id = ?
│  (patlib.db)
▼
ranked results: rank, score, type, id, title
```

## Safety boundaries

| Boundary | Mechanism |
|----------|-----------|
| Discovery-import lock | `import.meta.main` — CLI body runs only on direct `bun run`; module import side-effect-free. opencode startup `import()`s every `tools/*.ts`; a top-level `process.exit(1)` (missing `--query`) previously terminated the server. |
| Spawn-in-server lock | CLI tools (standalone processes) use `_lib/ann.ts` — Rust spawn safe. IPC tools (inside server process) must use `_lib/score.ts` — pure in-process cosine, never spawn. |

## Shared modules

| Module | Exports | Role |
|--------|---------|------|
| `_lib/embed.ts` | `Model`, `Dimension`, `vector`, `batch` | Model pipeline (lazy singleton) |
| `_lib/ann.ts` | `score`, `hit`, `unit` | Rust ANN endpoints (CLI contexts) |
| `_lib/score.ts` | `score`, `unit`, `hit` | Pure JS cosine twin (IPC contexts) |
| `_lib/cli.ts` | `makeParser` | `--key value` / `--flag` parsing |
| `_lib/paths.ts` | `Root`, `Database`, `Store`, `Bin` | Path resolution (marker walk) |

## Rust backend

`_rustlib/target/release/assemble` — verbs `score` (pairwise cosine), `hit` (top-k), `unit` (L2 normalize). JSON over stdin/stdout; deterministic, pure.

## Conventions

- Combined full-text per entity at `seq=0`/`field='full'` — one row per entity, no duplicate hits.
- Journal mode DELETE — `PRAGMA journal_mode` absent from all active tools.
- Search is CLI-only — no IPC variant exists.
- Reports: `2026-07-30-semantic-engine-final.md`, `2026-07-30-semantic-search-rewire.md`, `2026-07-30-semantic-search-lock-fix.md`.
