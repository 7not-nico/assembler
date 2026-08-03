# _templates — Agent Instructions

## Domain

The `_templates/` folder hosts bootstrap templates for knowledge projects. This system scaffolds `_knowledge/` projects and tracks its own improvement. The registry database and the semantic engine record the template set and its history

## Role

The `_templates/` project owns four responsibilities:

- Project scaffolding — `scaffold-knowledge.sh` creates the lean chain
- Template definitions — per-layer boilerplate, naming conventions, and anchored skills live here
- Registry and semantic search — templates and reports stay queryable by meaning
- Improvement loop — `report/` records every session's errors and findings

## Toolchain

```text
scaffold-knowledge.sh {name} "{domain}" [--with-skills]
    creates _knowledge/{name}/ — the lean chain, AGENTS.md, layer templates
    lean chain: precept/ concept/ reference/ fixture/ (script/ parallel)
    --with-skills copies live anchored skills into skills/ (CMD.ANCHOR.WORKFLOW)

copy-skills.sh {dest-dir} {skill}...
    copies each .opencode/skills/{skill}/SKILL.md → {dest}/{skill}.md (flattened)

copy-rings.sh {dest-dir} [spec-name...]
    copies ring-topology specifications from .opencode/entities/specifications/
    default (no names): the 5-spec ring family (knowledge/code/directory/language
    topology + code element name) → {dest}/ — scaffold calls it for rings/

script/push-registry.rb
    registers templates (parses **Layer:**/**Purpose:**) and reports
    (section-scoped error/finding counts) into schema/templates.db

script/semantic-embed.ts [--force]
    embeds template purpose+content and report content into
    schema/templates-vector.db (bun:sqlite, reuses ../../../.opencode/_lib/embed.ts,
    incremental hash+mtime skip)

script/semantic-search.ts --query TEXT [--k N] [--field purpose|content] [--alpha 0.55] [--ts]
    queries the template set with hybrid semantic + keyword matching
    ANN backend: Go binary worker by default (3.8× faster at scale than in-process TS),
    --ts forces the in-process fallback; the tool auto-falls back on Go errors

_golib/ann.go — the Go ANN worker, binary transport over stdin/stdout
    build:  cd _golib && go build -o ann .
    proto:  stdin  header nq|nv|dim|k (4×uint32 LE) → queries f32 → pool f32
            stdout per-query k + k×(idx uint32, score f32)
    perf:   goroutine-parallel scoring; 3.8× vs TS in-process at 10k vectors
    lesson: transport, not language — Rust+JSON was 0.4× (serialization dominates);
            Go+binary wins. Spawn with stdin: TypedArray per Bun docs (no pipes).
```

## Databases

```text
schema/templates.db           registry — templates (id, layer, purpose, file_path, kind),
                              reports (id, project, errors, findings)
schema/templates-vector.db    embeddings — (entity_id, field, vector, content_hash,
                              model_version, source_file, source_mtime, updated)
```

Binary DBs stay untracked (gitignored) — only `schema/templates.sql` is source

## Precedence chain — lean (scaffold default)

```text
precept/ → concept/ → reference/ → fixture/    (script/ + rings/ run parallel)
```

Scaffolds create this lean chain. The `_templates/` project is the chain's source, not a member. The full 13-layer chain (`format/ → precept/ → procedure/ → research/ → concept/ → note/ → bitacora/ → glossary/ → schema/ → script/ → reference/ → fixtures/ → practice/`) lives in `precedence-chain.md` as the reference topology — projects extend the lean chain only when a layer earns its place

## Layer semantics (governing rule)

```text
concept/    EVERY concept arising from study gets written — none skipped
reference/  CITATIONS from canonical sources — verbatim quotes, claim mapping
fixture/    compilable practice material — toolchain must accept each file
```

## Naming conventions

`reference/naming-conventions.md` (template at `naming-conventions-template.md`) defines the lean-chain patterns, rationale, rules, and exceptions

## Formatting conventions

- Code blocks take precedence over md tables — all templates use code blocks
- Template artifacts contain no md tables

## Session reports — improvement loop (obligatory)

Every session on a bootstrapped project writes a session report into `report/` (scaffold places `report/report-template.md` at `precept/write-report.md`):

```text
filename: {YYYYMMDD}-{HHMMSS}.md
shape:    report/report-template.md
content:  what was done, decisions, errors found, findings, open edges, todo state
```

Errors and findings feed template fixes — each session improves the next. `templates.db` records the per-session error and finding counts

## Template inventory

`*template.md` files sit at the root — one per lean-chain layer plus infrastructure:

- bootstrap: AGENTS.template.md, scaffold-knowledge.sh, copy-skills.sh, run-logged-template.sh
- layers: precept, concept, reference, fixture
- conventions: naming-conventions, browse-playwright, anchor-workflow, backup, guideline, invariant, pattern, study
- infrastructure: schema-template.sql, push-script-template.rb, atomic-script-template.sh, report/report-template.md

Retired and superseded templates (13-layer precepts, `_rustlib` ANN experiment, duplicate report forms, dive templates) sit in `.archive/templates-legacy/` — consult before recreating

## Delegation

This project owns the knowledge-project bootstrap system
