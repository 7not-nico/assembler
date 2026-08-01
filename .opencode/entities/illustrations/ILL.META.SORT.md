---
id: ILL.META.SORT
title: "Entity Framework — Morphism vs Guided Composition Classification"
source: PROT.META.IDENTITY
summary: "Walkthrough of classifying three entity types into their structural frameworks: tools as morphisms (external composition), skills as guided compositions (internal sequence), commands as guided compositions (verb-domain workflow)."
illustration: "Three entity types sort into two frameworks: a read-selection tool is a morphism (atomic, external composition, // @toolclass identity); an audit-pattern skill is a guided composition (step sequence, stateful-auditor profile); a sync-entity command is a guided composition (verb-domain name, prescribed order)."
illustrates: [REF.META.ENTITY.FRAMEWORK]
tags: entity,walkthrough,framework,morphism,composition,classification
related: [PROT.TOOL.COMPOSITE, PROT.SKILL.PROFILE, PROT.META.COMPOSITION]
---
## Framework comparison

| Dimension | Morphism | Guided Composition |
|-----------|----------|--------------------|
| Entity types | Tools | Skills, Commands |
| Composition | External (agent chains) | Internal (document prescribes) |
| Identity | `// @toolclass` | Entity ID in frontmatter |
| State | Automaton class (RECG/TRNS/GENR/SGNL) | State profile (skills) or flags (commands) |

## Walkthrough

### Entity 1: read-selection tool

```ts
// @toolclass RECG
export default tool({
  name: "read-selection",
  args: { type: tool.schema.string() },
  execute: async (args) => {
    // SELECT query — read only
    return result
  }
})
```

| Check | Classification |
|-------|---------------|
| Composition model | Agent chains externally; single input → single output |
| Identity declaration | `// @toolclass RECG` |
| Contains step sequence | excluded — atomic call |
| State awareness | RECG automaton (recognizer) |
| **Framework** | **Morphism** |

This tool is a morphism: atomic, externally composed, single direction (read), identity declared via `// @toolclass`.

### Entity 2: audit-pattern skill

```markdown
## Steps
1. Inventory all pattern .md files
2. For each file: validate frontmatter fields
3. Cross-reference check against patlib.db
4. Duplicate ID detection
5. Report violations with file:line format
6. Summarize compliance score
```

| Check | Classification |
|-------|---------------|
| Composition model | Document prescribes step sequence; executor reads and follows |
| Identity declaration | Entity ID in frontmatter (`id: SKL.AUDIT.PATTERN`) |
| Contains step sequence | Yes — 6 steps in prescribed order |
| State awareness | `state_profile: stateful-auditor` |
| **Framework** | **Guided Composition** |

This skill is a guided composition: internal sequence, document-prescribed steps, stateful-auditor for idempotent validation.

### Entity 3: sync-entity command

```yaml
id: CMD.SYNC.ENTITY
title: "Sync Entities — Write Patlib Data to DB"
steps:
  - Run write-sync to populate DB tables
  - Run read-validate to confirm structural compliance
  - Run read-selection to verify row count matches file count
```

| Check | Classification |
|-------|---------------|
| Composition model | Document prescribes step sequence; executor walks through |
| Identity declaration | Entity ID in frontmatter (`CMD.SYNC.ENTITY`) |
| Contains step sequence | Yes — 3 prescribed steps |
| State awareness | Flags in verb-domain name (`sync-entity`) |
| **Framework** | **Guided Composition** |

This command is a guided composition: workflow steps, verb-domain name encoding action sequence.

## Classification key

| Criterion | Morphism indicator | Guided composition indicator |
|-----------|-------------------|----------------------------|
| Composition | External agent chains step order | Document defines step order |
| Structure | Single entry and exit point | Multiple ordered sections |
| Identity | `// @toolclass` annotation | Frontmatter `id:` field |
| State | Automaton class code | State profile or verb-domain flags |

## Key insight

The framework is determined by how composition works; file extension or directory excluded. A `.ts` file with embedded step sequence is a guided composition masquerading as a morphism — restructure to skill. A `.md` skill with a single atomic action and zero steps is a morphism masquerading as a guided composition — convert to tool.

## See also

- `REF.META.ENTITY.FRAMEWORK` — the framework protocol this illustrates
- `PROT.TOOL.COMPOSITE` — category theory morphism model for tools
- `PROT.SKILL.PROFILE` — state classification for skills
- `PROT.META.COMPOSITION` — guided composition pattern
- `PROT.TOOL.AUTOMATON` — automaton class classification
