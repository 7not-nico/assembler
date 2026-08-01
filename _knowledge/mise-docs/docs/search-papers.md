---
name: search-papers
description: Use this skill when searching arxiv.org for academic papers by topic — it queries the arxiv API, parses results, and optionally downloads PDFs
state-profile: stateless
related: ["SKL.ACQUIRE.PAPERS"]
---
**Procedure**

1. Call `arxiv-search` tool with these args:
   - `query` — arxiv search syntax (`all:fts5+AND+all:vector`), use `+AND+` for boolean, `%22` for exact phrase
   - `maxResults` — max papers to return (default 10)
   - `category` — optional filter by category (`cs.IR`, `cs.DB`, `cs.LG`, `cs.CL`)
   - `download` — set `true` to save PDFs to `findings/{outDir}/`
   - `outDir` — subdirectory under `findings/` (default `arxiv-search`)
2. Present formatted results: title, arxiv ID, date, category, authors, abstract snippet, links
3. On `download: true` — PDFs saved as `{id-slug}.pdf` under `findings/{outDir}/`

**Gotchas**

- arxiv API treats `cat:` filter as a boost, not a hard filter — expect some off-category results
- arxiv API max results cap: 50 per query
- PDF download follows HTTP redirects automatically
- Query syntax: `all:` for all fields, `ti:` for title, `au:` for author, `abs:` for abstract
