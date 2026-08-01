# Subject, Object, Action — Statement Structure

Subject, Object, and Action are **syntactic roles** determined by the *statement structure* — how the three elements bind together grammatically. They are not code order, file layout, or loop sequence.

## The three roles

```
Subject  — the accumulator / storage location (persistent state)
Object   — the operand / transient value
Action   — the operator / transformation
```

## The statement is the unit

Every calculator variant is a distinct **statement form**. The binder — the syntactic glue that joins the roles — defines the variant, not token position.

```
Binder    Statement                       Variants
--------  ------------------------------  -------------------------
=         subject = action(subject,obj)   IMP
.         subject.action(object)          MTH
infix     subject action object           SAO, OAS
prefix    action subject object           ASO, AOS
postfix   subject object action           SOA, OSA
stack     [subject object] action         STK
<-        ch <- cmd                       CHN
defer     defer action(acc, v)            DFR
thunk     t = combine(subject, object)    EVL
type      switch v := x.(type)            IFC
reduce    reduce(ops, vals)               MAP
```

## What the statement structure determines

1. **Binding** — what joins the roles:
   - assignment `=`
   - method dispatch `.`
   - function application `()`
   - channel send/receive `<-`
   - defer, switch, reduce

2. **Action position** — where the operator sits:
   - before operands (prefix: ASO, AOS)
   - between operands (infix: SAO, OAS)
   - after operands (postfix: SOA, OSA)

3. **Result flow** — how the outcome moves:
   - assignment target (IMP)
   - return value (MTH, EVL)
   - channel send (CHN)
   - deferred unwind (DFR)
   - accumulated fold (MAP)

## The semantic core is invariant

Regardless of statement structure, every variant computes the same core:

```
result = Apply(action, subject, object)
```

The statement structure positions the three roles in the grammar; the semantic core evaluates them. The variants differ in *syntax*, not *semantics*.

## Natural language parallel

Statement structure mirrors human sentence grammar:

```
SVO:  "The dog bites the ball"   → subject action object  (SAO)
SOV:  "The dog the ball bites"   → subject object action  (SOA)
VSO:  "Bites the dog the ball"   → action subject object  (ASO)
VOS:  "Bites the ball the dog"   → action object subject  (AOS)
OVS:  "The ball bites the dog"   → object action subject  (OAS)
OSV:  "The ball the dog bites"   → object subject action  (OSA)
```

## Implication for design

Condensing variants means grouping by **binder type** (statement structure), not by token order. Variants sharing a binder share a grammar; variants with different binders are structurally distinct statements.
