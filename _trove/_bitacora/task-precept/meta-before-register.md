# meta-before-register.md

**Layer:** precept/
**Naming:** `{action}-{domain}.md` — declarative, atomic.
**Composes with:** `_scripts/register-invariants.rb`, `task-invariant/invariants.md` (I7).

## Rule

Metadata lands in `meta.json` beside the PDFs before registration runs. Fetch (browser crawl) decouples from write (Ruby upsert); register reads only the captured file.

## Scope

Pipeline-level. Applies to every acquisition: crawl first, then `register-invariants.rb`.

## Why

The arxiv export API rate-limits bursts; the browser crawl succeeds where the API stalls. Capturing to a file makes the write path network-free and re-runnable — register never touches the network.

## Practice

```
- crawl:  browser evaluate on the abs page → title/authors/published/category
- shape:  meta.json keys by arxiv_id, filename field matches the catalog file
- run:    ruby _scripts/register-invariants.rb
```

## Instance

2026-07-31 — figure-8 knot paper: crawl → meta.json +1 entry → register 9/9 ok.
