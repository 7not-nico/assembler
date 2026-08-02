# mgba-repo AGENTS.md alignment — dive wording synced with dive-agents-template

**Date:** 2026-08-02 14:55 local
**Status:** complete — 6 alignment gaps closed, heading parity verified
**Log:** verify `_bitacora/task-stdout/20260802-145333-mgba-agents-align-verify.log`; stamp `20260802-144908-mgba-agents-align-stamp.log`

## What was done

```
Flat precedence chain   `study/ → fixture/` → `study/ → concept/ → fixture/` — ring 2 already
                        carried concept/; the flat chain now matches the rings
Chain prose             "Study and fixture precede pattern" → "Study, concept, and fixture
                        precede pattern: understand the architecture, distill the named ideas,
                        prove the components, then derive the morphism"
Layer roles             `### Layer roles` subsection added — 12 per-layer bullets from the
                        template (mcp/ through per-dive layers)
backup/ bullet          `mgba-src/` + timestamped binaries → `mgba-src/` + `binaries/`
                        (timestamped) + `study-monoliths/` (pre-split study docs) — matches
                        the dive's actual backup/ contents
study/ bullet           dropped "The change inventory lists every edited code line" (lives in
                        its own section); added "each grounded with file:line anchors" — the
                        study docs already carry those anchors
Section order           Quantitative doctrine — qalc moved after Test suite (template order)
Records wording         "Templates live in" → "Templates for the dive layers live in"
```

## Metrics

| Metric | Value |
|--------|-------|
| Gaps closed | 6 of 6 |
| Headings | 9 `##` sections — diff vs template: PARITY OK |
| `concept/` occurrences | 4 (flat chain, ring 2, prose, layer roles) |
| Dive content preserved | full — study lists, precepts, fixtures, scripts, build recipe, change inventory untouched |
| Files touched | 2 (AGENTS.md, todo) + 1 report |

## Decisions

1. Single atomic Write over eight sequential edits — the full file content was in hand; one write avoids mid-state conflicts.
2. Kept dive-specific extensions verbatim — the violation paragraph retains "recording a claim without qalc"; the prose keeps the dive's ring prose; study/backup bullets keep the dive's concrete file lists.
3. Layer-roles subsection copied verbatim from the template — the dive already carries the rings block verbatim, so the layer-roles block follows the same convention.
4. Dropped the `**one concern per file**` bold from the study bullet — template phrasing carries no emphasis; wording alignment, not content change.

## Errors found

```
None — the comparison pass identified all gaps before the write; the post-write
verify confirmed heading parity and content presence on the first run.
```

## Findings

1. The dive's AGENTS.md now instantiates the current template — the improvement loop closes: template → realized instance → template revision → instance re-sync.
2. The flat-chain/ring contradiction (concept/ in ring 2, absent from the flat chain) was the only internal inconsistency; the template's chain was already correct, so the dive was the stale side.
3. Dive folders predated the wording — `backup/study-monoliths/` and study file:line anchors existed before the bullets described them; the alignment documents existing state rather than introducing it.

## Open edges

- None — the last open edge from the 20260802-063915 templates session closes here.

## Todo state

```
Completed: 10 tasks (comparison, 6 alignments, verify, report)
Pending:   none — the mgba AGENTS.md edge resolves
```
