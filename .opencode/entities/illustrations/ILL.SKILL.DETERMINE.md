---
id: ILL.SKILL.DETERMINE
title: "Skill Profile Determine — State Classification Walkthrough"
source: PROT.SKILL.PROFILE
summary: "Walkthrough of determining a skill's state-profile based on its read, write, and validate operations."
illustration: "A skill that queries the database and returns formatted results reads state without writing or validating. Classification: stateful-reader."
illustrates: [PROT.SKILL.PROFILE]
tags: skill,state-profile,walkthrough,classification,determination
related: [TERM.SKILL.STATECLASS, PROT.TOOL.AUTOMATON]
---
## Context

A new skill queries the database for entity data, formats it, and returns the results to the agent. Before writing the skill, the state-profile must be declared in frontmatter. The profile determines testing strategy and dependency management.

## Walkthrough

1. List the skill's operations:
   - Reads entity data from the database via SELECT query
   - Formats the data into a structured response
   - Returns the response to the agent
   - No writes to the database
   - No validation of existing data

2. Match the operation pattern against the five profiles:

   | Profile | Reads | Writes | Validates |
   |---------|-------|--------|-----------|
   | stateless | No | No | No |
   | stateful-reader | Yes | No | No |
   | stateful-writer | No | Yes | No |
   | stateful-auditor | Yes | No | Yes |
   | hybrid | Yes | Yes | Yes |

3. The skill reads, does not write, does not validate. Match: `stateful-reader`.

4. Declare the profile in the skill's frontmatter:

```yaml
---
name: query-entity
description: Query and format entity data
state-profile: stateful-reader
---
```

5. Run `audit-skill` to verify the declaration matches actual operations. The audit infers operations from body content and flags mismatches.

## Key insight

The profile is determined by operations, not intent. A skill that reads without writing belongs to `stateful-reader` even if designed to eventually write. `hybrid` requires explicit validation in the skill body. Declaring the wrong profile causes incorrect testing assumptions — a skill declared `stateless` that actually reads the DB requires DB mocking in tests.

## See also

- `PROT.SKILL.PROFILE` — abstract state classification rules
- `TERM.SKILL.STATECLASS` — five-category taxonomy (superseded by `IDENTITY.SKILL`)
- `PROT.TOOL.AUTOMATON` — analogous tool classification
