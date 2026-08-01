---
id:               RACKET.ACTION
language:         Racket
role:             action
title:            The simplification
definition:       Racket evaluation can be viewed as the simplification of expressions to obtain values — an expression that is not a value can always be partitioned into a redex and the continuation
sources:
  - section:      Racket Reference §1.1 Evaluation Model
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Evaluation_.Model%29
  - section:      Racket Reference §1.1.1 Sub-expression Evaluation and Continuations
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Sub_expression_.Evaluation_.And_.Continuations%29
  - section:      Racket Reference §1.1.2 Tail Position
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Tail_.Position%29
  - section:      Racket Reference §1.1.7 Procedure Applications and Local Variables
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Procedure_.Applications_.And_.Local_.Variables%29
canonical:        (+ 1 1)
tags:             [simplification, redex, continuation, evaluation, tail-position, call-by-value]
status:           draft
precedes:         []
---

## Action

The simplification. Evaluation is the stepwise reduction of expressions into values. Every non-value expression decomposes into a **redex** (the part reducible in one step) and a **continuation** (the surrounding evaluation context). Each step transforms the program state — the set of objects, the set of definitions, and the current expression. The arrow `→` marks one simplification step.

### Core definition — simplification (§1.1)

> Racket evaluation can be viewed as the simplification of expressions to obtain values. For example, just as an elementary-school student simplifies 1 + 1 = 2, Racket evaluation simplifies `(+ 1 1) → 2`.
>
> The arrow → replaces the more traditional = to emphasize that evaluation proceeds in a particular direction toward simpler expressions.

The Action is directional. Each step reduces the expression toward a value:

```racket
(+ 1 1)        →  2
(- 4 (+ 1 1))  →  (- 4 2)  →  2
```

### Redex and continuation (§1.1.1)

> An expression that is not a value can always be partitioned into two parts: a redex ("reducible expression"), which is the part that can change in a single-step simplification, and the continuation, which is the evaluation context surrounding the redex. In `(- 4 (+ 1 1))`, the redex is `(+ 1 1)`, and the continuation is `(- 4 [])`, where `[]` takes the place of the redex as it is reduced.

Every Action selects a redex within its continuation:

```racket
(- 4 (+ 1 1))
     └redex┘ └continuation: (- 4 [])┘
     →  (- 4 2)          ; redex replaced by its value
     →  2                ; (- 4 2) is now the redex; continuation is []
```

### Evaluation order (§1.1.1)

> Before some expressions can be evaluated, some or all of their sub-expressions must be evaluated. The specification of each syntactic form specifies how (some of) its sub-expressions are evaluated and then how the results are combined to reduce the form away.

Racket is call-by-value: arguments reduce to values before procedure application:

```racket
((lambda (x) (+ x 10)) (+ 1 2))
;    ↓ (+ 1 2) must simplify to 3 first
((lambda (x) (+ x 10)) 3)
;    ↓ argument value 3 placed in fresh location xloc
(+ xloc 10)
→  (+ 3 10)
→  13
```

### Tail position (§1.1.2)

> An expression expr1 is in tail position with respect to an enclosing expression expr2 if, whenever expr1 becomes a redex, its continuation is the same as was the enclosing expr2's continuation.
>
> Tail-position specifications provide a guarantee about the asymptotic space consumption of a computation.

Tail positions guarantee bounded space — loops written as recursion do not grow the continuation:

```racket
(define (sum n acc)
  (if (= n 0)
      acc                       ; tail position — continuation is the if's, not (sum ...)'s
      (sum (- n 1) (+ acc n)))) ; recursive call in tail position

(sum 1000000 0)   ; runs in constant space — no continuation growth
```

In contrast, `(+ 1 (sum (- n 1) acc))` would be non-tail — the continuation `(+ 1 [])` grows per step.

### Program state transformation (§1.1.4)

> Each evaluation step, then, transforms the current set of definitions and program into a new set of definitions and program.

The Action's full state is tripartite: objects, definitions, and the expression under evaluation:

```racket
; state before:
;   objects:    (define <o1> (vector 10 20))
;   defined:    (define x <o1>)
;   evaluate:   (vector-set! x 0 42)
; state after:
;   objects:    (define <o1> (vector 42 20))
;   defined:    (define x <o1>)
;   evaluate:   (void)
```

### Procedure application (§1.1.7)

> Racket procedure application works much the same way [as algebra substitution]. A procedure is an object, so evaluating `(f 7)` starts with a variable lookup.
>
> The location-generation and substitution step of procedure application requires that the argument is a value.

The canonical Action: look up the procedure value, evaluate arguments to values, create fresh locations, substitute:

```racket
(define f (lambda (x) (+ x 10)))
(f 7)
→  (<p1> 7)          ; f resolved to procedure object <p1>
→  (+ xloc 10)       ; fresh location xloc ← 7
→  (+ 7 10)          ; xloc resolved to its value
→  17
```

### Action kinds

```racket
(+ 1 1)                ; application: operator + operands reduce to value
(- 4 (+ 1 1))          ; nested application: redex-first reduction
(if (> x 0) a b)       ; conditional: select branch after predicate
(let ([x 10]) x)       ; binding: location creation + body reduction
(lambda (x) (+ x 1))   ; abstraction: value creation (no reduction)
(define x 10)          ; definition: adds x to definitions
(set! x 42)            ; mutation: changes location value
(values 1 2)           ; multiple values: continuation expects arity
```

## Cycle

```racket
(define acc 0)                 ; Action: add definition — Subject created
(for ([i (in-range 1 6)])      ; Action: iterate over range
  (set! acc (+ acc i)))        ; Action: read acc, add i, write acc
acc                            ; Action: resolve variable to value → 15
```

Every Racket program reduces to this cycle: definitions add Subjects to the state, expressions simplify (redex by redex) toward values, continuations route each reduced value to its next position, and the state (objects, definitions, expression) evolves one step at a time until a value remains.
