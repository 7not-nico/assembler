---
id: ILL.CATALYST.SHIP
title: "Catalyst for Change — Shipping an 80% Tool That Unblocks Downstream"
source: PROT.META.COMPOSITION
summary: "A data validation tool stalls at 90% analysis paralysis. The agent ships an 80% version today — downstream work proceeds, the missing 20% is added next iteration."
illustration: "A validation tool for patlib entities stalls at 90% — the agent ships the 80% version covering 3 of 4 entity types, downstream consumers proceed, and the remaining type ships next iteration."
illustrates: [MAX.CATALYST.FOR.CHANGE]
tags: walkthrough,pragmatism,ship,iteration,analysis-paralysis
related: [PAT.TRACER.BULLETS.PRACTICE, MAX.PROTOTYPE.TO.LEARN, MAX.REFACTOR.EARLY.OFTEN]
---
## Context

`MAX.CATALYST.FOR.CHANGE` says to do what you can with what you have. A patlib validation tool needs to validate four entity types: patterns, terms, protocols, maxims. The agent plans a unified validator with shared schema inference. Two hours in, the unified approach is still in design. Downstream consumers are blocked.

## Walkthrough

### Step 1: Analysis paralysis on the unified validator

The agent designs a schema-inference engine that reads all four entity type schemas from a single table. The type hierarchy is complex — terms have `description`, patterns have `principle`, protocols have `protocol`. Merging them into one validator requires four conditional branches, a discriminator field, and a fallback for unknown types.

### Step 2: Decide to ship 80% — validate three types now

The agent stops designing. Three entity types (patterns, terms, protocols) share enough structure to validate with a single switch:

```ts
switch (type) {
  case "patterns": return validatePattern(body);
  case "terms": return validateTerm(body);
  case "protocols": return validateProtocol(body);
  default: return { valid: true, errors: [] }; // maxims deferred
}
```

This takes 20 minutes instead of 2 hours. It validates 3 of 4 types correctly. Downstream consumers can use it immediately.

### Step 3: Downstream unblocked

The sync pipeline integrates the validator:

```bash
bun run validate --type patterns
bun run validate --type terms
bun run validate --type protocols
```

A new CI gate uses it. Three entity types are now checked on every push.

### Step 4: Add maxims next iteration

The next iteration adds maxim validation — a dedicated function matching the maxim schema:

```ts
case "maxims": return validateMaxim(body);
```

The unified schema inference remains a design idea. It may ship next quarter. The 80% tool already adds value today.

## Key insight

Imperfect and existing beats perfect and specified. Shipping the 80% validator unblocked downstream consumers and created real quality gates. The remaining 20% (maxims) was added in the next iteration with zero redesign — the switch-case pattern extended naturally. Perfection deferred is not perfection abandoned; it is perfection prioritized.

## See also

- `MAX.CATALYST.FOR.CHANGE` — the maxim this illustrates
- `PAT.TRACER.BULLETS.PRACTICE` — tracer bullets grow; prototypes get discarded
- `MAX.PROTOTYPE.TO.LEARN` — distinguish throwaway from keeper
- `MAX.REFACTOR.EARLY.OFTEN` — refactor the 80% version when it hardens
