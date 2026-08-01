---
id: ILL.META.DECIDE
title: "Protocol vs Pattern — Apply the Decision Tree"
source: PROT.META.IDENTITY
summary: "Walkthrough of the protocol-vs-pattern decision tree applied to a plugin scoring concern: criteria and evaluation method both live in the protocol; concrete scores go in the illustration."
illustration: "A plugin scoring concern produces two files: PROT.PLUGIN.CANDIDATE.SCORING holds the seven-criteria table and evaluation method as a protocol; ILL.PLUGIN.CANDIDATE.SCORING holds concrete scores. No separate pattern file — the protocol captures both rules and method."
illustrates: [SPEC.ENTITY.DISTINCTION.BOUNDARY]
tags: entity,walkthrough,distinction,protocol,pattern,classification
related: [PROT.PLUGIN.CANDIDATE.SCORING, REF.META.ENTITY.FRAMEWORK]
---

A concern with both rules and method produces two files: a protocol (what) and an illustration (walkthrough). No separate pattern needed when the method is a direct expression of the protocol.

## Decision tree

| When the concern is... | Write a |
|------------------------|---------|
| Technical contract with enforcement | Protocol |
| Design principle with corollary rules | Pattern |
| Concrete walkthrough of a principle entity | Illustration |
| Evaluation criteria + method | Protocol only — method belongs in protocol body |

## Walkthrough

### Step 1: Protocol — criteria + method

`PROT.PLUGIN.CANDIDATE.SCORING.md` states the seven criteria and the evaluation method in one document:

```yaml
---
id: PROT.PLUGIN.CANDIDATE.SCORING
title: "Plugin Candidate Evaluation — Seven Criteria"
protocol: "A plugin candidate must score at least 6/7 across seven criteria. Each criterion is a binary pass/fail."
---
```

The protocol body includes:
- Structural criteria (what to build)
- Implementation criteria (how to build)
- Thresholds table (score ranges → action)
- Decision tree table (common scenarios)

The evaluation method is part of the protocol — it describes how to apply the criteria, not a separate pattern.

### Step 2: Illustration — concrete scores

`ILL.PLUGIN.CANDIDATE.SCORING.md` applies the method to real entities:

The illustration names specific plugins with concrete scores and explanations. Entity IDs, file paths, and score values appear only here — the protocol excludes them.

### Step 3: Cross-reference

- `PROT.PLUGIN.CANDIDATE.SCORING` links to `ILL.PLUGIN.CANDIDATE.SCORING` in See also
- `ILL.PLUGIN.CANDIDATE.SCORING` illustrates `PROT.PLUGIN.CANDIDATE.SCORING`

### Enforcement

`entity-audit` checks:
- Protocol uses `protocol:` field
- Protocol body contains no concrete plugin names or file paths
- Illustration body contains concrete named references

## Key insight

A concern with both rules and method produces two files, not three. The protocol captures the contract AND the generalized method. The illustration carries concrete instances. The pattern layer is unnecessary when the method is a direct expression of the protocol — no generalized evaluation rubric exists independent of the criteria.

This differs from concerns where the design principle (pattern) describes a morphism orthogonal to the protocol's entity description. Plugin evaluation is purely descriptive — no morphism exists, so no pattern is needed.

## See also

- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — the distinction protocol this illustrates
- `PROT.PLUGIN.CANDIDATE.SCORING` — criteria and evaluation protocol
- `ILL.PLUGIN.CANDIDATE.SCORING` — concrete scoring walkthrough
