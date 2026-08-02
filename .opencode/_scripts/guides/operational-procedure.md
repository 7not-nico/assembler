# Operational Procedure — Anchored Skills Execution Plan

Anchors: compose-web, report-outcomes, use-playwright-core, knowledge-languages, guide-reasoning.

## Phase 0: Pre-Task Context (Always)

```
RUL.QUERY.PATLIB.CONTEXT  →  guide-reasoning order: MAX.* → SPEC.* → IDENTITY.* → PROT.*
```

1. `patlib_search(type=maxims)` — read MAX.* philosophy, principles
2. `patlib_search(type=specifications)` — read SPEC.* architecture (ring topology, edge semantics)
3. `patlib_search(type=patterns)` | `patlib_search(type=protocols)` — read PAT.* / PROT.* contracts
4. `patlib_search(type=terms)` — read TERM.* entity definitions if task introduces new entities
5. Cross-reference: maxims answer *why*, specs answer *what*, protocols answer *how*
6. Fallback: `read-selection` / `read-projection` when MCP unavailable

## Phase 1: Skill Injection

Load anchored skills in dependency order:

1. **guide-reasoning** — grounds MAX→SPEC→PROT ordering. Run before any design decision.
2. **compose-web** — provides the search→fetch→Context7→Playwright→log pipeline. Run before any research/web interaction.
3. **use-playwright-core** — provides navigation, interaction, extraction tools. Run within compose-web step for dynamic pages.
4. **knowledge-languages** — read atomic `knowledge/ruby/` files for Ruby functional programming questions only.
5. **query-nerdfont** — query nerdfont/sets/ DB for glyph data. Training memory disabled for glyph scope.
6. **report-outcomes** — runs on task completion. Writes conclusions, errors, walkthroughs, todo.

Other skills loaded reactively per scope: audit-*, search-*, propose-*, use-patlib, stage-create, vet-proposal, etc.

## Phase 2: Research Pipeline (compose-web)

```
search → fetch → Context7 → Playwright → log
```

| Step | Tool | When |
|------|------|------|
| 1 | `parallel-search_web_search` | 2-3 focused queries, `objective` describing what to find |
| 2 | `parallel-search_web_fetch` | Excerpts insufficient; batch multiple URLs with `objective` |
| 3a | `context7_resolve-library-id` | SDK/API/framework doc needed; pass library name + query |
| 3b | `context7_query-docs` | Resolved library ID + specific concept query. Max 3 calls per question |
| 4 | `playwright_browser_navigate` | JS-rendered/dynamic/interactive pages |
| 5a | `playwright_browser_snapshot` | Capture accessibility tree (refs for interaction) |
| 5b | `playwright_browser_find` | Cheaper than full snapshot for locating text |
| 6 | `playwright_browser_{click,type,fill_form,select_option}` | Interact per use-playwright-core |
| 7 | `playwright_browser_evaluate` / `browser_take_screenshot` / `browser_network_requests` | Extract content per use-playwright-debug (loaded as needed) |
| 8 | `mcp-log-search` | Record findings, MCP, tool, query, summary, status, result-count, URLs |

### Gotchas

- parallel-search before Playwright. fetch before Context7. Context7 has 3-call limit per question.
- `snapshot` provides refs for interaction; `find` is cheaper for locating.
- `screenshot` for visual; `snapshot` for actions. Different modalities.
- Batch related Context7 queries into one call.

## Phase 3: Design & Implementation (guide-reasoning)

```
MAX.* → SPEC.* → IDENTITY.* → PROT.* → implementation
```

1. **MAX.*** — identify governing principles (e.g., `MAX.ATOMIC.CONCERN` → one concern per file)
2. **SPEC.*** — determine ring placement, segment count, naming (e.g., `SPEC.ENTITY.SEGMENT.COUNT`)
3. **IDENTITY.*** — entity type definition: what it IS, its ring, naming convention
4. **PROT.*** — technical contract: format, fields, enforcement rules
5. Implement using conventions from target layer (patterns for *how*, protocols for *contract*, terms for *what*)

### Ring-layer-scope

Each entity contributes what inner rings leave unstated. Reference inner-ring entities by ID, restate by reference only.

### Precedence-derivation

Before entity creation, trace `what precedes this?` outer→inner. Ring layer (R1-R4) is output of derivation, not input choice. Cycle detection → domain bracket.

## Phase 4: Reporting (report-outcomes) — Post-Task

```
todo update → write outputs → cross-check
```

### Todo

`scripts/todo/{session-timestamp}.md` — pending, in-progress, completed, cancelled. One concern per script per MAX.ATOMIC.CONCERN. ISO 8601 timestamps.

### Report directories

| Output type | Directory | Format |
|-------------|-----------|--------|
| No errors, summary data | `scripts/report/conclusions/` | `{script}-{timestamp}.txt` |
| Errors or violations | `scripts/report/errors/` | `{script}-{timestamp}.txt` |
| Multi-step traces | `scripts/report/walkthroughs/` | `{script}-{timestamp}.md` |
| Implementation guides | `scripts/guides/` | `{topic}.md` |
| Architectural decisions | `scripts/decision/` | `{NNN}-{topic}.md` |

### Cross-check checklist

- Every script ran without errors
- Outputs match expected format (Table, List)
- Timestamps are ISO 8601 (`date -Iseconds`)
- Each file has exactly one concern. Two independent causes → split.

## Phase 5: Entity Creation (stage-create + vet-proposal)

When creating new patlib entities:

1. **vet-proposal** — critically evaluate proposal before creation. Check: uniqueness, semantic overlap, ring accuracy, naming convention.
2. **judge-semantic** — check whether proposal duplicates or overlaps existing patlib content at semantic level.
3. **stage-create** — create entities one at a time, audit each step before proceeding.
4. **write-sync** — sync to `patlib.db` after creation.
5. **patlib_validate** — validate structural correctness of all entity files.

## Reference: Key Entity Mappings

| Layer | Entities | ID Pattern | Ring |
|-------|----------|------------|------|
| Maxims | `MAX.*` | 4-segment: `PREFIX.DOMAIN.SUBJECT.ASPECT` | R0 - Philosophy |
| Specifications | `SPEC.*` | 4-segment | R1 - Architecture |
| Patterns | `PAT.*` | 4-segment | R2 - Prescription |
| Protocols | `PROT.*` | 4-segment | R4 - Contract |
| Terms | `TERM.*` | 3-segment: `PREFIX.DOMAIN.SUBJECT` | R3 - Encyclopedia |
| Skills | `SKL.*` | 3-segment | R3 - Encyclopedia |
| Illustrations | `ILL.*` | 3-segment | R3 - Encyclopedia |

## Reference: Tool State Profiles (for audit-* skills)

| State Profile | I/O Model | Examples |
|--------------|-----------|----------|
| stateless | Pure transformation | search-maxims, search-patterns |
| stateful-reader | Read existing DB state | read-selection, read-projection |
| stateful-writer | Create/update DB | write-sync |
| stateful-auditor | Validate, warn, no mutation | audit-patterns, audit-rules |
| hybrid | Read + Write | sync-watch, prune-stale |

## Reference: Ring Naming for Scripts

Per `MAX.CODE.LAYERS` verification model:

| Ring | Name | Description |
|------|------|-------------|
| r1 | PURE | Foundational, no I/O |
| r2 | DB-READ | Entity metadata reads |
| r3 | LOCAL-READ | Cross-file refs |
| r4 | REMOTE-READ | Network reads |
| r5 | LOCAL-WRITE | Local file writes |
| r6 | REMOTE-WRITE | Network writes |
| r7 | DB-WRITE | Database writes |

## Writing Conventions (RUL.WRITING.CONVENTION — 16 rules)

Applied throughout all output:

| Convention | Scope | Rule |
|------------|-------|------|
| lambda-linguistics | sentence | `subject.action` form |
| zero-copula | sentence | Drop copula when meaning recovers |
| expletive-deletion | sentence | Drop `there is`, `it is` |
| left-edge-deletion | clause | Drop articles/determiners at clause start |
| declarative-assertion | sentence | No modal hedges (`would`, `could`, `might`) |
| essential-first | section | Core before caveats |
| positive-framing | response | Name desired action, not prohibited |
| constraint-budget | segment | ≤5 simultaneous options |
| structural-preference | block | Lists/tables > prose for ≥3 items |
| pseudo-code-notation | block | `→` `::` `=` `~` `>>` |
| asyndeton | chain | Conjunctions → commas/arrows |
| gapping | clause | Omit repeated verb in parallel structure |
| domain-zero-anaphora | chain | Leading `.` fills last domain |
| dash-pivot | sentence | Articles/prepositions → dashes at emphasis |
| resultative-compounding | labels | `verb-result` hyphenated |
| acronymic-anaphora | document | `Full Name (ABBR)` once, then `ABBR` |
