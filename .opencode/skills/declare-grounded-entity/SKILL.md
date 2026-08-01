---
name: declare-grounded-entity
description: Declare a patlib entity by grounding it through web research validation, precedence derivation, and supporting paper acquisition — then write and sync
state-profile: hybrid
related: [SKL.PROPOSE.TERM, SKL.SEARCH.PAPERS]
terms: []
patterns: [NEX.META.PROPOSAL, PAT.META.ENTITY.LIFECYCLE]
---

**Procedure**

1. **Classify** — map subject domain to entity type (BIO, CHEM, TERM, TAX, ML, etc.). Each type has a fixed directory under `entities/` and a specific format convention (frontmatter vs backmatter, required fields).

2. **Research** — validate classification, key facts, and authoritative sources via web search MCP. Compile verified identifiers and reference URLs.

3. **Derive** — per PRE.PRECEDENCE.DERIVATION.CHAIN: start as Ring 4 (unmeaning term), trace "what precedes this?" outer→inner. Declared patlib entities in the chain populate `precedes:` field. Dead end at cognition sets `source:` (Ring 1). Cycles form domains requiring encompassing terms.

4. **Acquire** — search arxiv for supporting papers via `arxiv-search`. Download to `_trove/{domain-slug}/`. `file`-verify every PDF.

5. **Write** — create entity file in `entities/{type-dir}/`. Body: `**{Title}** — {definition}. {Expanded description.}` Backmatter or frontmatter per type convention with validated sources in `reference:`.

6. **Sync** — `write-sync all`

7. **Report** — entity ID, ring layer, precedes chain, paper paths

**Gotchas**

- Backmatter vs frontmatter differs per entity type — verify format before writing
- `precedes:` points to *narrower* entities (what comes after), not ancestors
- Encyclopedic entities use 3 segments, Axiomatic use 4 per `RUL.ENTITY.SEGMENT.COUNT`
- Ring 3 default when no patlib entities precede — `source:` points to nearest cognition
- `file`-verify every downloaded PDF — reject HTML error pages under 1KB

**Rules**

- Research before derivation — validate facts before tracing precedence
- Derivation before write — know the ring before choosing format
- Write before sync — sync only after the file is complete
- Sync before report — entity must be queryable before reporting complete
