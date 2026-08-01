---
id: ILL.META.SCHEMA
title: "Naming Schema Walkthrough — Validating a Protocol ID Against the Rules"
source: PROT.META.IDENTITY
summary: "Walk through a naming validation: an agent checks PROT.TOOL.DEFINITION against the four-segment rules, verifies each segment passes, and handles a failure by consulting the rename registry."
illustration: "An agent validating PROT.TOOL.DEFINITION against REF.META.NAMING.SCHEMA rules — prefix check, domain check, subject check, aspect check, and a two-segment exception case"
illustrates: [REF.META.NAMING.SCHEMA]
tags: meta,naming,schema,walkthrough,validation
related: [REF.META.NAMING.SCHEMA, REF.META.RENAME.REGISTRY, PROT.META.DOMAIN]
---
## Rationale

A new protocol proposal arrives with ID `PROT.TOOL.DEFINITION`. The agent runs the application sequence from `REF.META.NAMING.SCHEMA` to validate each segment before creation. The canonical domain set lives in `PROT.META.DOMAIN`.

## Walkthrough

### Step 1: Check PREFIX

The agent checks the first segment against the valid entity-type set:

```
Valid prefixes: PROT, PAT, ILL, CMD, SKL, TERM, INV, APO, ABS, LNG, MAX, PER
```

`PROT` is in the set. Passes rule 1.

### Step 2: Check DOMAIN

For IDs with 3+ segments, the second segment must be in the canonical domain set:

```
Canonical domains: LIB, SCHEMA, TOOL, META, SEARCH, PLUGIN, MCP, TERM, COMMAND, CONTENT, PERSON, SKILL, INVESTIGATION
```

`TOOL` is in the set. Passes rule 2.

### Step 3: Check SUBJECT

`CUSTOM` is a singular noun. Passes rule 3.

### Step 4: Check ASPECT

`DEFINITION` is a singular noun and specific to the subject (generic terms like `STRATEGY` excluded). Passes rules 3 and 5.

All four segments valid. The protocol can be created with ID `PROT.TOOL.DEFINITION`.

### Step 5 (failure case): Two-segment exception

Now the agent encounters a protocol with ID `PROT.MCP` in a cross-reference. This is a two-segment ID — a valid exception per rule list:

| ID | PREFIX | DOMAIN | ASPECT |
|----|--------|--------|--------|
| `PROT.MCP` | PROT | MCP | — |

The agent checks the two-segment exception table. Two-segment IDs omit SUBJECT when DOMAIN is self-evident. `PROT.MCP` is a valid exception. Passes.

### Step 6 (failure case): Consult rename registry

The agent encounters `PROT.TOOL.GENERATED.COMPLIANCE` in an old file. Checking:

1. PREFIX: `PROT` ✓
2. DOMAIN: `TOOL` ✓
3. SUBJECT: `GENERATED` — verb form, noun excluded. Violates rule 4.

Step 5 of the application sequence: consult `REF.META.RENAME.REGISTRY`:

| Current | Violation | Renamed |
|---------|-----------|---------|
| `PROT.TOOL.GENERATED.COMPLIANCE` | Verb form (`GENERATED`) | `PROT.TOOL.GENERATION.COMPLIANCE` |

The canonical ID is `PROT.TOOL.GENERATION.COMPLIANCE`. The agent updates the reference.

## Key insight

The naming schema provides a step-by-step validation sequence — check, check, check → pass or redirect. Each violation type (verb compound, abbreviation, adjective, slang, generic aspect) maps to a specific rule, making the fix unambiguous. When a check fails, the rename registry provides the canonical correction without guesswork.

## See also

- `REF.META.NAMING.SCHEMA` — the naming schema this walkthrough illustrates
- `REF.META.NAMING.SCHEMA` — the naming protocol with prefix, domain, subject, aspect rules
- `PROT.META.DOMAIN` — canonical domain set
- `REF.META.RENAME.REGISTRY` — rename registry for failure case resolution
- `ILL.META.RENAME.REGISTRY` — rename lookup walkthrough
