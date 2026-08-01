---
id: PAT.DOMAIN.CONTAINER
title: Domain Container — Learning Architecture as Directory Structure
source: assembler
summary: Every coherent domain gets its own directory container. Containers emerge through extraction (internal density), import (external necessity), or opacity investigation. The filesystem mirrors the understanding structure.
principle: Container per coherent domain. Container form follows origin and purpose. Extraction is one-way; import is bounded.
enforcement: Convention
tags: [architecture, learning, directory-structure, modularity, decoupling, category-theory]
patterns: [PAT.SHARED.LIB, PAT.ORTHOGONALITY, PAT.DRY, PAT.ASSEMBLER.ARCHITECTURE, PAT.ACTIVATION.MODEL]
terms: []
status: active
priority: 2
---

Container per coherent domain. Container form follows origin and purpose. Extraction one-way; import bounded.

## Context

The assembler organizes itself around cognitive boundaries. Sub-projects emerge through five signals:

| Signal | Nature | Direction | Action | Example |
|--------|--------|-----------|--------|---------|
| Reference density | Quantitative, reactive | Internal → sibling | Investigate in dedicated folder | `investigations/` from dense term cross-refs |
| Logic bloat | Quantitative, reactive | Internal → sibling | Extract to shared lib | `_lib/` from duplicated tool logic |
| Domain emergence | Qualitative, reactive | Internal → sibling | Spin out sub-project with own DB/tools | `semantic-weight/`, `ludoteca/` |
| Conceptual weight | Introspective, proactive | Internal → patlib | Formalize as term, pattern, or skill | Any `TERM.*` / `PAT.*` |
| External necessity | Import, proactive | Outside → container | Create study or investigation directory | `code-dives/nvim/`, `study-sessions/category-theory/` |

**Opacity chain** — a recurring sub-pattern. A domain is opaque at its abstraction level; to understand it, descend to an adjacent sibling that reveals implementation. Each step produces a new container:

```
game (can't see code) → console → emulator (visible implementation) → CS principles
Minecraft (opaque) → mod source (Lua, automation) → programming concepts
drawing (opaque) → Loomis planes → light → form
```

**Lifecycle** — domains progress through stages:

```
Enter opaque domain → study → understand → formalize → teach
```

**Container types:**

| Container | Purpose | Has | Persistence |
|-----------|---------|-----|-------------|
| `code-dives/{name}/` | Study opaque software | Notes, references | Persistent reference |
| `study-sessions/{name}/` | Study opaque domain | AGENTS.md, DB, notes, tests | Long-lived |
| `one-timers/{name}/` | Bounded investigation | Own DB, docs | Kept, frozen |
| `common/{name}/` | Cross-project tool | Tools, minimal scope | Active |
| `investigations/` | Dense cross-reference graph | YAML records, schemas | Grows |
| Term / Pattern / Skill | First-class patlib entity | Frontmatter, principle/rules | Permanent |

## Category theoretic view

The assembler **is** a concrete category:

- **Objects** — domain containers (directories, projects, files, modules)
- **Morphisms** — IPC tools (read/write arrows between objects), file references, imports (`_lib/`)
- **Identity** — self-reference: `id:` metadata, `AGENTS.md` on itself
- **Composition** — the LLM + user choose which morphisms chain and in what order

The hierarchy of entities within this category:

| Entity | Category role |
|--------|---------------|
| Tools (IPC) | Atomic morphisms — primary arrows |
| Imports, references | Cross-object morphisms |
| Extraction (decoupling) | Object-creation morphism |
| Skills | Composite morphisms — named chains `f ∘ g ∘ h` |
| Commands | Diagram schemas — prescribed paths user walks |
| Rules | Laws — constrain how morphisms compose |
| Patterns | Theorems — proven structures within the laws |
| Terms | Objects of discourse — named entities |
| Patlib | Internal hom — queryable index of available arrows and relations |

Patlib enables intelligent composition. LLM reads patlib → selects relevant patterns → composes tools → produces output.

## Rules

1. Extract to **sibling**, never child — new container lives alongside parent.
2. Container type follows origin — external necessity → code-dive; internal density → investigation; full domain → sub-project; conceptual weight → term/pattern.
3. Parent gets **leaner** after extraction — remove what moved; parent easier to edit, not rearranged.
4. Extraction is **one-way** — extracted content never re-merges; new container develops independently.
5. Import is **bounded** — external containers have a learning goal; persist as reference post-goal.
6. Extraction is **not pre-emptive** — wait for signal of density, bloat, weight, or necessity.
7. Teaching closes the loop — formalized understanding taught externally validates the container.

## Applicability

Any project where directory structure serves as cognitive architecture — mirroring how you learn, understand, and formalize domains. Every sub-project under `assembler/` is an instance.

## See also

- PAT.SHARED.LIB — mechanics of shared logic extraction
- PAT.ORTHOGONALITY — independence of components
- PAT.DRY — no duplication, extract shared
- PAT.ASSEMBLER.ARCHITECTURE — modular, unidirectional, non-linear, category-theoretic framing
- PAT.ACTIVATION.MODEL — rules proactive, skills reactive
