# Codex templates improvement — mgba-repo doctrine folded back

**Date:** 2026-08-02 06:39 local
**Status:** complete — 11 tasks done, propagation verified, improvement loop closed
**Log:** session report `_templates/report/20260802-063345.md`; commands via `copy-templates.sh` (stdout above)

## What was done

```
precedence-chain.md       ring 0-3 ordinal structure; concept/ inserted between study/ and fixture/
dive-agents-template.md   Build flow, Test suite, qalc doctrine, Change inventory sections;
                          structure bullets gained build/, concept/, source-registered suites,
                          study-monoliths/, template/
precept-verify-qalc       new — claims pass qalc -t before recording
precept-record-metrics    new — metrics section in every report
precept-run-fixtures      new — suite + fixtures rerun after source changes
precept-atomic-documents  new — one concern per file; inventory lives in AGENTS.md
precept-use-ripgrep       new — searches run through rg
precept-use-shared-browser new — one persistent Chromium on CDP
study-template.md         inventory moved out; Concern line, Grounding block, qalc verified-math table
guideline-template.md     four-axis categorical table, formal kinds, strengths, non-invariants
backup-template.md        study-monoliths/ documented
copy-templates.sh         CODEX_FILES + 6 precept templates
AGENTS.md                 inventory + "codex dive precepts" bullet
```

## Metrics

| Metric | Value |
|--------|-------|
| Templates edited | 8 (`_templates/` root) |
| New precept templates | 6 |
| Files touched total | 11 (8 templates + copy-templates.sh + AGENTS.md + session report) |
| Communication-rule corrections | 5 (2 drafts rewritten, 3 practice-step conversions) |
| Propagation | `copy-templates.sh` → `mgba-repo/template/` |
| Sync verified | 15/15 codex files SYNC, 6 new precepts present |

## Decisions

1. Six individual precept template files (one rule per file) — matches the atomic precept naming convention.
2. Naming `precept-{action}-template.md` — disambiguates from generic `precept-template.md`.
3. `concept/` inserted into the general chain — the dive's ring diagram already placed it in ring 2; the flat chain now matches the rings.
4. Change inventory stays in AGENTS.md per atomic-documents; study-template references only.
5. Communication rules applied to every template artifact — SOV, actor-first, declarative register, affirmative framing.

## Errors found

```
1. use-ripgrep draft: "not grep" negation-priming → "searches run through rg"
2. use-shared-browser draft: "never a fresh Chrome launch" imperative + negation
   → "fresh launches and profile copies stay excluded"
3. verify-qalc/run-fixtures practice steps imperative ("Write the claim...")
   → declarative ("The claim writes...")
4. atomic-documents: "never a bundled architecture doc" → "one concern per file"
5. study-template embedded change inventory → moved to AGENTS.md reference-only
6. copy-templates.sh CODEX_FILES initially lacked the new precepts — would have
   silently dropped them from the dive
```

## Findings

1. The dive is the realized template instance — templates improve by reading the dive, not the reverse.
2. Ring structure formalizes the flat chain; the flat chain omitted `concept/` despite the dive's ring diagram including it — latent inconsistency now resolved at the source.
3. The dive's 7 precepts split into generic form (already covered) and doctrine (new — qalc, metrics, fixtures, atomic docs, rg, shared browser) — doctrine becomes reusable only as explicit templates.
4. Communication-rule compliance gates template authoring — templates are instruction artifacts; imperative/negation phrasing violates the positive-ratio doctrine at the layer where it matters most.
5. `copy-templates.sh` is the sync point — post-copy verification (15/15 SYNC) confirms the dive's `template/` mirrors `_templates/`.

## Open edges

- snes9x-repo `template/` — RESOLVED: snes9x uses shared `_templates/` directly, no local `template/` copy (edge was based on a false assumption).
- `dive-naming-conventions-template.md` — DONE: codex-owned reference created (per-layer patterns, template naming, 6 rules, exceptions), communication-compliant, propagated + registered.
- `templates.db` registry — DONE: 31 templates pushed (all 6 new precepts + naming template verified in DB). **Bug found + fixed:** `push-registry.rb` globbed `reports/*.md` but the dir is `report/` — 0 reports pushed before the fix, 11 after. Semantic embed: 44 current (17 new/changed).
- `mgba-repo/AGENTS.md` wording — stays dive content; no back-propagation needed (open, optional).

## Todo state

```
Completed: 13 tasks (survey, 8 template edits, comm audit, naming template, registration,
           propagation+verify, registry push + glob fix, semantic embed, report)
Pending:   mgba AGENTS.md alignment (optional) — see todo file
```
