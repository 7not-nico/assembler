---
name: acquire-papers
description: Use this skill when downloading raw PDFs from arxiv, Science, and other academic sources — it acquires via curl, verifies with file, and saves to findings with kebab-case naming
state-profile: hybrid
---
**Procedure**

- 1. Determine target papers — arxiv search, journal browse, or user specification
- 2. Acquire — `curl -sL -o findings/{name}.pdf '{url}'` for all sources
- 3. Fallback — `page.pdf()` via `browser_run_code_unsafe` when curl returns HTML or errors
- 4. Save to `findings/` — kebab-case slug, subdirectories for multi-paper hauls
- 5. Verify — `file {path}.pdf` confirms PDF, `pdfinfo {path}.pdf | grep Pages`

**Rules**

- `curl` first for every source — raw PDF download preferred
- `page.pdf()` fallback when `curl` returns HTML or error
- `chromium --headless --print-to-pdf` last resort only
- Save to `findings/` with kebab-case naming
- Always `file`-verify after download

**Acquisition priority**

- `curl -sL -o findings/{name}.pdf '{url}'` — universal primary
- `page.pdf()` browser-native capture — general fallback
- `chromium --headless --print-to-pdf` — last resort, CSS/images may break

**Naming convention**

- `{slug}.pdf` — kebab-case, no underscores
- Prefix by sub-area: `deepseek-v4-{slug}.pdf`
- Subdirectories for groups: `findings/{category}/`

**Gotchas**

- Science Robotics/Immunology may block `?download=true` — fallback to `page.pdf()`
- Journals with auth (e.g., Science UNED) — pass cookies via `-b` or fallback to Playwright
- Always `file`-verify — some sources return HTML instead of PDF
