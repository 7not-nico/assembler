# invariant-papers.md — task list

**Project:** `_trove/` — invariant-theory paper acquisition
**Date:** 2026-07-31

## Task sequence

- [x] Search arxiv for invariant-theory papers across subfields
- [x] Select core set (8 papers, one+ per subfield)
- [x] Create `_trove/math/invariant-theory/` target directory
- [x] Write `_trove/_scripts/download-invariants.sh` (curl + PDF-magic validation)
- [x] Download 8 PDFs, validate each as `%PDF` via `file`
- [x] Recover 1112.6290 (v3 withdrawn → pin v2)
- [x] Capture metadata for all 8 via Playwright crawl → `meta.json`
- [x] Write `_trove/_scripts/register-invariants.rb` (functional Ruby, sqlite3 gem)
- [x] Register 8 papers + arxiv_metadata rows in `_trove/findings.db`
- [x] Verify DB rows (id, title, arxiv_id, published_at, file_size)
- [x] Write bitacora todo + session report
- [x] Copy + repurpose tooling scripts from `_codex/_templates/`: `run-logged.sh`,
      `slugify.sh`, `start-browser-headless.sh` (verbatim, shared infra)
- [x] Repurpose `atomic-script-template.sh` for trove `_scripts/` (guard path,
      Ruby-only DB note)
- [x] Create `_bitacora/task-stdout/`; smoke-test run-logged + slugify
- [x] Update `_trove/AGENTS.md` tooling table + bitacora layer list
- [x] Repurpose `domain-agents-template.md` — trove-domain AGENTS scaffold (chain verbatim)
- [x] Seed `task-backup/backup.md` (restore convention) + `task-study/catalog-architecture.md`
- [x] Add template inventory section to `_trove/AGENTS.md`
- [x] Write session report `task-report/20260731-{ts}-template-repurposing.md`
- [x] Infra triage: keep `_golib/`, `_rustlib/`, `_lib/` (user decision)
- [x] Registry push: 22 templates + 10 reports → templates.db (push-registry repurposed: `report/` glob)
- [x] Run-logged adoption: F3 file sweep + F5 db query rerun logged in task-stdout/
- [x] Repurpose snes9x ROM pipeline → 5 paper units in `_scripts/` (browse-arxiv,
      fetch-paper, verify-paper, prepare-paper, acquire-paper)
- [x] Fix fetch-paper stalled-engine: arxiv PDFs render inline, no download event →
      context.request path (568 KB test download verified, artifact cleaned)
- [x] Update AGENTS.md tooling table (12 scripts)
- [x] Chain run: acquire paper end-to-end (figure-8 quantum invariants, math/0506456)
  - [x] invariant: browser up, predicates hold
  - [x] scripts: browse-arxiv → acquire-paper (fetch → verify → prepare)
  - [x] catalog: F3 file sweep (70 pages, %PDF)
  - [x] metadata: crawl abs page → meta.json
  - [x] register: register-invariants.rb (9/9 ok)
  - [x] verify: F5 db query (9 rows)
  - [x] record: todo + report closeout

## Status notes

- Abandoned approaches: arxiv export API from bash curl and from Ruby net/http
  (rate-limit "Rate exceeded.", connection stalls); MCP arxiv lookup (connection
  closed). Playwright crawl succeeded.
- DB interaction confined to functional Ruby `.rb` per project convention.

## Open edges

- `meta.json` sits beside PDFs — could move under `_trove/_scripts/data/` or DB
- arxiv pipeline reference (rate limits, start-browser.sh, meta.json flow) not yet
  written to task-reference/
- Chrome instance started ad hoc; canonical start via `_templates/start-browser.sh`
