# AMANDA _templates — Agent Instructions

## Domain

`_templates/` hosts bootstrap templates for knowledge projects. It scaffolds `_knowledge/` projects and tracks its own improvement; the registry database and semantic engine record the template set and its history

## Role

- Project scaffolding — `script/scaffold-knowledge.sh` creates the 13-layer chain
- Template definitions — per-layer boilerplate, naming conventions, anchored skills
- Registry and semantic search — templates and reports stay queryable by meaning
- Improvement loop — `report/` records every session's errors and findings

## Toolchain

```text
script/scaffold-knowledge.sh {name} "{domain}" [--with-skills]
    creates _knowledge/{name}/ — 13-layer chain, AGENTS.md, schema, push script
    --with-skills copies 16 anchored skills into docs/

script/copy-skills.sh {dest-docs} {skill}...
    copies each .opencode/skills/{skill}/SKILL.md → {dest}/{skill}.md (flattened)

script/push-registry.rb
    registers templates (Layer:/Purpose:) and reports (error/finding counts)
    into schema/templates.db

script/semantic-embed.ts [--force]
    embeds template purpose+content and report content into
    schema/templates-vector.db (bun:sqlite, reuses ../../../.opencode/_lib/embed.ts)

script/semantic-search.ts --query TEXT [--k N] [--field purpose|content] [--alpha 0.55] [--ts]
    hybrid semantic + keyword search; Go binary worker default (3.8× faster),
    --ts forces in-process fallback

_golib/ann.go — Go ANN worker, binary transport over stdin/stdout
    build:  cd _golib && go build -o ann .
    proto:  stdin header nq|nv|dim|k (4×uint32 LE) → queries f32 → pool f32
            stdout per-query k + k×(idx uint32, score f32)
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

Scaffolds create this chain. The `_templates/` project is the chain's source, not a member

## Layer semantics (governing rule)

```text
research/   raw verbatim captures — grounds concepts
concept/    EVERY concept arising from research must be written — none skipped
note/       HIGH-SIGNAL distilled content only — no verbatim
reference/  CITATIONS from the site — verbatim quotes, claim mapping
```

## Naming conventions

`reference/naming-conventions.md` (template `naming-conventions-template.md`) defines the 13-layer patterns, rationale, rules, exceptions

## Formatting conventions

- Code blocks take precedence over md tables — all templates use code blocks
- Template artifacts contain no md tables

## Session reports — improvement loop (obligatory)

Every session on a bootstrapped project writes `report/{YYYYMMDD}-{HHMMSS}.md` per `report/report-template.md`: what was done, decisions, errors found, findings, open edges, todo state. Errors and findings feed template fixes; `templates.db` records per-session counts

## Template inventory

`*template.md` files sit at the root — one per layer plus infrastructure:

- bootstrap: AGENTS.template.md, script/scaffold-knowledge.sh, script/copy-skills.sh
- layers: format, precept, procedure, research, concept, note, bitacora, glossary, schema, reference, fixtures, practice
- codex dive layers: pattern-template.md, atomic-script-template.sh, precedence-chain.md, invariant-template.md, guideline-template.md, study-template.md, fixture-template.md, backup-template.md, dive-agents-template.md, dive-naming-conventions-template.md
- codex dive precepts: precept-verify-qalc-template.md, precept-record-metrics-template.md, precept-run-fixtures-template.md, precept-atomic-documents-template.md, precept-use-ripgrep-template.md, precept-use-shared-browser-template.md
- conventions: naming-conventions, write-report, browse-playwright, anchor-workflow
- infrastructure: schema-template.sql, push-script-template.rb, report-template.md
- tooling: shell/run-logged.sh, shell/slugify.sh, shell/start-browser.sh, shell/start-browser-headless.sh (copied into dives by script/copy-templates.sh)

## Delegation

Root provides patterns, terms, and shared substrate (`_lib/embed.ts`, `_lib/score.ts` — imported, never modified). This project owns the knowledge-project bootstrap system
