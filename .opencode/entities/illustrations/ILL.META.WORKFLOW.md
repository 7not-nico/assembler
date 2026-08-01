---
id: ILL.META.WORKFLOW
title: "Proposal Workflow Walkthrough — Creating a New Protocol Entity"
source: PROT.META.IDENTITY
summary: "Walk through a protocol proposal: agent detects a gap for tool layer choice, confirms no existing entity covers it, searches related protocols, writes NEX.TOOL.CHOICE, syncs, and reports the new ID."
illustration: "An agent creating NEX.TOOL.CHOICE follows the detect-check-search-write-sync cycle — a concrete instance of the proposal workflow"
illustrates: [NEX.META.PROPOSAL]
tags: proposal,workflow,creation,walkthrough,entity
related: [SKL.PROPOSE.PROTOCOL, SPEC.ENTITY.DISTINCTION.BOUNDARY, REF.META.NAMING.SCHEMA]
---
## Rationale

Every entity creation follows the same sequence — detect gap, check existence, search related, write files, sync, report. The sequence is identical across patterns, terms, skills, rules, and tools; only the file format and sync target differ per entity type. Propose-* skills implement this template.

An audit of `PROT.TOOL.MODEL` reveals the protocol covers both invocation mechanics (shebang vs IPC) and layer choice criteria (when to choose CLI vs MCP vs plugin). These are two distinct concerns. The agent proposes a new protocol focused on layer choice criteria only.

## Walkthrough

### Step 1: Detect the gap

During an audit, the agent identifies layer choice heuristics embedded in `PROT.TOOL.MODEL`. The invocation protocol handles shell shebang and IPC export format; layer choice handles performance and deployment criteria. These concerns warrant separate files.

Detection trigger: audit output shows `PROT.TOOL.MODEL` contains two independent rule sets under a single protocol header.

### Step 2: Check existence

The agent verifies no existing entity covers layer choice:

```
read-selection --type protocols --query "layer choice"
read-selection --type patterns --query "layer choice"
```

Both return 0 results. The gap is confirmed.

### Step 3: Search related entities

The agent searches for entities that would cross-reference the new protocol:

```
read-selection --type protocols --query "invocation model"
read-selection --type protocols --query "tool classification"
read-selection --type patterns --query "performance"
```

Results include `PROT.TOOL.MODEL`, `PROT.TOOL.AUTOMATON`, and `PAT.PLUGIN.CANDIDATE.EVALUATION`. These will appear in the new protocol's `related:` field.

### Step 4: Write the file

The agent creates `PROT.TOOL.LAYER.CHOICE.md` in `.opencode/protocols/`:

```markdown
---
id: NEX.TOOL.CHOICE
title: "Tool Layer Choice — When to Deploy CLI, MCP, or Plugin"
source: assembler
related: [PROT.TOOL.MODEL, PROT.TOOL.AUTOMATON]
summary: "Decision criteria for choosing between CLI, MCP, and plugin tool layers based on invocation pattern, performance profile, and read-write direction."
protocol: >
  Layer choice follows three criteria: invocation pattern (bun run vs IPC vs MCP tool),
  performance profile (cold init, RTT, amortization point), and read-write direction
  (MCP reads, plugins writes, CLI both).
enforcement: Convention
status: active
priority: 3
tags: [tooling, architecture, performance, layer-choice, deployment, convention]
---
```

The file follows the protocol format per `PROT.META.IDENTITY`: frontmatter with id, title, source, related, summary, protocol, enforcement, status, priority, tags.

### Step 5: Sync

The agent syncs the new entity to the database:

```
write-sync --type protocols
```

Output: `Synced 55 protocols` — the count increments by one.

### Step 6: Report

The agent reports the new entity ID and updates cross-references in the source protocol:

```
NEX.TOOL.CHOICE added.
PROT.TOOL.MODEL.related updated to reference LAYER.CHOICE.
```

## Key insight

The proposal workflow is a safety net — existence checks prevent duplicates, related search ensures cross-references complete before the entity becomes queryable. Sync before report eliminates the gap where an entity exists on disk yet remains invisible to query tools. The cycle repeats for each entity type; only the file format and sync target differ.

## See also

- `NEX.META.PROPOSAL` — the proposal workflow this walkthrough illustrates
- `SKL.PROPOSE.PROTOCOL` — concrete skill implementing this template for protocols
- `PAT.META.ENTITY.LIFECYCLE` — the propose-audit lifecycle that extends proposal into maintenance
- `REF.META.NAMING.SCHEMA` — naming rules applied during the write step
