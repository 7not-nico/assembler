# Language Ring Topology Declaration

Status: completed (2026-08-02)

## Tasks

- [x] create `SPEC.LANGUAGE.RING.TOPOLOGY.md` — r0 bash, r1 ruby, r2 typescript, r3 go/rust
- [x] encode ring direction — lower rings inward, higher rings outward; ordinal precedence
- [x] encode escalation rule — devise from r0; move outward when current ring does not suffice; r3 terminates
- [x] sync entity — `r6-patlib-sync.rb --type specifications`
- [x] embed — `semantic-embed.ts --type specifications`
- [x] drift check — `semantic-drift.ts --type specifications --check`
- [x] write task report

## Context

- User directive (2026-08-02): declare ring system — r0 bash, r1 ruby, r2 typescript, r3 go and rust
- Ring direction: lower rings are inward (r0 innermost, devising base); higher rings are outward (r3 outermost, capability terminus)
- Ordinal precedence: r0 precedes r1; r1 precedes r2; r2 precedes r3
- Escalation rule: devise patterns from r0; move outward to r1 when r0 does not suffice; continue to r3; r3 terminates
- Sibling specs: `SPEC.CODE.RING.TOPOLOGY` (7 script rings), `SPEC.DIRECTORY.RING.TOPOLOGY` (4 folder rings)
- Companion spec: `SPEC.LANGUAGE.ROLE.MAP` — role per language; no `related:` cross-link required (user, 2026-08-02)
- Format: body-first with trailing backmatter (id, title, source, summary, specifies, tags, status)
- Side fix: `r6-patlib-sync.rb` root resolution — `Root = Pathname.new(__dir__).parent` resolved one level too deep; reuses shared `ROOT` from `_rb/paths.rb` (upward walk)
