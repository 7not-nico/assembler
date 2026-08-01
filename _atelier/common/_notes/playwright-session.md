# Playwright Session Notes

## Sites & Actions

### 1. Playwright MCP Docs
- URL: <https://playwright.dev/docs/getting-started-mcp>
- Action: Navigated, extracted child links, captured as EPUB + PDF
- Output:
  - `playwright-docs.epub` — single page EPUB
  - `playwright-docs.pdf` — single page PDF (chromium --print-to-pdf)
  - `playwright-docs-v2.pdf` — 6-page combined PDF (page.pdf() native)

### 2. SteamCMD Wiki
- URL: <https://developer.valvesoftware.com/wiki/SteamCMD>
- Action: Captured single page as EPUB + PDF
- Output:
  - `SteamCMD.epub`
  - `SteamCMD.pdf` — 14 pages, 481K

### 3. Arxiv — DeepSeek V4 Papers
- URL: <https://arxiv.org/search/?query=deepseek+v4&searchtype=all>
- Action: Searched, downloaded 6 PDFs directly
- Output:
  - `deepseek-v4-dspark.pdf` — DSpark speculative decoding (1.1M)
  - `deepseek-v4-trek.pdf` — TREK distillation + RL (785K)
  - `deepseek-v4-stocktake.pdf` — benchmarks V4-Pro vs others (424K)
  - `deepseek-v4-seta.pdf` — terminal agent env (1.8M)
  - `deepseek-v4-evoclaw.pdf` — V4-Pro skill learning (5.9M)
  - `deepseek-v4-dictionaries.pdf` — V4 as anchor model (581K)

### 4. Science (AAAS) via UNED
- Portal: <https://science.uned.elogim.com/>
- Auth: UNED institutional access ("Estudiantes UNED")
- Search: "ai biology" → 5,483 results
- Output: `ai-biology-findings/*.pdf` (10 articles, 11M total)

| Article | Source |
|---------|--------|
| `tyr-inhibitors-ai-chemists.pdf` | Publisher PDF (5.2M) |
| `ai-rewire-life-interactome.pdf` | Publisher PDF (1.1M) |
| `biological-data-governance-ai.pdf` | Publisher PDF (989K) |
| `ai-simplify-alphabet-life.pdf` | Publisher PDF (885K) |
| `open-endedness-synthetic-biology.pdf` | Publisher PDF (671K) |
| `ai-executives-synthetic-biology-regulation.pdf` | Browser capture (674K) |
| `ai-drug-development-data-problem.pdf` | Publisher PDF (530K) |
| `biodiversity-robotic-imaging-ai.pdf` | Publisher PDF (405K) |
| `ai-and-biology-derek-lowe.pdf` | Browser capture (360K) |
| `ai-immunologists.pdf` | Browser capture (317K) |

## Commands Created
- `CMD.CAPTURE.WEB` — `.opencode/commands/capture-web.md` — web → EPUB via Playwright + pandoc
- `CMD.CAPTURE.PDF` — `.opencode/commands/capture-pdf.md` — web → PDF via page.pdf() or ?download=true

## PDF Acquisition Methods
1. **page.pdf()** — Playwright `browser_run_code_unsafe` → `page.pdf({ path, format: 'A4' })` (general)
2. **?download=true** — Navigate to `/doi/pdf/{doi}?download=true` triggers publisher PDF download (Science only)
3. **curl** — Direct download for arxiv PDFs
4. **chromium --print-to-pdf** — Fallback via CLI (CSS/images may break)
