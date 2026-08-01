---
id: ILL.META.REGISTRY
title: "Rename Registry Walkthrough — Resolving a Stale Entity ID"
source: PROT.META.IDENTITY
summary: "Walk through a rename lookup: an agent encounters PAT.DOMAIN.CONTAINER in code, consults the registry, discovers REF.META.DOMAIN.DIRECTORY as the current ID, and updates the reference."
illustration: "An agent resolving a stale entity ID via REF.META.RENAME.REGISTRY — finds the old ID in the registry tables, retrieves the new ID, and updates cross-references"
illustrates: [REF.META.RENAME.REGISTRY]
tags: meta,naming,rename,registry,walkthrough
related: [REF.META.NAMING.SCHEMA, REF.META.NAMING.SCHEMA]
---
## Rationale

A subproject's `AGENTS.md` references `PAT.DOMAIN.CONTAINER` in its task instructions. An audit step detects this ID absent from all known patterns in the patlib database. The agent consults the rename registry to find the current canonical ID.

Audit step: `read-selection --type patterns --query "DOMAIN.CONTAINER"` returns 0 results — the ID is stale.

## Walkthrough

### Step 1: Open the registry

The agent opens `REF.META.RENAME.REGISTRY`:

```bash
read opencode/patterns/PAT.META.RENAME.REGISTRY.md
```

### Step 2: Find the stale ID in the Pattern renames table

The Pattern renames section lists every renamed pattern with `Current → Violation → Renamed`:

| Current | Violation | Renamed |
|---------|-----------|---------|
| `PAT.DOMAIN.CONTAINER` | Missing DOMAIN | `REF.META.DOMAIN.DIRECTORY` |

The violation column explains: `PAT.DOMAIN.CONTAINER` is missing the `META` domain prefix. The `Renamed` column provides the canonical ID.

### Step 3: Update the reference

Replace the stale ID in `AGENTS.md`:

```diff
- - PAT.DOMAIN.CONTAINER  # Domain container — directory structure
+ - REF.META.DOMAIN.DIRECTORY  # Domain container — directory structure
```

### Step 4: Verify resolution

Query the new ID to confirm it exists:

```bash
read-projection --type patterns --id REF.META.DOMAIN.DIRECTORY
```

Returns the full pattern — the rename resolved correctly.

## Step 5 (variant): Prefix migration — PAT to MAX

If the stale ID falls under the Prefix renames section (PAT to MAX), the agent updates the prefix:

| Current | Violation | Renamed |
|---------|-----------|---------|
| `PAT.PROGRAMMING.DELIBERATELY` | Advice/mantra | `MAX.PROGRAMMING.DELIBERATELY.PRACTICE` |

Replace `PAT.` → `MAX.` in the reference.

## Step 6 (variant): Exempt ID

If the stale ID appears under Exempt, the ID is valid — no rename needed:

| ID | Reason |
|----|--------|
| `PAT.DRY` | Universal principle — single authoritative representation |

Leave the reference unchanged.

## Key insight

The rename registry is a data structure — tables indexed by old ID, keyed to new ID. Every rename documents the violation (why the rename happened) so the agent understands the naming convention through concrete examples. The Application section prescribes: *detect stale → consult registry → rename → verify*.

## See also

- `REF.META.RENAME.REGISTRY` — the rename registry this walkthrough illustrates
- `REF.META.NAMING.SCHEMA` — naming rules that trigger renames
- `REF.META.NAMING.SCHEMA` — naming protocol with four-segment ID rules
- `PROT.META.DOMAIN` — canonical domain set
