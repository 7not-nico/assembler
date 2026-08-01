---
id: ILL.PLUGIN.SCORING
title: "Candidate Scoring — 7-Criteria Evaluation Example"
source: PROT.PLUGIN.WRITE
summary: "Walkthrough of scoring a plugin candidate against the seven criteria — structural and implementation checks."
illustration: "The auto-sync plugin candidate runs through all seven criteria. Six of seven pass. Document the one weakness and proceed."
illustrates: [PROT.PLUGIN.CANDIDATE.SCORING]
tags: plugin,candidate,scoring,walkthrough,evaluation
related: [PROT.PLUGIN.CANDIDATE.SCORING, PROT.TOOL.HOOKS, REF.LIB.PURITY.BOUNDARY]
---
## Rationale

Every plugin candidate evaluates against the same seven criteria, ensuring consistent evaluation across all candidates. Scores range from six to seven — candidates below six require refinement before proceeding. The table structure mirrors the criteria framework.

The `auto-sync` plugin watches term and protocol file edits and triggers a sync workflow. Before writing code, the candidate is evaluated against the seven criteria from `PROT.PLUGIN.CANDIDATE.SCORING`.

## Walkthrough

1. **Single subject** — auto-sync watches term/protocol file edits and triggers sync. One concern. ✅ Pass.

2. **Real gap** — manual `write-sync` runs after every edit. Users forget. Auto-sync solves a recurring friction point. ✅ Pass.

3. **One hook per trigger source** — registers `file.edited` for opencode editor saves and `tool.execute.after` for agent Write tool calls. Two hooks, two different trigger sources — not scope creep. ✅ Pass per `PROT.PLUGIN.CANDIDATE.SCORING` §3 clarification.

4. **Observable output** — calls `client.app.log()` on each sync trigger with success or failure status. Failures visible in log stream. ✅ Pass.

5. **Purity boundary** — the edit detection logic stays under 50 lines in the plugin file. File change diff extraction could exceed 5 lines — extract to `_lib/diff-utils.ts` as a pure module. ✅ Pass (with extraction).

6. **Low weight** — plugin body stays under 50 lines. Extracted diff logic stays under 50 lines. No scope creep. ✅ Pass.

7. **Hooks-only** — auto-sync triggers sync via the existing `write-sync` tool call. No new tool registration. Companion skill excluded. ✅ Pass.

**Result**: 7 of 7 criteria pass. Proceed with implementation.

## Report format

```
| Criterion | Result | Notes |
|-----------|--------|-------|
| Single subject | ✅ Pass | One concern |
| Real gap | ✅ Pass | Recurring friction |
| One hook | ✅ Pass | file.edited + tool.execute.after (complementary sources) |
| Observable output | ✅ Pass | client.app.log() |
| Purity boundary | ✅ Pass | Extract diff logic to _lib/ |
| Low weight | ✅ Pass | Under 50 lines each |
| Hooks-only | ✅ Pass | No tool registration |
```

## Key insight

The scoring process is the design. Walking through each criterion forces decisions — extraction points, hook boundaries, scope limits. A candidate that passes all seven has a clear implementation path. A candidate that fails three or more should use a different layer (MCP, command, or manual workflow).

## See also

- `PROT.PLUGIN.CANDIDATE.SCORING` — applied scoring protocol
- `PROT.PLUGIN.CANDIDATE.SCORING` — seven criteria protocol
- `PROT.PLUGIN.LIFECYCLE` — hook matrix with trigger source disambiguation
- `PROT.TOOL.HOOKS` — plugin lifecycle hooks, file.edited scope note
- `REF.LIB.PURITY.BOUNDARY` — purity boundary for extracted modules
