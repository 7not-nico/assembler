---
id: ILL.ACQUIRE.COMPLETE
title: "bioRxiv Paper Acquisition — End-to-End Walkthrough"
source: PROT.MCP.SERVER
summary: "Walkthrough of the full bioRxiv acquisition pipeline: browse recent papers, fetch metadata, download PDF, register in findings DB, query back."
illustration: "A bioRxiv neuroscience paper was acquired through five stages: date-range browse found 30 papers, DOI lookup returned full metadata, PDF download produced a valid 3MB file, DB registration upserted title/authors/abstract/topic, and papers-query confirmed the record with correct source and DOI."
illustrates: [NEX.ACQUIRE.BIORXIV.PIPELINE]
tags: walkthrough,biorxiv,acquisition,findings,nexus
related: [NEX.ACQUIRE.BIORXIV.PIPELINE, PROT.TOOL.AUTOMATON, PROT.LIB.CONTRACT]
---

## Context

The findings subproject needed bioRxiv paper acquisition: browse by date-range + category, fetch metadata, download PDFs, register in the local SQLite database. bioRxiv provides date-range + category search API; arxiv provides Atom XML keyword search. Discovery uses date-range browsing or Exa-based DOI discovery.

Prerequisites:
- `findings/.opencode/tools/biorxiv-*.ts` — CLI tools
- `findings/.opencode/tools/mcp-biorxiv/` — MCP server
- `findings/.opencode/lib/biorxiv-*.ts` — shared functional core
- `PROT.TOOL.AUTOMATON` rule 8 — subproject MCP TRNS exception

## Walkthrough

### Step 1: Browse by date range + category

bioRxiv provides date-range + category search. No keyword search — topic discovery uses Exa web search to find DOIs, then the date-range API for targeted browsing:

```
bun run tools/biorxiv-find.ts \
  --date-from 2025-07-20 --date-to 2025-07-20 \
  --category neuroscience --format table
```

30 papers returned for a single day in neuroscience. The output includes title, DOI, authors, abstract snippet.

### Step 2: Verify with DOI lookup

A specific DOI from the results confirms availability:

```
bun run tools/biorxiv-find.ts --doi 10.1101/2025.07.20.665722 --format json
```

Returns full metadata: title ("RNALens: Study on 5' UTR Modeling and Cell-Specificity"), authors, publication date, category (bioinformatics), abstract.

### Step 3: Fetch full metadata

`biorxiv-get` fetches detailed metadata for one or more DOIs. Accepts comma-separated or stdin batch:

```
bun run tools/biorxiv-get.ts --doi 10.1101/2025.07.20.665722 --format json
```

Returns structured JSON with all fields used by DB registration: title, authors, abstract, category, date, version, server.

### Step 4: Download PDF

`biorxiv-dl` downloads the PDF from `https://www.biorxiv.org/content/{doi}.pdf`:

```
bun run tools/biorxiv-dl.ts --doi 10.1101/2025.07.20.665722 --outdir /tmp/mcp-biorxiv-test
```

Download produces a 3MB PDF, verified by `file` command as "PDF document, version 1.5, 4 page(s)". The `--register` flag combines download with DB registration in one step.

### Step 5: Register in findings DB

`biorxiv-register` upserts the paper record from existing PDF + API metadata:

```
bun run tools/biorxiv-register.ts \
  --dir bioinformatics/comp-bio \
  --doi 10.1101/2025.07.14.662216
```

Registers with all fields: title, authors, abstract, DOI, source ("biorxiv"), topic (from API category), published date.

### Step 6: Query back

`papers-query` confirms the record in the DB:

```
bun run tools/papers-query.ts --subdomain comp-bio --format detail
```

Output confirms:
- ID: `bioinformatics/comp-bio/2025-07-14-662216.pdf`
- Title, authors present
- Source: `biorxiv`
- DOI: `10.1101/2025.07.14.662216`
- Topic: `bioinformatics`
- Published date: `2025-07-18`

## Tool chain summary

| Stage | CLI tool | MCP tool | Lib module |
|-------|----------|----------|------------|
| Browse | `biorxiv-find` | `biorxiv_find` | `biorxiv-search.dateRangeSearch()` |
| Metadata | `biorxiv-get` | `biorxiv_get` | `biorxiv-search.batchMetadata()` |
| Download | `biorxiv-dl` | `biorxiv_download` | `biorxiv-io.downloadBatch()` |
| Register | `biorxiv-register` / `biorxiv-dl --register` | `biorxiv_register` | `biorxiv-register.registerBiorxivPaper()` |
| Query | `papers-query` | `findings_search` | `query.searchPapers()` |

## Key design decisions

1. **Functional core, imperative shell** — lib modules are pure or IO functions; tools are thin wrappers that parse args, call lib, print output
2. **Subproject MCP uses TRNS** — download and register are controlled write operations within the findings subproject, permitted by PROT.TOOL.AUTOMATON rule 8
3. **Pure/IO separation** follows PROT.LIB.CONTRACT — types, URLs, parsing, formatting are pure; API fetch, download, DB operations are IO

## See also

- `NEX.ACQUIRE.BIORXIV.PIPELINE` — the nexus this illustrates
- `PROT.TOOL.AUTOMATON` rule 8 — subproject MCP TRNS exception
- `PROT.LIB.CONTRACT` — lib module contract blocks
- `ILL.CLI.TO.MCP.ACQUIRE` — CLI-to-MCP methodology for arxiv acquisition
- `findings/.opencode/lib/biorxiv-*.ts` — shared functional core
- `findings/.opencode/tools/biorxiv-*.ts` — CLI tools
- `findings/.opencode/tools/mcp-biorxiv/` — MCP server
