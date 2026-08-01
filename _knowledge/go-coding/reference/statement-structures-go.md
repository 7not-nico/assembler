# All Statement Structures in Go — by Semantic Arrangement

Every Go statement expresses the Subject-Object-Action triad in a syntactic arrangement. The arrangement is determined by the **binder** — the grammar glue joining the roles. This document enumerates the complete space: 6 linear permutations × 8 binder families.

```
Source: Go Spec §Statements
URL:    https://go.dev/ref/spec#Statements

Source: Go Spec §Expressions
URL:    https://go.dev/ref/spec#Expressions
```

## The roles

```
Subject  — variable: storage location (GO.SUBJECT)
Object   — value: typed quantity (GO.OBJECT)
Action   — statement + expression: evaluation, control flow, concurrency (GO.ACTION)
```

## The invariant semantic core

```
result = Apply(action, subject, object)
```

Every Go statement computes this core; the statement structure only positions the roles in the grammar.

## 1. The six linear permutations

```
perm   arrangement   natural Go syntax       realized by variant
-----  -----------   ---------------------   ------------------
SAO    S A O         s + o                   sao (infix operator)
ASO    A S O         action(s, o)            aso (prefix call)
OSA    S O A         s o +  (stack)          osa (postfix, stack top two)
SOA    S O A         — (reordered)           soa (prompt order)
AOS    A O S         — (Polish, reordered)   aos (prompt order)
OAS    O A S         — (reordered)           oas (prompt order)
```

Go natively expresses SAO (binary infix), ASO (call prefix), OSA (stack-based). The remaining three (SOA, AOS, OAS) require reordering into one of the native forms.

## 2. Every Go grammar form annotated

```
Grammar form            Arrangement                    Subject        Object      Action
---------------------  -----------------------------   -------------  ----------  ---------
s = f(s, o)            S ← A(S, O)    assignment        s              o           f
s := f(s, o)           S ← A(S, O)    short decl        s              o           f
s++  /  s--            S ← A(S)       inc/dec           s              —           ++/--
s + o                  S A O          infix binary      s              o           +
s.f(o)                 S.A(O)         method call       s              o           f
f(s, o)                A(S, O)        call expression   s              o           f
ch <- v                S <- O         send              ch             v           <-
v := <-ch              S <- A         receive           v              ch          <-
v, ok := x.(T)         S,ok = A(x,T)  type assertion    v, ok          x, T        .(T)
switch v := x.(type)   A on S         type switch       v              x           switch
for i, v := range c    A iterates S   range             i, v           c           range
go f(s)                concurrent A   go statement      s              —           f
defer f(s)             delayed A      defer statement   s              —           f
select { case <-ch }   rendezvous A   select            —              ch          select
return s               S → caller     return            s              —           return
```

```
Source: Go Spec §SimpleStmt
URL:    https://go.dev/ref/spec#SimpleStmt
```

The Go statement grammar:

```
Statement  = Declaration | LabeledStmt | SimpleStmt |
             GoStmt | ReturnStmt | BreakStmt | ContinueStmt | GotoStmt |
             FallthroughStmt | Block | IfStmt | SwitchStmt | SelectStmt | ForStmt |
             DeferStmt .

SimpleStmt = EmptyStmt | ExpressionStmt | SendStmt | IncDecStmt | Assignment | ShortVarDecl .
```

## 3. Binder classification

```
Binder    Statement                       Variant
--------  ------------------------------  -------
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

## 4. Concurrency as Action — Go-unique forms

```
Source: Go Spec §Go statements
URL:    https://go.dev/ref/spec#Go_statements
```

> A "go" statement starts the execution of a function call as an independent concurrent thread of control, or goroutine, within the same address space.

```
Source: Go Spec §Defer statements
URL:    https://go.dev/ref/spec#Defer_statements
```

> Deferred functions are invoked immediately before the surrounding function returns, in the reverse order they were deferred.

```
Source: Go Spec §Select statements
URL:    https://go.dev/ref/spec#Select_statements
```

> A "select" statement chooses which of a set of possible send or receive operations will proceed.

```
go f(s)      — Action forked, caller continues (shares Subjects)
defer f(s)   — Action scheduled, LIFO at return (args bound at defer site)
<-ch / ch<-v — Action blocks until rendezvous (send = Action, receive = Action)
select       — Action chooses among channel operations
```

## 5. Complete enumeration — 14 variants

```
calc_perm.go      soa sao aos aso osa oas  — 6 linear permutations, one engine
calc_method.go    method                   — subject.action(object)
calc_imperative.go imperative              — subject ← action(subject, object)
calc_stk.go       stk                      — [s o] action (Forth-style)
calc_chn.go       chn                      — channel send/receive
calc_ifc.go       ifc                      — interface{} type switch
calc_dfr.go       dfr                      — defer LIFO
calc_evl.go       evl                      — thunk composition
calc_map.go       map                      — reduce
```

## Conclusion

All Go statement structures reduce to the invariant `result = Apply(action, subject, object)`. The 6 permutations vary linear token order; the 8 structural forms vary the binder. Go's grammar natively offers assignment, method dispatch, infix operator, function call, channel send/receive, go, defer, select, type switch/assertion, range, and inc/dec — each assigns S/O/A roles to its syntactic parts. The project's 14 variants cover the complete space: every permutation × every binder family.
