# Rust coding — Agent Instructions

## Precedence chain — obligatory

Learning Precedence Chain governs all work in this project. Each layer must be completed before advancing to the next.

`precept/` → `procedure/` → `note/` → `bitacora/` → `glossary/` → `reference/` → `fixtures/`

Violating this order is prohibited. Rules govern all work. Conventions govern code.

Precepts and procedures compose — neither supersedes the other. Precepts state the rule. Procedures state the steps.

### Directory roles

`precept/` — action-domain rule files. Declarative. Governs all work.

`procedure/` — procedural chains, atomic per workflow. Numbered steps. Composes with precept.

`note/` — project aspect documentation. Precedes glossary, reference.

`bitacora/` — session walkthroughs. Name describes the work.

`glossary/` — atomic declarative term definitions. Precedes fixtures.

`reference/` — conventions, exceptions. Governs fixtures.

`fixtures/` — raw learning code. Governed by conventions.

`script/` — scripts for automation and DB population.

`bash/` — bash scripts for CLI tasks.

`bootstrap/` — scanner scripts for naming convention enforcement. Type-anchored analysis using `.` `=` `()` `\|` as syntactic anchors to derive name roles (function declaration, method call, bare call, variable assignment). Self-validating — each script scans actual code names, no word lists. Naming: `scan-{domain}.rb`.

`schema/` — SQL schema files for glossary and registry tables.

## Naming standards

`precept/` — `action-domain.md` e.g. `source-playwright.md`. Declarative action-domain. Atomic, one rule per file.

`procedure/` — `action-domain.md` e.g. `search-index.md`. Procedural chain, atomic per workflow. Same naming as precept — compose by matching domain.

`note/` — `ch{number}-{topic}.md` e.g. `ch08-collections.md`. Chapter number prefix, lowercase, hyphen-separated.

`bitacora/` — `{number}-{description}.md` e.g. `003-ch13-procedure-chain.md`. Name describes the work.

`glossary/` — `{term}.md` e.g. `ownership.md`. One term per file. Declarative style, states what the thing IS.

`reference/` — `{name}.md` e.g. `conventions.md`. Lowercase, one word.

`script/` — `{action}-{subject}.{ext}` e.g. `seed-glossary.sh`. Action-subject naming.

`bash/` — `{action}-{subject}.sh` e.g. `compile-all.sh`. Action-subject naming.

`schema/` — `{name}.sql` e.g. `glossary.sql`. Lowercase, one word, .sql extension.

`fixtures/` — `ch{number}-{aspect}.rs` e.g. `ch10-traits.rs`. Chapter prefix, aspect suffix. Header includes source, module, compile.

## Reference files

`reference/conventions.md` — code naming rules, structure, prohibitions, exceptions
`reference/element-name.md` — noun classification, agentive suffix, shadowing rules
`reference/exception.md` — documented naming overrides
`reference/reserved-words.md` — Rust keyword reference (source: doc.rust-lang.org/stable/reference/keywords.html)

`schema/glossary.sql` — glossary registry table definition

`.opencode/_rustlib/src/` — functional core patterns
