# _templates — Agent Instructions

## Domain

The `_templates/` folder hosts bootstrap templates for knowledge projects. This system scaffolds `_knowledge/` projects and tracks its own improvement. The registry database and the semantic engine record the template set and its history.

## Role

The `_templates/` project owns four responsibilities:

- **Project scaffolding** — `scaffold-knowledge.sh` creates the 13-layer chain.
- **Template definitions** — per-layer boilerplate, naming conventions, and anchored skills live here.
- **Registry and semantic search** — templates and reports stay queryable by meaning.
- **Improvement loop** — `report/` records every session's errors and findings.

## Toolchain

```text
scaffold-knowledge.sh {name} "{domain}" [--with-skills]
    creates _knowledge/{name}/ — the 13-layer chain, AGENTS.md, schema, push script
    --with-skills copies 16 anchored skills into docs/ (CMD.ANCHOR.WORKFLOW)

copy-skills.sh {dest-docs} {skill}...
    copies each .opencode/skills/{skill}/SKILL.md → {dest}/{skill}.md (flattened)

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

## Precedence chain — obligatory

```text
format/ → precept/ → procedure/ → research/ → concept/ → note/ → bitacora/
→ glossary/ → schema/ → script/ → reference/ → fixtures/ → practice/
```

Scaffolds create this chain. The `_templates/` project is the chain's source, not a member.

## Layer semantics (governing rule)

```text
research/   raw verbatim captures — grounds concepts
concept/    EVERY concept arising from research must be written — none skipped
note/       HIGH-SIGNAL distilled content only — no verbatim
reference/  CITATIONS from the site — verbatim quotes, claim mapping
```

## Naming conventions

`reference/naming-conventions.md` (template at `naming-conventions-template.md`) defines the 13-layer patterns, rationale, rules, and exceptions.

## Formatting conventions

- Code blocks take precedence over md tables — all templates use code blocks.
- Template artifacts contain no md tables.

## Session reports — improvement loop (obligatory)

Every session on a bootstrapped project writes a session report into `report/` (precept `write-report.md`):

```text
filename: {YYYYMMDD}-{HHMMSS}.md
shape:    report/report-template.md
content:  what was done, decisions, errors found, findings, open edges, todo state
```

Errors and findings feed template fixes — each session improves the next. `templates.db` records the per-session error and finding counts.

## Template inventory

`*template.md` files sit at the root — one per layer plus infrastructure:

- bootstrap: AGENTS.template.md, scaffold-knowledge.sh, copy-skills.sh
- layers: format, precept, procedure, research, concept, note, bitacora, glossary, schema, reference, fixtures, practice
- codex dive layers: pattern-template.md, atomic-script-template.sh, precedence-chain.md
- conventions: naming-conventions, write-report, browse-playwright, anchor-workflow
- infrastructure: schema-template.sql, push-script-template.rb, report-template.md
- tooling: run-logged.sh, slugify.sh, start-browser.sh, start-browser-headless.sh (copied into dives by copy-templates.sh)

## Delegation

Root provides patterns, terms, and shared substrate (`_lib/embed.ts`, `_lib/score.ts` — imported, never modified). This project owns the knowledge-project bootstrap system.
