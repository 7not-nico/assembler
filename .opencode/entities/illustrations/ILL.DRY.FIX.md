---
id: ILL.DRY.FIX
title: "DRY — Resolving a Duplicated Entity Definition"
source: PROT.LIB.CONTRACT
summary: "A term exists in two .md files with different summaries. One is authoritative — the agent deduplicates, updates references, and syncs."
illustration: "TERM.OPENCODE appears in two .opencode/terms/ files with divergent summaries — the agent picks the authoritative version, deletes the duplicate, updates all cross-references, and syncs."
illustrates: [MAX.CODE.DRY.PRINCIPLE]
tags: walkthrough,deduplication,sync,reference,source-of-truth
related: [MAX.CODE.ORTHOGONALITY.PRINCIPLE, MAX.BROKEN.WINDOW.CASCADE]
---
## Context

`MAX.CODE.DRY.PRINCIPLE` requires every piece of knowledge to have a single authoritative representation. A search for `TERM.OPENCODE` returns two results — one in `.opencode/terms/opencode.md` and another in `.opencode/terms/opencode-cli.md`. Both define the same entity with overlapping but divergent summaries. Consumers reference one or the other at random.

## Walkthrough

### Step 1: Detect the duplicate

A `read-selection --type terms --query opencode` query returns two entries with identical IDs but different titles:

```
TERM.OPENCODE — OpenCode Configuration Framework
TERM.OPENCODE — OpenCode CLI Agent
```

Inspecting both files confirms they define the same entity — one focused on configuration, the other on the CLI agent.

### Step 2: Determine authoritative version

The configuration-focused file has the earlier `created` date and is referenced by 5 other terms via `related:`. The CLI-agent file references none. The configuration version is authoritative.

### Step 3: Merge summary and tags

The CLI version has useful tags (`agent,cli,runtime`) missing from the authoritative version. The agent merges them:

```yaml
summary: "OpenCode configuration framework governing agent behavior, CLI runtime, and session lifecycle."
tags: configuration,agent,cli,runtime,framework,opencode
```

### Step 4: Delete duplicate file

The agent removes `.opencode/terms/opencode-cli.md` — only one `.md` file per entity. The duplicate's content (if any unique body text) is moved to the authoritative file.

### Step 5: Update all cross-references

A grep for `TERM.OPENCODE` across `.opencode/` finds 12 references. All remain valid — the ID did not change. The `related:` lists in other entities lose one entry but the entry was already the same ID.

### Step 6: Sync

```bash
write-sync --type terms
```

The duplicate row is pruned from patlib.db (or marked stale). One authoritative definition remains.

## Key insight

Duplication arises not only from identical text but from overlapping definitions of the same entity. The fix is not to merge two documents — the fix is to pick the authoritative source, merge unique content into it, delete the duplicate, and let the cross-reference graph remain intact. DB and consumers resolve to the single source.

## See also

- `MAX.CODE.DRY.PRINCIPLE` — the maxim this illustrates
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — one file per entity is orthogonal design
- `MAX.BROKEN.WINDOW.CASCADE` — a stale duplicate invites more stale duplicates
