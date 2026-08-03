# rust-book-epub-script

Status: completed (2026-08-03)

## Tasks

- [x] probe rust-book site structure (print.html, chapters, images)
- [x] write `script/fetch-epub.rb` — fetch print.html, rewrite img refs, convert via pandoc
- [x] test the script end-to-end, verify EPUB output
- [x] update rust-docs/AGENTS.md — Tools section with the toolchain used
- [x] close todo, write report

## Context

- Target: doc.rust-lang.org/book (Rust Book) as EPUB
- Site is mdBook: `print.html` contains all 112 chapters in one page
- Images referenced as relative `img/...` (37 distinct) — must resolve to absolute URLs
- Toolchain confirmed: rg, ruby, curl, pandoc, ebook-convert, zip, unzip, wget, jq
