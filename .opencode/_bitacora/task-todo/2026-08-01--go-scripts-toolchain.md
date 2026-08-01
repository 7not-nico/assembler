# Go Scripts Toolchain Port

Status: completed (2026-08-01) — functional; follow-ups tracked below

## Tasks

- [x] study reference parsers: _rb/frontmatter.rb (both formats), _rs/r0_frontmatter.rs (the `(?s)` flag)
- [x] scaffold `_scripts/_golib/` Go module (8 internal packages + cmd/assembler-cli, stdlib-only)
- [x] implement frontmatter/backmatter parser — frontmatter AND trailing backmatter (gap fixed)
- [x] implement rings, patlib prefix map, entity loader (filesystem walk, upward root)
- [x] implement checks: id-match, ring-match, source (ID-shape guard), precedes (tortoise-hare), stale-refs
- [x] implement CLI: list, count, check, audit {type}, rings
- [x] fix the encyclopedic gap — cognitions 35, concepts 62, terms 28 load (Ruby parity)
- [x] build binary `bin/assembler-cli` (go build + go vet clean)
- [~] repoint `rs` launcher to Go binary — NOT DONE
- [~] update _scripts/AGENTS.md + docs (Go primary, Rust/Ruby legacy) — NOT DONE
- [x] verify: counts vs Ruby (parity, 2-file over-permissive diff), audits run, invalid-type path
- [ ] write task report — in progress (this session)

## Context

- Decision (user, 2026-08-01): port scripts toolchain to Go "instead" — Rust stays legacy like Ruby
- Go precedent: `_codex/_templates/_golib/ann.go` — binary transport, zero deps
- Bug found+fixed: frontRe lacked `(?s)` DOTALL — multi-line frontmatter blocks never matched (Context7 confirmed DotNL flag + leftmost-first semantics)
- Parity: all 23 types load; 2-file over-permissive diff vs Ruby (identities 35 vs 34, investigations 3 vs 2 — Go accepts files Ruby's YAML rejects)
- New coverage: illustrations 80 entities (57 source faults — invisible to Rust), persons faults 12→8 (COG refs now resolve)
- Audit results: protocols 0, maxims 0, nexus 0, patterns 0, persons 8 (documented id-match), illustrations 57, investigations 4

## Follow-ups (open edges)

- Illustrations 57 source faults — enumerate, disposition (fix vs crossref-audit)
- Investigations 4 faults — MANIFEST.*-in-investigations ring-match + sources
- Repoint `rs` launcher; update AGENTS.md + docs
- The 2-file over-permissive diff (identities, investigations) — investigate if strictness needed
- Rust `_rs`/`_bin` now legacy — parallel to Ruby `_rb`
