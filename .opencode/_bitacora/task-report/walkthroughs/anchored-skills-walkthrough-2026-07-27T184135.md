# Anchored Skills — Setup Walkthrough

**Timestamp:** 2026-07-27T18:41:35-06:00

## Procedure

1. **Read system instructions** — parsed AGENTS.md, .opencode/rules/, available_skills list
2. **Load 7 anchored skills** — invoked `skill` tool for each active skill
3. **Query patlib context** — per RUL.QUERY.PATLIB.CONTEXT, MCP patlib tools available
4. **Read MAX.* + PROT.*** — read-maxims-protocols loaded, ready to apply before decisions
5. **Write reports** — conclusions + walkthrough + todo per report-outcomes

## Anchored Skill Chain

```
Task → query-patlib-context → read-maxims-protocols → compose-web (if research)
     → use-playwright-core (if dynamic pages)
     → acquire-assets (if JSTOR)
     → declare-grounded-entity (if entity creation)
     → knowledge-ruby (if Ruby FP)
     → report-outcomes
```

## Directories

| Output | Path |
|--------|------|
| Conclusions | `report/conclusions/` |
| Errors | `report/errors/` |
| Walkthroughs | `report/walkthroughs/` |
| Todo | `todo/` |
| Decisions | `scripts/decision/` |
| Guides | `scripts/guides/` |

## Open Edges

- No active task yet — awaiting user assignment
- All 7 skills loaded, context engine warm
