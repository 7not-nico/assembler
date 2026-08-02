# Task report — Language Ring Topology declaration

Date: 2026-08-02
Topic: language-ring-topology
Status: completed

## What was done

1. Declared `SPEC.LANGUAGE.RING.TOPOLOGY` — new specification entity at `.opencode/entities/specifications/SPEC.LANGUAGE.RING.TOPOLOGY.md`
   - Four language rings: r0 bash (innermost, devising base), r1 ruby, r2 typescript, r3 go+rust (outermost, capability terminus)
   - Ring direction: lower rings inward, higher rings outward
   - Ordinal precedence: r0 → r1 → r2 → r3; devising starts at r0, escalates outward when the current ring does not suffice, r3 terminates
   - Body-first markdown with trailing backmatter (id, title, source, summary, specifies, tags, status), matching sibling ring specs `SPEC.CODE.RING.TOPOLOGY` and `SPEC.DIRECTORY.RING.TOPOLOGY`
   - Written per communication rules: SOV register, active voice, finite verbs, root nouns, code block for ring data
2. Recorded todo — `.opencode/_bitacora/task-todo/2026-08-02--language-ring-topology.md`
3. Synced entity into patlib.db — 26 specifications synced, exit 0
4. Embedded entity into vector store — 1 specification embedded
5. Verified drift — 26 DB / 26 VEC, 0 missing, 0 stale

## Decisions

- New spec entity rather than modification of `SPEC.LANGUAGE.ROLE.MAP` — ring topology is a distinct classification concern (per MAX.ATOMIC.CONCERN.MODULE)
- Ring direction explicit: r0 innermost, r3 outermost — per user directive "lower rings are inward, higher rings are outward"
- Escalation rule explicit: devise from r0; move outward when insufficient; r3 terminates
- `related:` cross-link to `SPEC.LANGUAGE.ROLE.MAP` not added — user directive "related is not required"

## Side fix

`r6-patlib-sync.rb` carried a path bug: `Root = Pathname.new(__dir__).parent` resolved to `.opencode/` (one level too deep), producing nonexistent `.opencode/.opencode/patlib.db` and `SQLite3::CantOpenException`. Fix: reuse shared `ROOT` from `_rb/paths.rb` (upward-walk resolver). Sync verified working after fix.

## Logs

- `task-stdout/20260802-074323-language-ring-sync.log` — sync: 26 specifications, exit 0
- `task-stdout/20260802-074332-language-ring-embed.log` — embed: 1 specification, exit 0
- `task-stdout/20260802-074429-language-ring-drift.log` — drift: 0 missing, 0 stale, exit 0
- Failed pre-fix run (reference): `task-stdout/20260802-074043-language-ring-sync.log` — CantOpenException, exit 1

## Open edges

- None. Todo state summary: all 7 tasks completed.
