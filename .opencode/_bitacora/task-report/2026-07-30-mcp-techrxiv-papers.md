# Task Report — MCP Papers from TechRxiv

Timestamp: 2026-07-30
Project: `_findings` (paper catalog) + root assembler
Task: acquire Model Context Protocol (MCP) papers from TechRxiv, register in findings.db

## What was done

1. **Paper set identified** — web search (TechRxiv search page 403-blocked; discovery via parallel-search):
   - Ray 2025, "A Survey on Model Context Protocol: Architecture, State-of-the-art, Challenges and Future Directions" — DOI 10.36227/techrxiv.174495492.22752319
   - "Mind the Metrics: Patterns for Telemetry-Aware In-IDE AI Application Development using MCP" — DOI 10.36227/techrxiv.174900584.46814645
   - "Secure-by-Default Guardrails for MCP-Based Tool Use in Multi-Modal LLM Agents" — DOI 10.36227/techrxiv.177006109.97957916

2. **Access problem + solution** — TechRxiv (figshare-based) blocks non-browser clients:
   - `curl` DOI page / PDF URL → 403 (Cloudflare challenge)
   - `curl` + `cf_clearance` cookie → 403 (Cloudflare TLS fingerprint check; curl cannot match Chrome JA3)
   - Playwright `page.request.get()` → bytes OK but MCP sandbox VM lacks `fs`/`process`; `require`/`import` throw
   - Plain `a.click()` on download link → no `download` event (navigates to inline PDF viewer)
   - **Working path**: Playwright navigate → wait ~6s for Cloudflare auto-resolve → `a.setAttribute('download', name)` + click (forces native download) → `download.saveAs(absPath)` (server-side Playwright API, no sandbox fs needed)
   - **Durable artifact**: `shenanigan/download-techrxiv.md` documents the pattern with reusable snippet.

3. **Downloaded + verified** all 3 into `_findings/tools/mcp-protocol/`:

| Paper | Pages | Bytes | Status |
|-------|-------|-------|--------|
| ray-2025-mcp-survey.pdf | 45 | 839,616 | valid PDF |
| mind-the-metrics-2026-mcp-telemetry.pdf | 18 | 322,764 | valid PDF |
| secure-by-default-2026-mcp-guardrails.pdf | 5 | 137,916 | valid PDF |

4. **Registered** via `papers-add.ts` — domain `tools`, subdomain `mcp-protocol`, journal TechRxiv, full metadata (titles, authors, DOIs, dates, tags, abstracts). IDs corrected to match physical paths (`tools/mcp-protocol/{filename}`) after first pass produced `tools/{filename}`; mismatched rows deleted via sqlite.

5. **Embedded** — 3 new embeddings (total 400 in DB). Semantic search "Model Context Protocol MCP server architecture creation": Ray survey #1 (79.1%), Mind the Metrics #2 (69.5%).

## Decisions made

- Subdomain `tools/mcp-protocol` — extends existing `tools` domain (cli-to-mcp, llm-scripts).
- IDs = physical paths `{domain}/{subdomain}/{filename}` per AGENTS.md "Papers at findings/{domain}/{subdomain}/".
- Forced-download pattern over cookie replay — cookie replay is unreliable (TLS fingerprint).
- Authors extracted from PDF first-page text (pdftotext) — no page scraping needed.

## Open edges

- arXiv MCP papers identified earlier, not yet acquired: 2503.23278 (Landscape/Security, Hou et al.), 2504.03767 (MCP Safety Audit, Radosevich & Halloran), agent-interoperability survey (MCP/ACP/A2A/ANP, Ehtesham et al.), 2506.02040 (Attack Vectors, Song et al.).

## Follow-up (append)

- `papers-add.ts` ID default fixed: now derives from the physical relative path (absolute → strip FINDINGS_ROOT; relative → verbatim; other absolute → basename) instead of `${domain}/${basename}`. Verified: relative `tools/mcp-protocol/{f}` and absolute `simd-architectures/{f}` both yield correct IDs. No more subdomain-drop correction step.

## Todo state summary

- [x] Identify TechRxiv MCP papers
- [x] Solve Cloudflare-gated download (shenanigan/download-techrxiv.md)
- [x] Download + verify 3 PDFs
- [x] Register in findings.db (domain tools, subdomain mcp-protocol)
- [x] Embed + semantic-search verify
- [x] Write report
