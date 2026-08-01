---
id:               RACKET.OBJECT
language:         Racket
role:             object
title:            The value
definition:       A value is an expression that evaluation simplifies no further — a value is a reference to an object stored somewhere else
sources:
  - section:      Racket Reference §1.1 Evaluation Model
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Evaluation_.Model%29
  - section:      Racket Reference §1.1.5 Objects and Imperative Update
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Objects_.And_.Imperative_.Update%29
  - section:      Racket Reference §1.1.1 Sub-expression Evaluation and Continuations
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Sub_expression_.Evaluation_.And_.Continuations%29
canonical:        42
tags:             [value, object, self-evaluating, reference, atomic, compound, procedure]
status:           draft
precedes:         []
---

## Object

The value. An expression that evaluation simplifies no further. Racket distinguishes values (results of expressions) from objects (heap-allocated storage containers): a value is a reference to an object stored somewhere in the program state. Some kinds of objects — booleans, `(void)`, small exact integers — serve directly as values; all other values are references to mutable or immutable objects in the store.

### Core definition — Values (§1.1)

> A value, such as the number 2, is an expression that evaluation simplifies no further.

Evaluation stops when it reaches a value. Numbers, strings, characters, booleans, symbols, procedures, pairs, vectors, hash tables — each is a value that needs no further reduction:

```racket
42                            ; numeric value — no further simplification
"hello"                       ; string value
#t                            ; boolean value
'symbol                       ; symbol value
(lambda (x) (+ x 1))          ; procedure value — also a value!
```

### Value vs Object (§1.1.5)

> We must distinguish between values, which are the results of expressions, and objects, which actually hold data.
>
> A few kinds of objects can serve directly as values, including booleans, `(void)`, and small exact integers. More generally, however, a value is a reference to an object stored somewhere else. For example, a value can refer to a particular vector that currently holds the value 10 in its first slot. If an object is modified via one value, then the modification is visible through all the values that reference the object.

The Object is dual: a self-evaluating entity (value) that may be a reference to a heap-allocated container (object). Mutation through one reference is visible through all:

```racket
(define v (vector 10 20))     ; v: value = reference to a vector object
(define w v)                  ; w: same value = same reference
(vector-set! v 0 42)          ; mutates the object through reference v
(vector-ref w 0)              ; 42 — mutation visible through w
(define x 5)                  ; 5: self-evaluating — no separate object
(define y 5)                  ; 5: same self-evaluating value (small fixnums are direct)
```

### Anonymous object references (§1.1.5)

> An object reference can never appear directly in a text-based source program. A program representation created with `datum->syntax`, however, can embed direct references to existing objects.

In the formal evaluation model, the program state uses angle-bracketed `<o1>` to denote object references — values that are not source code but runtime entities:

```
state before:     objects: (<o1> = (vector 10 20))
                   evaluate: (vector-ref <o1> 0)  →  10

state after:      objects: (<o1> = (vector 11 20))
                   evaluate: (vector-ref <o1> 0)  →  11
```

### Value kinds

Racket's values span a rich set of types, each acting as a self-evaluating object or a reference to one:

```racket
42                     ; number — self-evaluating
#t                     ; boolean — self-evaluating
#\A                    ; character — self-evaluating
"hello"                ; string — immutable sequence
'symbol                ; symbol — interned, self-evaluating
'(1 2 3)               ; pair/list — compound value
(vector 1 2 3)         ; vector — mutable compound
(hash "a" 1 "b" 2)     ; hash table — mutable mapping
(lambda (x) x)         ; procedure — closure value
(struct posn (x y))    ; structure — user-defined
<o1>                   ; object reference — runtime-only, not writable in source
```

### Multiple return values (§1.1.3)

> A Racket expression can evaluate to multiple values.

An expression can produce multiple Objects. Continuations expect a specific number of values:

```racket
(values 1 2 3)         ; produces 3 values
(call-with-values
  (lambda () (values 1 2))
  (lambda (a b) (+ a b)))  ; receives 2 values as a and b
```

### Value forms

```racket
42                       ; atomic value: number
"hello"                  ; atomic value: string
#t                       ; atomic value: boolean
'symbol                  ; atomic value: symbol
(lambda (x) x)           ; compound value: procedure
(vector 1 2 3)           ; compound value: mutable vector
'(1 2 3)                 ; compound value: quoted list
(struct posn (x y))      ; compound value: structure
(values 1 2)             ; compound value: multiple values
<o1>                     ; object reference: runtime-only value
```

## Summary

```
42                       ; self-evaluating value — number
"hello"                  ; self-evaluating value — string
'symbol                  ; self-evaluating value — symbol
(lambda (x) x)           ; value — procedure (closure)
(vector 1 2 3)           ; value — reference to mutable object
<o1>                     ; value — runtime-only object reference
(values 1 2)             ; value — multiple return values
```
