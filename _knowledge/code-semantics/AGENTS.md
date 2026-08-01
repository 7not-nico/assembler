# code-semantics — AGENTS.md

## Domain

Study of code semantics — how programs express meaning, how we reason about code structure, and how conventions emerge from usage patterns.

## Boundaries

- `doc/` — skill catalog categorized by domain
- `calculator/` — calculator implementations for convention experimentation
- `*.rb` — Ruby calculators at root level
- `precept/`, `procedure/`, `note/`, `practice/`, `reference/`, `semantic/`, `bitacora/`, `fixture/` — learning precedence chain directories
- `template/` — copyable boilerplate for new role files
- `format/` — structural format definitions and templates
- `schema/` — SQLite database (semantics.db), schema.sql, push.rb import script, url.rb URL seed, query.rb CLI
- `pending/` — pending work items and task tracking

## Skills

`doc/research.md` — compose-web, orchestrate-research, study-foundations, search-papers, search-geo, remind-research, find-skills
`doc/acquire.md` — acquire-acm, acquire-assets, acquire-papers, organize-papers, categorize-papers
`doc/audit.md` — audit-abstraction, audit-apologia, audit-command, audit-crossref, audit-investigation, audit-maxim, audit-nexus, audit-pattern, audit-protocol, audit-rule, audit-skill, audit-term, audit-tool, audit-umbrella-terms
`doc/propose.md` — propose-command, propose-investigation, propose-mcp, propose-pattern, propose-protocol, propose-rule, propose-term, propose-tool
`doc/browser.md` — use-playwright-core, use-playwright-debug, use-playwright-vision, use-playwright-network-storage, use-playwright-ai-mode
`doc/reference.md` — use-context-seven, use-exa, use-parallel-search, use-patlib, use-spec-audit, use-entity-audit, validate-spec
`doc/ruby.md` — knowledge-ruby
`doc/workflow.md` — report-outcomes, scaffold-tools, bootstrap-db, prune-stale, stage-create, survey-scripts, format-command, refactor-skill, detect-project, classify-tool
`doc/reason.md` — reason-quantitative, reason-verbal, judge-semantic, vet-proposal, guide-reasoning
`doc/system.md` — omarchy, customize-opencode, guide-architecture, guide-web, read-maxims-protocols, declare-grounded-entity, query-nerdfont

## Precepts (loaded as rules)

`precept/ACQUIRE.PAPER.CURL.md` — curl PDFs only; no HTML, no text, no other formats
`precept/WRITE.BROWSER.FIRST.md` — browser reference required before any write operation; snapshot must exist in session
`precept/PREFER.OFFICIAL.REFERENCE.md` — official language docs first; Wikipedia and tutorials are last resort
`precept/COMPOSE.WEB.SEARCH.FIRST.md` — search using exa or parallel MCP before Playwright navigation; no blind navigation
`precept/CITE.SOURCE.CROSSCHECK.md` — cite sources and cross-check claims against official references
`precept/VERIFY.CROSS.REFERENCE.md` — cross-reference multiple spec sections before asserting claims
`precept/RESEARCH.BEFORE.WRITE.md` — research one role completely before writing
`precept/DRAFT.ONE.ROLE.AT.TIME.md` — draft one SOA role per write cycle
`precept/BROWSE.AFTER.SEARCH.md` — browse into search result URLs via Playwright
`precept/CRAWL.SECTION.BY.SECTION.md` — crawl standard sections in order
`precept/CRAWL.ALL.DRAFT.EACH.md` — crawl every section before drafting any
`precept/DRAFT.ITERATE.REPEAT.md` — iterate drafts across languages after first pass
`precept/PASS.URL.TO.PLAYWRIGHT.md` — pass URL string to Playwright function
`precept/SHOW.SPEC.EXTRACT.FIRST.md` — show spec extract in conversation before semantic analysis
`precept/EXTRACT.EVALUATE.ARGUE.md` — extract page content via evaluate, then argue grounding
`precept/DISCRIMINATE.FORMAT.PRECEPT.md` — put format definitions in format/, procedures in precept/
`precept/SPEECH.GROUNDED.EXTRACT.md` — communicate through the extracted HTML text; each claim cites a specific line from the extraction

## Formats

`format/FRONTMATTER.ROLE.FILE.md` — template and field reference for YAML frontmatter in semantic role files. Ten fields: id, language, role, title, definition, sources, canonical, tags, status, precedes. Dot separator in id, no hyphens.

## Procedures

`procedure/RUBY.SQLITE3.IMPORT.md` — import role file YAML frontmatter into semantics.db via Ruby + SQLite3. Covers schema tables, push.rb glob-and-upsert pipeline, YAML quoting constraints, and query examples.

## Semantic role files

42 role files in `semantic/` across 15 languages, each with Subject-Object-Action tripartition:

- `C.SUBJECT`, `C.OBJECT`, `C.ACTION` — lvalue, rvalue, statement
- `JAVA.SUBJECT`, `JAVA.OBJECT`, `JAVA.ACTION` — class and instance, typed value, statement with normal/abrupt completion
- `RUBY.SUBJECT`, `RUBY.OBJECT`, `RUBY.ACTION` — receiver, argument, method dispatch
- `PERL.SUBJECT`, `PERL.OBJECT`, `PERL.ACTION` — variable with sigil, value in context, operator and function
- `HASKELL.SUBJECT`, `HASKELL.OBJECT`, `HASKELL.ACTION` — pure function and monad, type and type class, function application and pattern match
- `PYTHON.SUBJECT`, `PYTHON.OBJECT`, `PYTHON.ACTION` — name in namespace, object with identity/type/value, statement and expression
- `JAVASCRIPT.SUBJECT`, `JAVASCRIPT.OBJECT`, `JAVASCRIPT.ACTION` — execution context, ECMAScript language value, evaluation of parse node
- `COMMONLISP.SUBJECT`, `COMMONLISP.OBJECT`, `COMMONLISP.ACTION` — form, self-evaluating object, evaluation of form
- `FORTH.SUBJECT`, `FORTH.OBJECT`, `FORTH.ACTION` — data stack, stack cell value, word execution
- `TYPESCRIPT.SUBJECT`, `TYPESCRIPT.OBJECT`, `TYPESCRIPT.ACTION` — typing environment, type and value, type check and transpilation
- `SCALA.SUBJECT`, `SCALA.OBJECT`, `SCALA.ACTION` — object, expression value, method and function application
- `SAGEMATH.SUBJECT`, `SAGEMATH.OBJECT`, `SAGEMATH.ACTION` — parent (mathematical structure), element (value in a parent), category dispatch and coercion
- `RUST.SUBJECT`, `RUST.OBJECT`, `RUST.ACTION` — place (memory location with ownership context), value (bit pattern interpreted through type), evaluation (expression evaluation with borrow-check gate)
- `GO.SUBJECT`, `GO.OBJECT`, `GO.ACTION` — variable (storage location with static and dynamic type), value (typed quantity), statement and expression (control flow + value computation with goroutines/defer/select)
- `RACKET.SUBJECT`, `RACKET.OBJECT`, `RACKET.ACTION` — location (storage cell per binding, fresh per application), value (self-evaluating expression, reference to object), simplification (redex reduction within continuation)

All registered in `schema/semantics.db` via `ruby schema/push.rb`.

## Delegation

Root provides patterns, terms, and shared infrastructure. This project owns code semantics research — understanding how meaning flows through programs and how we reason about it.
