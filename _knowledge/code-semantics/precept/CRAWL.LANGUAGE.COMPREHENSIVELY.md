# CRAWL.LANGUAGE.COMPREHENSIVELY — research every major doc section before writing

Researching a language for semantic analysis requires crawling through all major sections of its official documentation, not just the minimum needed to fill the three role slots. A partial crawl misses semantic context that connects Subject, Object, and Action.

## Scope

For each language, the crawl must cover:

1. **Execution model** — how programs start, run, and terminate
2. **Data model** — types, values, variables, storage
3. **Expression semantics** — how expressions are evaluated
4. **Operator semantics** — precedence, associativity, overloading
5. **Control flow** — conditionals, loops, branching, exception handling
6. **Subroutine/function semantics** — calling conventions, argument passing, return values
7. **Scope and visibility** — lexical vs dynamic scope, namespaces
8. **Built-in variables** — default subjects, special state carriers
9. **Built-in functions** — core action catalog
10. **Predefined types** — fundamental Object categories

## Procedure

1. Identify the official documentation site (perldoc.perl.org, docs.ruby-lang.org, docs.python.org, etc.)
2. Open the table of contents or index page via Playwright
3. Snapshot each major section before advancing to the next (CRAWL.SECTION.BY.SECTION)
4. Extract key spec paragraphs for each area
5. Only after all sections are browsed, begin drafting role files

## What partial research misses

- Ruby without Modules and Classes misses singleton class `self` semantics
- Perl without perlvar misses the default `$_` subject behavior
- Python without the execution model misses the frame stack
- Haskell without typeclass semantics misses method dispatch

Each role file draws from the full crawl. A skipped section creates a blind spot in the analysis.

Composes with: CRAWL.SECTION.BY.SECTION, CRAWL.ALL.DRAFT.EACH, SHOW.SPEC.EXTRACT.FIRST, RESEARCH.BEFORE.WRITE
