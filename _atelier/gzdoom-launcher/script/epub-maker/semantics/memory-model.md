# Memory model

ZScript objects live under a garbage collector; destruction is nondeterministic unless the object participates in the GC graph.

## Collection semantics

- `Destroy()` runs "just before the object is collected by the garbage collector"
- Collection is nondeterministic unless the object links into the GC chain
- The docs note ZDoom's GC "is entirely wasteful" for certain patterns — authors should avoid allocations that trigger collection

## Reachability

- Explicit actor pointers govern cross-object references
- Object-scoping and action-scoping (Concepts chapter) bound when references remain valid
- `null` appears in 13 chapters — null literals and null checks are first-class

## Pointer escapes

- `@`-prefixed native pointers reference objects directly in structure data
- Class-reference types keep object identity without pointer escapes
- Scope rules decide which references survive state transitions

## Implication

Scripts must treat object lifetime as engine-managed. Deterministic teardown requires explicit `Destroy()` in known-safe states; relying on collection timing is a documented anti-pattern.
