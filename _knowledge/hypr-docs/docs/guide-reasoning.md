---
name: guide-reasoning
description: Use this skill when designing or implementing — it guides every decision by first consulting MAX.* for principles, SPEC.* for architecture, IDENTITY.* for entity definitions, and PROT.* for technical contracts, and RUL.* for instruction-writing constraints
state-profile: stateless
type: reference
related: [CMD.ANCHOR.WORKFLOW, SPEC.KNOWLEDGE.CLASSIFICATION, SPEC.KNOWLEDGE.VECTOR, MAX.DRY, MAX.ORTHOGONALITY, RUL.DECLARATIVE.OVER.IMPERATIVE, RUL.AVOID.NEGATION.PRIMING, RUL.CONSTRAINT.SATURATION.LIMIT, RUL.POSITIVE.NEGATIVE.RATIO, RUL.BRIDGE.CONSTRAINT, RUL.OUTPUT.SHAPE.SPECIFICATION]
---

**Procedure**

0. Before any design decision, consult patlib for relevant **MAX.*** maxims — they encode the guiding philosophy and principles.

1. Before any implementation, consult patlib for relevant **SPEC.*** specifications — they define the entity system architecture (topology, edge semantics, naming rules, classification).

2. Consult **IDENTITY.*** entities — they define what each entity type IS (ring, group, naming convention, scope).

3. Consult **PROT.*** protocols — they encode the technical contracts and conventions for specific entity types.

4. Consult **RUL.*** instruction-writing rules — they encode constraint management principles derived from LLM mechanistic evidence:
   - `RUL.DECLARATIVE.OVER.IMPERATIVE` — declarative register over imperative for LLM-facing instructions (81% cross-lingual variance reduction)
   - `RUL.AVOID.NEGATION.PRIMING` — name desired state, not forbidden action (87.5% priming failure rate)
   - `RUL.CONSTRAINT.SATURATION.LIMIT` — ≤5-6 constraints per block (exponential decay beyond threshold)
   - `RUL.POSITIVE.NEGATIVE.RATIO` — ≥3:1 positive-to-negative ratio (>40% negatives → breakdown)
   - `RUL.BRIDGE.CONSTRAINT` — bridge constraints resolve conflicting requirements (39% violation reduction)
   - `RUL.OUTPUT.SHAPE.SPECIFICATION` — positive shape requirements over prohibitions

5. Maxims answer **why** (principle, rationale). Specifications answer **what** (system architecture). Identities answer **what IS** (entity definitions). Protocols answer **how** (rules, format, enforcement). Rules answer **with what constraints** (capacity, ratio, register). All are needed.

6. Cross-reference with `CMD.ANCHOR.WORKFLOW` — always run anchored skills in parallel.

**Gotchas**

- Maxims are Architectonic R0 — read them first per outer→inner reasoning (SPEC.KNOWLEDGE.CLASSIFICATION)
- Specifications are Architectonic R1 — system architecture (entity topology, edge semantics, naming rules)
- Identities are Encyclopedic R3 — define what each entity type IS (ring, group, naming, scope)
- Protocols are Architectonic R4 — encode enforceable contracts with concrete rules
- Instruction-writing rules (RUL.DECLARATIVE.OVER.IMPERATIVE through RUL.OUTPUT.SHAPE.SPECIFICATION) apply whenever LLM-facing instructions are authored — not just during validation
- When a maxim and protocol conflict, the protocol takes precedence (concrete implementation of the principle)
- `RUL.QUERY.PATLIB.CONTEXT` already mandates patlib before every task — this skill adds the ordering
