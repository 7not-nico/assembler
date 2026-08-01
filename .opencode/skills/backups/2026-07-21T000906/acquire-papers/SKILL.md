---
name: acquire-papers
description: Discover and download raw PDFs from arxiv, Science, and other academic sources
state-profile: hybrid
---

**Trigger** — paper discovery or download task

**Procedure**

- 1. Determine target papers — arxiv search, journal browse, or user specification
- 2. Choose acquisition method by source:
  - **arxiv** — `curl -sL -o findings/{name}.pdf 'https://arxiv.org/pdf/{id}'`
  - **Science journals** — navigate to `https://science.uned.elogim.com/doi/pdf/{doi}?download=true`, collect from `.playwright-mcp/`
  - **Fallback** — `page.pdf()` via `browser_run_code_unsafe` to `findings/{name}.pdf`
- 3. Save to `findings/` — kebab-case slug, subdirectories for multi-paper hauls
- 4. Verify — `file {path}.pdf` confirms PDF, `pdfinfo {path}.pdf | grep Pages`

**Rules**

- Raw publisher PDF preferred over browser capture
- `page.pdf()` fallback when publisher blocks `?download=true`
- `chromium --headless --print-to-pdf` last resort only
- Save to `findings/` with kebab-case naming
- Always `file`-verify after download

**Acquisition priority**

- Raw publisher PDF — curl for arxiv, `?download=true` for Science
- `page.pdf()` browser-native capture — general fallback
- `chromium --headless --print-to-pdf` — last resort, CSS/images may break

**Naming convention**

- `{slug}.pdf` — kebab-case, no underscores
- Prefix by sub-area: `deepseek-v4-{slug}.pdf`
- Subdirectories for groups: `findings/{category}/`

**Gotchas**

- Science Robotics/Immunology block `?download=true` — use `page.pdf()` instead
- arxiv PDFs download directly via curl — no auth required
- Science requires UNED institutional session — cookie-based auth, use Playwright
- Always `file`-verify — some sources return HTML instead of PDF
