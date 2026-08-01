# Parse → Validate → Report Pipeline

## Overview

Entity `.md` files flow through four stages: discovery → parsing → validation → reporting. Each stage is a pure `_rb/` module consumed by an imperative `r*` script.

## Input

Source: 22 entity directories under `.opencode/entities/{type}/`, each containing `.md` files with YAML frontmatter or backmatter.

Ignored: files without frontmatter (research notes in investigations/ subdirectories, raw text files). These still appear in recursive `**/*.md` glob counts but are filtered out by `ParseAll`.

## Flow

```
 .opencode/entities/
│
│  _rb/paths.rb (EntityTypes, EntityGlob)
│  Discovers 22 directories, globs **/*.md
│
▼
 entity/*.md files (~487 total)
│
│  _rb/frontmatter.rb (ParseFrontmatter, ParseBackmatter, ParseAll)
│  Strips YAML between --- markers. Returns hash or nil.
│  Filters to ~352 entities with valid metadata.
│
▼
 Parsed entries (Array of {file, id, type, source, tags, ...})
│
│  r*.rb validation scripts:
│  ┌─────────────────────────────────────────────┐
│  │ r1-dry-check     → duplicate ID detection   │
│  │ r1-group-count   → ring distribution matrix │
│  │ r2-entity-classify → type + tags table      │
│  │ r2-id-pattern    → ID segment depth         │
│  │ r2-source-validate → source direction       │
│  │ r2-related-validate → related isolation     │
│  │ r2-protocol-refs → protocol reference scope │
│  │ r2-illustration-targets → illustration type │
│  │ r2-maxim-audit   → maxim structure          │
│  │ r2-protocol-audit → protocol structure      │
│  │ r2-pattern-audit → pattern structure         │
│  │ r3-ref-validate  → cross-ref resolution     │
│  │ r4-entity-count  → type counts              │
│  │ r4-frontmatter-dump → raw frontmatter       │
│  └─────────────────────────────────────────────┘
│
│  Each script independently re-parses. No shared state.
│  _rb/rings.rb provides ring lookup for ring-aware scripts.
│
▼
 Results (stdout or file)
│
│  _rb/report.rb (Table, List formatters)
│  Formats violation lists or summary tables.
│
▼
 report/{conclusions,errors,walkthroughs}/{name}-{ts}.{txt,md}
```

## Output

| Outcome | Directory | Format |
|---------|-----------|--------|
| No violations, summary data | `report/conclusions/` | `.txt` |
| Violations found | `report/errors/` | `.txt` |
| Agent process documentation | `report/walkthroughs/` | `.md` |

## Key design properties

- **No shared state** — each `r*` script is standalone, re-parses all files independently.
- **Pure core** — `_rb/` modules are deterministic, no I/O (except `loader.rb`'s require side effects).
- **Orthogonal rings** — scripts are at code ring N but analyze entities at any knowledge ring.
- **Reports append** — same timestamp = overwrite. Use unique timestamps per session.
