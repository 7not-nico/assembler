# 20260731-202050-invariant-papers.md

**Date:** 2026-07-31
**Project:** `_trove/` — invariant-theory paper acquisition (math/invariant-theory)

## What was done

```
Search:    arxiv MCP — 4 query rounds across subfields (invariant theory, GIT,
           knot/quantum invariants, cohomological invariants)
Select:    core set of 8 — strongest per subfield, user-confirmed
Scripts:   _trove/_scripts/download-invariants.sh (curl + PDF magic validation)
           _trove/_scripts/register-invariants.rb (functional Ruby, sqlite3 gem)
Target:    _trove/math/invariant-theory/ — 8 PDFs, 4–43 pages each
Meta:      _trove/math/invariant-theory/meta.json — captured via Playwright crawl
DB state:  8 papers rows + 8 arxiv_metadata rows in _trove/findings.db,
           id = math/invariant-theory/{filename}, topic 'invariant-theory'
Bitacora:  task-todo/invariant-papers.md
```

## Papers registered

```
alg-geom/9402008  Variation of GIT Quotients (Dolgachev, Hu, 1994)       math.AG
math/0112026      Quandle Homology & Cocycle Knot Invariants (Carter, Saito, 2001) math.GT
1112.6290         Cohomological invariants of Weyl groups mod 2 (Ducoat, 2011) math.AG
1512.06411        Hilbert series in noncommutative invariant theory (Domokos, Drensky, 2015) math.RA
1910.11129        Instantons & concordance invariants (Kronheimer, Mrowka, 2019) math.GT
2302.03021        Kontsevich classes as topological invariants (Chen, 2023) math.GT
2506.19431        CompGIT package (Hanson, Martinez-Garcia, 2025)        math.AG
2511.07718        Invariant rings of permutation groups (Maithani, 2025) math.AC
```

## Decisions

```
- Core selection over full list: 8 papers, one+ per subfield — user-confirmed
- DB writes only in functional Ruby (.rb) — sqlite3 gem, no network in write path
- Downloads in bash (binary imperative shell), metadata via browser crawl
- Metadata source: Playwright same-origin fetch of abs pages, not export API
- 1112.6290 pinned to v2 — v3 withdrawn (404); abs page lists v3, pdf v2 serves
- meta.json beside PDFs; script reads it — decouples fetch (browser) from insert (Ruby)
```

## Errors found

```
1. arxiv API "Rate exceeded." on burst — export.arxiv.org enforces 1 req/3s,
   single connection (context7 /websites/info_arxiv_help_api confirms). Our
   MCP searches + curl probes tripped the IP limit. Fix: abandon API path
2. Ruby script hung with no output — stdout buffered when piped (not a TTY);
   looked like a stall. Fix: $stdout.sync = true
3. arxiv export API plain-http (port 80) stalls — https + UA header required
4. MCP arxiv lookup "Connection closed" — server-side connection dropped under
   the rate limit; recovered via browser crawl instead
5. Playwright "Target page closed" / ECONNREFUSED 127.0.0.1:9222 — no Chrome on
   the CDP port; config uses --cdp-endpoint, needs external browser. Fix: launch
   Chromium on 9222 (ad hoc; canonical script is _templates/start-browser.sh)
6. 1112.6290v3 404 in download script — version pin corrected to v2
```

## Findings

```
1. arxiv API rate limiting hits at burst, not just sustained load — any burst
   (search + curl + script) triggers "Rate exceeded."; cooldown then works
2. Browser crawl beats API for metadata here: same-origin fetch + DOMParser on
   abs pages yields citation_title/author/date + primary-subject, 2s spacing
3. Ruby stdout buffering + long network loops = stall illusion; sync flush and
   per-paper progress output fix both
4. findings.db papers.id convention confirmed: domain/subdomain/filename;
   arxiv_metadata.primary_category holds the math.* subject code
5. Script placement per project convention: _trove/_scripts/, DB in .rb only
```

## Open edges

```
- meta.json location (beside PDFs) — could move under _trove/_scripts/data/
- arxiv acquisition pipeline not yet documented in task-reference/
- canonical browser start (start-browser.sh) replaces ad hoc launch — redo when
  the shared MCP profile is wanted
- extension of core set: abstracts, deeper GIT-only set, or more per subfield
```

## Todo state

```
Completed: search, core selection, download script, 8 PDFs + validation,
           metadata crawl, register script (Ruby), DB upsert + verify,
           bitacora todo + report
Pending:   task-reference for arxiv pipeline, meta.json relocation,
           canonical browser launch, optional set extension
```
