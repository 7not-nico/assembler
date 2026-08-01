---
id: NEX.ACQUIRE.PIPELINE
title: "bioRxiv Acquisition Workflow — Discover, Metadata, Download, Register"
source: assembler
summary: "bioRxiv paper acquisition spans four stages — discover DOIs, fetch metadata, download PDF, register in findings DB. CLI tools and MCP tools compose the same shared lib modules."
composition: "CLI: biorxiv-find → biorxiv-get → biorxiv-dl --register → papers-query. MCP: biorxiv_find → biorxiv_get → biorxiv_download → biorxiv_register. Both paths share lib/biorxiv-{search,fetch,io,register} as functional core."
enforcement: Convention
status: active
priority: 3
tags: [biorxiv, acquisition, workflow, findings, nexus, subproject-mcp]
---

bioRxiv paper acquisition spans four stages — discover DOIs, fetch metadata, download PDF, register in findings DB. CLI tools and MCP tools compose the same shared lib modules.

## Composition

### Stage 1: Discover

bioRxiv search operates by date-range + category. Topic discovery uses Exa web search to find DOIs, then date-range + category API for targeted browsing.

| Path | Tool | What it does |
|------|------|-------------|
| CLI | `biorxiv-find --date-from --date-to --category` | Browse by date range + category |
| CLI | `biorxiv-find --doi` | Lookup specific DOI |
| MCP | `biorxiv_find` | Same operations via MCP transport |

### Stage 2: Metadata

Fetch full metadata (title, authors, abstract, category, date) from bioRxiv API.

| Path | Tool | What it does |
|------|------|-------------|
| CLI | `biorxiv-get --doi` | Single or batch DOI metadata |
| MCP | `biorxiv_get` | Same via MCP |
| Lib | `biorxiv-search.batchMetadata()` | Shared implementation |

### Stage 3: Download

Download PDF from `https://www.biorxiv.org/content/{doi}.pdf`.

| Path | Tool | What it does |
|------|------|-------------|
| CLI | `biorxiv-dl --doi --outdir --register` | Download + optionally register |
| MCP | `biorxiv_download` | Download only via MCP |
| Lib | `biorxiv-io.downloadBatch()` | Shared implementation |

### Stage 4: Register

Upsert paper record in findings.db with title, authors, abstract, DOI, source, topic.

| Path | Tool | What it does |
|------|------|-------------|
| CLI | `biorxiv-register --dir --doi` | Register existing PDF |
| MCP | `biorxiv_register` | Same via MCP |
| CLI | `biorxiv-dl --register` | Combined download + register |
| MCP | `biorxiv_pipeline` | Combined find → download → register |
| Lib | `biorxiv-register.registerBiorxivPaper()` | Shared implementation |

### Full pipeline

```
Exa (discover DOIs) → biorxiv-find/biorxiv_find (verify) → biorxiv-get/biorxiv_get (metadata)
  → biorxiv-dl/biorxiv_download (PDF) → biorxiv-register/biorxiv_register (DB)
  → papers-query (verify)
```

## Lib dependency graph

```
biorxiv-types (pure)
    ↓
biorxiv-const (pure) → biorxiv-urls (pure)
    ↓
biorxiv-fetch (io) → biorxiv-parse (pure) → biorxiv-format (pure)
    ↓
biorxiv-search (io)    biorxiv-io (io)    biorxiv-register (io)
    ↓                    ↓                    ↓
  biorxiv-find CLI     biorxiv-dl CLI       biorxiv-register CLI
  biorxiv_find MCP     biorxiv_download     biorxiv_register MCP
                       biorxiv MCP
```

## Rationale

- bioRxiv provides date-range + category search API — discovery uses Exa or date-range browsing; arxiv provides Atom XML keyword search
- MCP tools use TRNS classification per subproject exception (PROT.TOOL.AUTOMATON rule 8) — download and register are controlled write operations within the findings subproject
- Pure/IO separation follows PROT.LIB.CONTRACT — types, URLs, parsing, formatting are pure; API fetch, download, DB operations are IO
- CLI tools serve as imperative shell; lib modules provide functional core

## See also

- `ILL.ACQUIRE.BIORXIV.COMPLETE` — end-to-end walkthrough of the full pipeline
- `ILL.CLI.TO.MCP.ACQUIRE` — CLI-to-MCP methodology applied to the arxiv acquisition workflow
- `PROT.TOOL.AUTOMATON` — tool I/O classification, subproject MCP TRNS exception (rule 8)
- `PROT.LIB.CONTRACT` — lib module contract blocks, pure/IO separation
- `findings/.opencode/lib/biorxiv-*.ts` — shared functional core modules
- `findings/.opencode/tools/biorxiv-*.ts` — CLI tools (imperative shell)
- `findings/.opencode/tools/mcp-biorxiv/` — MCP server (imperative shell)
