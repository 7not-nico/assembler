---
id: REF.META.SPECIALIZATION
title: Compartment Specialization — Membrane-Mediated System Architecture
source: PROT.META.IDENTITY
summary: "A system organized into bounded compartments scales beyond the complexity ceiling of monolithic architectures."
ref: "Membrane type field value: autonomous, shared-substrate, or infrastructure. Compartment registration field count: exactly 3. Cross-compartment channel count: exactly 1 per direction. Process families per compartment: maximum 1. New capabilities per new compartment: exactly 1. Shared state across boundary: excluded."
tags: [architecture, modularity, compartmentalization, bounded-context, design-principle, coupling]
---

An architectural principle organizing systems into bounded subunits (compartments), each specialized for a distinct function and isolated by a boundary (membrane). Derived from the biological organelle pattern: incompatible processes occupy separate compartments; boundary type determines coupling mode; inter-compartment communication formalized; origin governs lifecycle. Generalizes bounded context (DDD) and modular design.

## Protocol

1. **Membrane type** — one of three classes:

   | Class | Membrane | Autonomy |
   |-------|----------|----------|
   | Autonomous | Double-membrane | Owns data, schema, lifecycle, deployment |
   | Shared-substrate | Single-membrane | Shares host runtime, tighter coupling |
   | Infrastructure | No membrane | Ubiquitous, no isolation |

2. **Process families per compartment** — maximum 1. Conflicting resource profiles, consistency models, latency requirements, or security contexts require separate compartments.

3. **New capabilities per new compartment** — exactly 1. Existing compartments retain fixed scope.

4. **Cross-compartment channel count** — exactly 1 per direction. Shared state across boundary: excluded.

5. **Governance** — acquired compartments retain lifecycle, schema, deployment. Derived compartments follow host governance.

## Gotchas

| Signal | Detection | Redirect |
|--------|-----------|----------|
| Type count per compartment exceeds 1 | Process families per compartment above maximum | Split |
| Store access per compartment exceeds 1 | Compartment reaches into another data store | Channel |
| Acquired compartment lifecycle enforced as derived | Host controls forced on acquired system | Retain independent lifecycle |
| Compartment split without conflicting profiles | Compartments created before conflicts emerge | Start monolithic, split on conflict |
| Governance mismatches membrane type | In-process module treated as independent deployment | Align governance to membrane class |
| Conflicting profiles per compartment exceeds 1 | Two profiles share module with no boundary | Boundary |

## Enforcement

Convention — peer review on architecture decisions that add, split, or merge compartments. New compartment proposals declare membrane type, incompatible process rationale, and governance model per the registration rule.

## Applicability

System architecture at the bounded-context and service decomposition level. Design discussions about module boundaries, service extraction, and integration patterns.

Excluded for:
- Single-module systems with no conflicting process profiles
- In-process performance optimization where isolation overhead exceeds benefit
- Data modeling at granularity finer than compartment boundaries

## See also

- `CON.COMPARTMENT.SPECIALIZATION` — concept definition
- `DEF.ORGANELLE` — biological source metaphor
- `CON.BOUNDED.CONTEXT` — DDD framing
- `PROT.META.DOMAIN.DIRECTORY` — domain extraction as directory structure
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — component independence
- `PROT.LIB.PURITY.BOUNDARY` — purity boundary as a single-membrane compartment
- `PROT.LIB.CONTRACT` — module contract as derived-compartment governance
