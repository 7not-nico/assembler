---
id: ILL.META.INDEX
title: "Skill Index Walkthrough — Deriving Skill Metadata at Sync"
source: PROT.META.IDENTITY
summary: "Walkthrough of how skill metadata derives from SKILL.md frontmatter at sync time — name to ID mapping, field population, and query."
illustration: "A skill file SKILL.md has name: audit-pattern and description: 'Audits patterns for compliance'. At sync, this becomes SKL.AUDIT.PATTERN with body derived from description."
illustrates: [PROT.META.SKILL.INDEX]
tags: skill,index,walkthrough,patlib,sync
related: [PROT.SKILL.PROFILE, PAT.OPENCODE.META.SKILL.INDEX]
---
## Rationale

Per-skill index files duplicate the skill's own description field — sync surface with no benefit. Deriving all skill metadata directly from SKILL.md frontmatter eliminates the duplicate files while keeping the skills table queryable. The ID derives from name: `name` → `SKL.{UPPERCASE.NAME}`.

The agent examines a skill directory at `.opencode/skills/audit-pattern/SKILL.md`. The frontmatter declares `name`, `description`, and `state-profile`. At sync time, these fields populate the skills table automatically.

## Walkthrough

### Step 1: Read the skill frontmatter

The file `audit-pattern/SKILL.md` contains:

```yaml
---
name: audit-pattern
description: Audit all .opencode/patterns/ files for structural and semantic compliance
state-profile: stateful-auditor
---
```

### Step 2: Derive the skill ID

The name `audit-pattern` transforms per rule 2:

```
name: audit-pattern
  → toUpperCase(): AUDIT-PATTERN
  → replace /-/g with '.': AUDIT.PATTERN
  → prefix with SKL.: SKL.AUDIT.PATTERN
```

### Step 3: Map frontmatter fields to table columns

| SKILL.md frontmatter | skills table column | Value |
|---|---|---|
| `name` | `skill` | `audit-pattern` |
| `description` | `body` | Audit all patterns files for compliance |
| `state-profile` | `state_profile` | `stateful-auditor` |

The ID `SKL.AUDIT.PATTERN` serves as the primary key. The skill file path is derived — no dedicated index file exists.

### Step 4: Verify table population

Running `write-sync --type skills` inserts or updates the row:

```
id: SKL.AUDIT.PATTERN
title: Audit Pattern
description: Audit all .opencode/patterns/ files for structural and semantic compliance
state_profile: stateful-auditor
```

### Step 5: Query the skills table

The agent queries via `read-selection --type skills` and finds the row. The skill is now discoverable through patlib search alongside patterns, terms, and protocols.

## Key insight

The skill index is the skills table itself — no separate files, no manual registry. Every SKILL.md frontmatter is the authoritative source, and sync derives the queryable row automatically. A skill missing `description` or `state-profile` produces a broken row, discoverable as a gap.

## See also

- `PROT.META.SKILL.INDEX` — the derived skill index protocol this illustrates
- `PROT.SKILL.PROFILE` — state-profile values and rules
- `PAT.OPENCODE.META.SKILL.INDEX` — superseded pattern with dedicated files
