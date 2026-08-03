# toolchain-reference-help

Timestamp: 2026-08-03 20260803-052827

## What was done

- Captured verbatim `--help` output for the full toolchain, each logged to task-stdout: `ebook-convert --help` (`help-capture-ebook`), `curl --help all` + `curl --help` short form (`help-capture-curl`, `help-capture-curl-short`), `unzip --help` + `zip --help` (`help-capture-zip`), `wget --help` + `jq --help` + `timeout --help` (`help-capture-misc`), `rg --version`/`--help` + `ruby --version` (`help-capture-rg-ruby`). tracexec help already captured in the prior task.
- Wrote six reference files in `rust-docs/reference/` following the reference-template shape (Source / Citations verbatim / Claim mapping / Governs), code-block format, 0 md tables:
  - `tracexec.md` (prior task), `pandoc.md`, `curl.md`, `ebook.md`, `unzip.md` (includes zip section), `rg.md` (includes jq/wget/timeout/ruby sections)
- Verified the layer (`reference-layer-verify`): 6 files present, 0 md tables across all.
- Closed todo `2026-08-03--toolchain-reference-help.md`.

## Decisions

- Verbatim `--help` output is the canonical citation — tools document themselves; no external docs needed.
- One reference file per tool, lowercase `{name}.md`; small companion tools (zip, jq, wget, timeout, ruby) share a file with the primary tool where they cluster naturally.
- Code-block formatting only, matching the `_templates` convention.

## Open edges

- None — reference layer now holds 6 tool citations; all session tool claims are grounded.

## Todo state

- [x] capture --help for ebook-convert, curl, zip/unzip, wget, jq, timeout, rg, ruby
- [x] write reference files per tool
- [x] verify layer — 0 md tables
- [x] close todo, write report

Logs: `bitacora-helpref-todo`, `help-capture-ebook`, `help-capture-curl`, `help-capture-zip`, `help-capture-misc`, `help-capture-rg-ruby`, `help-capture-curl-short`, `reference-layer-verify`, `bitacora-helpref-close` → `_knowledge/_bitacora/task-stdout/`.
