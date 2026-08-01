# declare-grounded-entity — Entity Declaration

**Purpose** — create new patlib entities with research validation, precedence derivation, supporting papers.

## Procedure

1. **Classify** — map subject domain to entity type. Fixed directory under `entities/`.
2. **Research** — validate classification, key facts, authoritative sources via web search
3. **Derive** — per `PRE.PRECEDENCE.DERIVATION.CHAIN`
4. **Acquire** — search arxiv for supporting papers, download to `_trove/{domain-slug}/`
5. **Write** — entity file with type-appropriate frontmatter/backmatter format
6. **Sync** — `write-sync all`
7. **Report** — entity ID, ring layer, precedes chain, paper paths

## Ring Derivation Chain

```text
Ring 4 (unmeaning term)
  → "what precedes this?"
  → Ring 3 (default, no patlib entities precede)
  → Ring 2
  → Ring 1 (cognition dead end, source: set)
```

Key rules:

- `precedes:` points to narrower entities (what comes after), not ancestors
- `source:` points to nearest cognition at dead end
- Cycles → encompassing term with `source:` pointing to grounding concept

## Constraints

- Research before derivation — validate facts before tracing precedence
- Derivation before write — know ring before choosing format
- Write before sync — sync only after file complete
- Sync before report — entity queryable before reporting
- `file`-verify every downloaded PDF — reject HTML error pages <1KB
