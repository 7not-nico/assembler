**Code Element Ring** — eleven code elements order by inertness-to-composition in three groups. Lower rings sit inward; higher rings sit outward. The world of ideas forms the innermost ring — the pure conceptual realm, most inert; metaclasses form the outermost ring — the composition terminus. Ordinal precedence governs derivation: r0 → r10. Composition starts at the innermost ring (r0 ideas); each outward ring composes one or more inner rings.

## Group I — Formation (r0–r5)

The formation group builds the substrate, gives it reality, and opens it to meaning: the world of ideas, its shaping into abstracts, the binding of names, the structure that persists, the logical gates where new meaning arises, and the multitudinal representation that bends reality to accommodate mandates.

```
r0  ideas       — the world of ideas; the pure conceptual realm, no names, no reality; most inert
r1  abstract    — abstract objects, non-action nouns; ideas given shape
r2  binding     — propositions bind names to abstract objects; declarative relations
r3  structure   — action verbs hold the reality and give persistence
r4  logical gates — new meaning arises; life expands and contradicts
r5  multitudinal representation — reality twists to accommodate mandates; expressions evaluate in many manners
```

## Group II — Logical Gates (r1, r2, r4)

The gates where signals invert and combine — new meaning arises for life to expand and contradict.

```
r1  negation    — invert a signal; the gate of contradiction
r2  conjunction — both inputs hold; the gate of expansion
r4  disjunction — either input holds; the gate of choice
```

## Group III — Composition (r6–r10)

The composition group composes types and units onto the formed substrate.

```
r6  class       — composes methods + attributes into a named abstract
r7  module      — composes abstracts, objects, functions
r8  package     — composes modules
r9  decorator   — wraps a function or class; composition on composition
r10 metaclass   — shapes classes; the composition terminus
```

Ring r0 holds the world of ideas — the pure conceptual realm, before names, before reality. Reality does not exist until names derive from the ideas: abstract (r1) shapes them into non-action nouns, binding (r2) states propositions that bind names to the abstracts, structure (r3) acts with action verbs to hold the reality and give persistence, logical gates (r4) open new meaning, multitudinal representation (r5) bends reality to accommodate mandates. The gates group (Group II) details the signal logic: negation (r1), conjunction (r2), disjunction (r4). Variants ride their base rings: lambda, closure, generator, coroutine ride r4; classmethod, staticmethod, property, dunder ride r5; dataclass, enum, ABC, protocol ride r6; exception, context manager, iterator ride any abstract object at r1.

## Ordinal precedence

The chain r0 → r10 governs the derivation within and across the three groups. Group I rises r0 → r5 (formation); Group II gates r1, r2, r4 (logical gates); Group III rises r6 → r10 (composition). Each outward ring composes one or more inner rings: r1 shapes r0; r2 binds r1; r3 structures r2; r4 composes r3 (logical gates over structure — new meaning arises); r5 composes r4 (multitudinal representation — many manners over the gates); r6 composes r5; r7 composes r6, r4, r2, r1; r9 and r10 compose the rings above them.

## Escalation rule

Composition starts at r0 (the world of ideas). A build forms the substrate and opens it to meaning through Group I (r0 → r5), gates the signals through Group II (negation, conjunction, disjunction), then composes types and units through Group III (r6 → r10). Design starts at the innermost ring that suffices; a build rises ring by ring to r10. Ring r10 terminates the chain.

## Applicability

All code derivation in the workspace: program rebuilds, element classification, and composition ordering. The ordering applies to any object model; no reference language required.

---
id: RING.ELEMENT.PRECEDENCE
title: Code Element Ring — Three Groups, World of Ideas to Metaclass
source: assembler
summary: "Eleven code elements order by inertness-to-composition in three groups: Group I formation (r0 ideas … r5 multitudinal representation) builds the substrate and opens it to meaning — binding states propositions, structure acts with action verbs; Group II logical gates (r1 negation, r2 conjunction, r4 disjunction) gates the signals; Group III composition (r6 class to r10 metaclass) composes types and units. Ordinal precedence r0→r10 governs derivation; composition starts at the innermost ring."
specifies: Precedence chain of code elements in three groups, from the world of ideas to metaclass
tags: [code, element, ring, group, precedence, composition, ideas, abstract, binding, structure, logical-gates, negation, conjunction, disjunction, multitudinal-representation, class, module, package, decorator, metaclass, specification]
status: active
---
