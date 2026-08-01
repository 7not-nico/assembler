# Architecture Mapping — MAX.CODE.LAYERS + MAX.ENTITY.ONTOLOGY

**Date**: 2026-07-24
**Status**: Final

## The Two Groupings

### Grouping 1 — Dependency Rings (MAX.CODE.LAYERS)

Seven ordinal rings. The Rust lib binary (napi-rs) sits at the innermost ring.
The Bun thin wrapper sits at the outermost ring.

```
Ring 1: PURE          ← Rust lib binary (assembler-lib)
Ring 2: DB-READ       ← Rust lib binary (via rusqlite)
Ring 3: LOCAL-READ    ← Bun wrapper (thin)
Ring 4: REMOTE-READ   ← Bun wrapper
Ring 5: LOCAL-WRITE   ← Bun wrapper  
Ring 6: REMOTE-WRITE  ← Bun wrapper
Ring 7: DB-WRITE      ← Bun wrapper
```

**Rule**: A file imports only from same or inward ring.
- Rust lib imports only from Rust lib (same ring) or nothing.
- Bun wrapper imports from Rust lib (inward) and Bun stdlib.
- Bun tools import from Rust lib (inward) and Bun stdlib.

### Grouping 2 — Tool Classes (MAX.CODE.LAYERS)

Five classes from automata theory + electronics. Bun tools declare their class.

| Class | Origin | Example tools |
|-------|--------|---------------|
| Acceptor | Recognizer (automata) | read-validate, audit-patterns |
| Classifier | N-ary output | search-vectors, read-selection |
| Transducer | Input→output transform | write-sync, reindex-vectors |
| Sequencer | Write-only, ordered | sync-voices |
| Signaler | Signal emission | verify-deps, bench-vectors |

**Rule**: Grouping 2 applies to tool files only. Every tool declares `// @toolclass {CLASS}`.

## Imperative Shell / Functional Core (MAX.ENTITY.ONTOLOGY)

```
┌─────────────────────────────────────────────────────┐
│              Imperative Shell (Bun)                  │
│  ┌─────────────────────────────────────────────┐    │
│  │         Functional Core (Rust .node)         │    │
│  │  ┌─────────┐ ┌──────────┐ ┌─────────────┐  │    │
│  │  │ db.rs   │ │ vector.rs│ │ embedder.rs │  │    │
│  │  │ initDB  │ │ cosine   │ │ embed       │  │    │
│  │  │ queryAll│ │ rrf      │ │ embedBatch  │  │    │
│  │  │ queryOne│ │ FTS5     │ │ cosine      │  │    │
│  │  └─────────┘ └──────────┘ └─────────────┘  │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  Tools (thin): read-selection, write-sync, audit...  │
│  Plugin (thin): assembler-lib.ts (tool: hooks)       │
└─────────────────────────────────────────────────────┘
```

### Boundary Rules

| Aspect | Functional Core (Rust) | Imperative Shell (Bun) |
|--------|----------------------|----------------------|
| Language | Rust (napi-rs) | TypeScript (Bun) |
| Dependency mgmt | Cargo (deterministic) | Bun (known issues) |
| Error handling | `Result<T, Error>` | `throw` / tool return |
| I/O | None (PURE ring) | All I/O (outer rings) |
| State | Stateless functions | Session state |
| Binary | `.node` single file | bun run / bunx |
| Crash | Never — Result always | Tool error → user message |

### Why Bun cannot be the Functional Core

The `trump-voices` experience: Bun dependency management failed — `bun install`, `bun.lock` resolution became unmanageable. Fallback to `uv` (Python) was required for fast-whisper.

Rust's `cargo` has no such issues:
- Deterministic resolution (Cargo.lock)
- Single dependency tree
- Bundled SQLite (no system dep)
- ONNX runtime via `ort` or `tract` (no Python fallback needed)

### Why Rust cannot be the Imperative Shell

Tools in this project are thin wrappers — average 19 LOC. They format I/O and register with the opencode runtime. Rust would add unnecessary complexity for:
- Tool registration (`@opencode-ai/plugin`)
- MCP protocol handling (`@modelcontextprotocol/sdk`)
- Shell commands (`$` template literals)
- File I/O (`Bun.write`, `Bun.file`)

## Entity Mapping

| Entity | Location | Role |
|--------|----------|------|
| MAX.CODE.LAYERS | `.opencode/entities/maxims/MAX.CODE.LAYERS.md` | 7 rings + 5 classes |
| MAX.ENTITY.ONTOLOGY | `.opencode/entities/maxims/MAX.ENTITY.ONTOLOGY.md` | Imperative shell + functional core |
| MAX.BUN.ONLY | `.opencode/entities/maxims/MAX.BUN.ONLY.md` | Tools = Bun. Libs = Rust. |
| PROT.TOOL.HOOKS | `.opencode/entities/protocols/PROT.TOOL.HOOKSmd` | Plugin registers tools |
| PROT.TOOL.STRUCTURE | `.opencode/entities/protocols/PROT.TOOL.STRUCTUREmd` | Plugin directory + exports |

## Precedents

| Project | Pattern | Validates |
|---------|---------|-----------|
| trump-voices | `tromp` Rust binary + TS tools | Rust + TS coexistence |
| esbuild | TS API → Rust .node | napi-rs pattern |
| sharp | require("sharp") → .node | FFI pattern |
| Codex SDK | npm pkg → napi-rs native | Plugin + native addon pattern |
