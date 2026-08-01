---
id: ILL.TERM.UMBRELLA.GROUP
title: "Umbrella Term Walkthrough — Setting Up a PNN Term Hierarchy"
source: PROT.TERM.SCHEMA
summary: "Walk through creating an umbrella term for Physics-Defined Neural Networks: create the umbrella, add child terms for PNN, PINN, HPN, verify bidirectional links, and confirm shared prefix and body contrast."
illustration: "An agent creates COG.PHYSICS.DEFINED.NEURAL.NETWORKS as umbrella, then adds child terms COG.PHYSICAL.NEURAL.NETWORKS and COG.PHYSICS.INFORMED.NEURAL.NETWORKS — verifying bidirectional related links, shared prefix, and sibling contrast in body text"
illustrates: [PROT.TERM.SCHEMA]
tags: convention,taxonomy,umbrella,walkthrough,term,hierarchy
related: [PROT.TERM.SCHEMA, REF.META.NAMING.SCHEMA]
---
## Rationale

The patlib has three neural network terms that share a conceptual parent: Physical Neural Networks (PNN), Physics-Informed Neural Networks (PINN), and Hebbian Physics Networks (HPN). They need a consistent hierarchy with bidirectional cross-references.

## Walkthrough

### Step 1: Create the umbrella term

The agent creates the umbrella first per rule 1:

```yaml
---
id: COG.PHYSICS.DEFINED.NEURAL.NETWORKS
title: "Physics-Defined Neural Networks"
tags: neural-networks,physics,physical-computing,PNN,PINN,HPN,machine-learning,paradigms
related: [COG.PHYSICAL.NEURAL.NETWORKS, COG.PHYSICS.INFORMED.NEURAL.NETWORKS, COG.HEBBIAN.PHYSICS.NETWORK]
---
```

The umbrella:
- Has `PHYSICS.DEFINED.NEURAL.NETWORKS` as ID — shared prefix with children
- Lists all three children in `related` per rule 2

### Step 2: Create each child term

Child terms all share the initial ID prefix `PHYSICS` or `PHYSICAL` per rule 3:

```yaml
---
id: COG.PHYSICAL.NEURAL.NETWORKS
title: "Physical Neural Networks (PNNs)"
related: [COG.PHYSICS.DEFINED.NEURAL.NETWORKS]
---
```

```yaml
---
id: COG.PHYSICS.INFORMED.NEURAL.NETWORKS
title: "Physics-Informed Neural Networks (PINNs)"
related: [COG.PHYSICS.DEFINED.NEURAL.NETWORKS]
---
```

```yaml
---
id: COG.HEBBIAN.PHYSICS.NETWORK
title: "Hebbian Physics Networks (HPNs)"
related: [COG.PHYSICS.DEFINED.NEURAL.NETWORKS]
---
```

Each child links back to the umbrella. No child-children links per flat hierarchy rule 5 — siblings link only to the umbrella.

### Step 3: Verify bidirectional linking

Agent checks each link direction:

- Umbrella → child: `COG.PHYSICS.DEFINED.NEURAL.NETWORKS.related` lists `[COG.PHYSICAL.NEURAL.NETWORKS, ...]`
- Child → umbrella: `COG.PHYSICAL.NEURAL.NETWORKS.related` includes `COG.PHYSICS.DEFINED.NEURAL.NETWORKS`

Bidirectional linking confirmed per rule 2.

### Step 4: Verify body contrast

Each child body distinguishes itself from siblings per rule 4:

| Term | Distinguishing feature |
|------|----------------------|
| PNN | Physical hardware substrates — analog, optical, photonic |
| PINN | PDE loss regularization — soft physics constraint |
| HPN | Hebbian learning + conservation laws — thermodynamic transport |

The umbrella body enumerates all three in one sentence:

> Three neural network paradigms operate under the physics-defined umbrella: Physical Neural Networks (physical hardware substrates), Physics-Informed Neural Networks (PDE loss regularization), and Hebbian Physics Networks (thermodynamic transport).

### Step 5: Flat hierarchy check

Agent confirms max one level — no child has its own children. The hierarchy is flat per rule 5.

## Key insight

The umbrella pattern replaces ad-hoc cross-referencing with a structured hierarchy. The bidirectional link constraint ensures both directions stay consistent — any tool that traverses `related` finds the full group from either entry point. The flat-max-one-level rule keeps the pattern simple: umbrella enumerates, children contrast, no nesting.

## See also

- `PROT.TERM.SCHEMA` — the umbrella term pattern this walkthrough illustrates
- `PROT.TERM.SCHEMA` — term entity schema and format
- `REF.META.NAMING.SCHEMA` — naming rules for term IDs
- <COG.PHYSICS.DEFINED.NEURAL.NETWORKS> — concrete umbrella example
