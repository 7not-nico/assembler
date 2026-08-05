# AMANDA _templates — Agent Instructions

## Domain

`_templates/` hosts bootstrap templates for knowledge projects. It scaffolds `_knowledge/` projects and tracks its own improvement; the registry database and semantic engine record the template set and its history

## Role

- Project scaffolding — `shell/scaffold-knowledge.sh` creates the 13-layer chain
- Template definitions — per-layer boilerplate, naming conventions, anchored skills
- Registry and semantic search — templates and reports stay queryable by meaning
- Improvement loop — `_codex/_bitacora/` records every session's errors and findings

## Toolchain

```text
shell/scaffold-knowledge.sh {name} "{domain}" [--with-skills]
    creates _knowledge/{name}/ — 13-layer chain, AGENTS.md, schema, push script
    --with-skills copies 16 anchored skills into docs/

shell/copy-skills.sh {dest-docs} {skill}...
    copies each .opencode/skills/{skill}/SKILL.md → {dest}/{skill}.md (flattened)

shell/bitacora-todo.sh {topic} ["{desc}"] / shell/bitacora-report.sh {topic} ["{desc}"]
    open the record: todo first, report after completion; no-clobber per topic;
    deps/record.sh owns the lifecycle (record_open)
    wrappers: wrapper/bitacora-todo.sh, wrapper/bitacora-report.sh

script/push-registry.rb
    registers templates (Layer:/Purpose:) and reports (error/finding counts)
    into script/schema/templates.db

script/semantic-embed.ts [--force]
    embeds template purpose+content and report content into
    script/schema/templates-vector.db (bun:sqlite, reuses ../../../.opencode/_lib/embed.ts)

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
script/schema/templates.db           registry — templates (id, layer, purpose, file_path, kind),
                                      reports (id, project, errors, findings)
script/schema/templates-vector.db    embeddings — (entity_id, field, vector, content_hash,
                                      model_version, source_file, source_mtime, updated)
```

## Precedence chain — obligatory

`_templates/` runs its own chain. Shared primitives precede deps; deps precede tools; tools precede wrappers; the MCP server wraps the wrappers; pattern docs derive from the toolchain's proven structures:

```text
_shared/ → deps/ → shell/ + script/ + instantiator/ → wrapper/ → mcp/ → morphism/
```

Each step depends on the ones before it. A tool task advances through the chain in order: resolve primitives, source deps, implement canonical logic, expose via wrapper, register in MCP when the tool earns it, document the morphism in morphism/ when the structure proves reusable.

Scaffolds emit the 13-layer knowledge chain (`format/ → precept/ → procedure/ → research/ → concept/ → note/ → bitacora/ → glossary/ → schema/ → script/ → reference/ → fixtures/ → practice/`). The `_templates/` project is that chain's source, not a member.

## Rings — ordinal (language + structure)

Rings follow `RING.LANGUAGE.TOPOLOGY` (r0 bash → r1 ruby+python → r2 typescript → r3 go+rust). The ring selects the language; a task rests at the innermost ring that suffices:

```text
r0  bash        shell/ — bitacora-run, run-logged, slugify, start-browser*,
                copy-*, fetch-repo, scaffold-knowledge; deps/{paths,browser,logger}.sh
r1  ruby+python script/ — push-registry.rb (schema-backed tasks)
r2  typescript  script/ — semantic-*.ts, bench.ts, stress.ts, deps/paths.ts
                mcp/ — mcp-romsfun (MCP server over the wrappers)
r3  go + rust   _shared/ — codexroot, portup, slugify Go binaries
                _rustlib/ — tpl-ann ANN worker
```

Directory roles (r0 language, canonical home): `shell/` bash tools; `script/` ruby/ts tasks + schema; `instantiator/` canonical shared code for projects; `wrapper/` thin interfaces (workflow) + `wrapper/one-off/` (bootstrap) + `wrapper/enabler/` (alias-citing shims to shared binaries); `_shared/` Go primitives; `morphism/` morphism docs + `morphism/composition/`.

A task starts at r0 (bash). It moves one ring outward when the current ring does not suffice — r1 for schema scripts, r2 for OpenCode extension, r3 for high-performance binaries. Ring r3 terminates the chain; no ring beyond it exists.

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

Every session on the codex project writes `_codex/_bitacora/task-report/{YYYYMMDD}-{HHMMSS}-{topic}.md`: what was done, decisions, errors found, findings, open edges, todo state. Errors and findings feed template fixes; `templates.db` records per-session counts

## Template inventory

`*template.md` files sit at the root — one per layer plus infrastructure:

- bootstrap: AGENTS.template.md, shell/scaffold-knowledge.sh, shell/copy-skills.sh
- layers: format, precept, procedure, research, concept, note, bitacora, glossary, schema, reference, fixtures, practice
- codex dive layers: pattern-template.md, atomic-script-template.sh, precedence-chain.md, invariant-template.md, guideline-template.md, study-template.md, fixture-template.md, backup-template.md, dive-agents-template.md, dive-naming-conventions-template.md
- codex dive pattern instances: morphism/ (wrapper-delegation, shared-deps-binary, atomic-tool-contract, location-aware-walk-up, bitacora-log-framing, mcp-tool-server, keyed-line-handoff, process-launch-health, browser-cdp-probe, dive-copy-carrier, walk-up-shim, stream-tee-frame, record-lifecycle, internal-shared-package, purity-port-pipeline, ring-prefixed-module, record-kind-taxonomy, close-report-handoff, record-find-search, schema-citation-chain, mcp-default-free, enabler-alias-shim, validated-argument-list, boot-evidence-enablement, mcp-stdio-handshake) + morphism/composition/ (shared-binary-composition, slugify-composition, bitacora-flow-composition, romsfun-toolchain-composition, emulator-boot-trace-composition)
- codex dive precepts: precept-verify-qalc-template.md, precept-record-metrics-template.md, precept-run-fixtures-template.md, precept-atomic-documents-template.md, precept-use-ripgrep-template.md, precept-use-shared-browser-template.md
- conventions: naming-conventions, write-report, browse-playwright, anchor-workflow
- infrastructure: schema-template.sql, push-script-template.rb
- tooling: shell/run-logged.sh, shell/slugify.sh, shell/start-browser.sh, shell/start-browser-headless.sh, shell/copy-templates.sh, shell/copy-skills.sh, shell/scaffold-knowledge.sh, shell/fetch-repo.sh, shell/bitacora-todo.sh, shell/bitacora-report.sh; one-off wrappers under wrapper/one-off/

## Delegation

Root provides patterns, terms, and shared substrate (`_lib/embed.ts`, `_lib/score.ts` — imported, never modified). This project owns the knowledge-project bootstrap system
