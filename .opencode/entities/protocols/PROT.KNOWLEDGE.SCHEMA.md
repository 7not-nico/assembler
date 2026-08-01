---
id: PROT.KNOWLEDGE.SCHEMA
title: "Knowledge Directory — Project-Local Atomic Ruby Reference"
source: NEX.META.PROPOSAL
summary: "Defines the knowledge/ directory as a project entity — directory layout, naming convention, practice tests, and sync tools. Knowledge/ holds atomic Ruby reference files for project-local use."
protocol: "Knowledge/ is a project-local directory for atomic Ruby reference files. Layout: ruby/ (atomic .md files), practice/ (runnable test-*.rb files), schema/ (DB sync tools). Naming: {qualifier}-{subject}.md. Practice tests: test-{topic}.rb with # verify: header. Sync via schema/sync-knowledge-db.rb."
enforcement: Formality
status: active
priority: 3
tags: [knowledge, directory, convention, project-structure, reference, ruby, documentation]
related: [PROT.TOOL.SCOPE]
---

The `knowledge/` directory is a project entity — a structured collection of atomic Ruby reference files, practice tests, and syncing tools. Each project that needs reusable Ruby knowledge creates `knowledge/` at its project root. `scripts/` is the canonical exemplar.

## Protocol

### Directory structure

```
knowledge/
├── ruby/           Atomic .md reference files, one concept per file
├── practice/       Runnable test-*.rb files, one per knowledge doc
├── schema/         SQLite DB, sync tool, query tool
├── *.md            Project-specific recipes (optional)
```

### Naming convention

All files in `ruby/` follow `{qualifier}-{subject}.md`. Recognized qualifiers: `core` (class name), `func` (functional pattern), `enumerable` (method group), `string` (method group), `hash` (method group), `file` / `file-io` (method group), `exception` (method group), `integer` (method group), `regexp` (method group), `kernel` (method group), `method` (object type), `to` (conversion protocol), `anonymous` (syntax feature).

Single-word filenames are prohibited — every file must have a hyphen separating qualifier from subject.

### Practice tests

Every knowledge doc in `ruby/` should have a corresponding practice test in `practice/`:

- File: `test-{topic}.rb`
- First line: `# verify: {doc}.md + {other-docs.md}`
- Requires `_helper.rb` for `assert`/`assert_raises`/`report` utilities
- Passes with 0 failures

### schema/ tools

Three files: `schema.sql` (knowledge.db DDL), `sync-knowledge-db.rb` (sync .md files into knowledge.db), `query-knowledge.rb` (query knowledge.db).

### Project-local scope

Knowledge/ is scoped to its containing project — same-named files in different projects are distinct. No global registration. The `knowledge-ruby` skill reads from the nearest `knowledge/` directory.

## Gotchas

- Single-word filename: Add qualifier prefix: `core-enumerable.md` (`enumerable.md` instead of `core-enumerable.md`)
- Missing practice test: Create practice test with `# verify: X.md` (`ruby/X.md` exists but `practice/test-X.rb` does not)
- Verify header mismatch: Update header to match actual file names (`# verify:` lists docs not in `ruby/`)
- Stale schema DB: Run `sync-knowledge-db.rb` (`knowledge.db` out of sync with `.md` files)
- Practice test failures: Fix assertion or knowledge doc (`test-X.rb` has `FAIL:` output)
- Non-compliant qualifier: Use one of: core, func, enumerable, string, hash, file, exception, integer, regexp, kernel, method, to, anonymous (`foo-bar.md` where `foo` is not a recognized qualifier)

## Enforcement

`r1-entity-naming.rb` or a dedicated `r1-knowledge-naming.rb` audit can verify the naming convention. Practice tests are manually run — no automated gate currently.

## Applicability

Any AMANDA project that creates a `knowledge/` directory. The protocol defines the invariant structure; projects extend it with project-specific root `*.md` recipes.

## See also

- `knowledge-ruby` skill — reads from `knowledge/` as authoritative source
- `scripts/AGENTS.md` — canonical project documentation
- `PROT.TOOL.SCOPE` — analogous project-scoping pattern for tools
- `scripts/guides/functional-programming.md` — FP conventions documented in knowledge/
- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — entity-type boundary rules
