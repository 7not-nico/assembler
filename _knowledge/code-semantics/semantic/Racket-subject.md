---
id:               RACKET.SUBJECT
language:         Racket
role:             subject
title:            The location
definition:       A top-level variable is both a variable and a location — a new location is created for each variable on each application
sources:
  - section:      Racket Reference §1.1.7 Procedure Applications and Local Variables
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Procedure_.Applications_.And_.Local_.Variables%29
  - section:      Racket Reference §1.1.8 Variables and Locations
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Variables_.And_.Locations%29
  - section:      Racket Reference §1.1.4 Top-Level Variables
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Top_Level_.Variables%29
  - section:      Racket Reference §1.1.5 Objects and Imperative Update
    url:          https://docs.racket-lang.org/reference/eval-model.html#%28part._.Objects_.And_.Imperative_.Update%29
canonical:        (define x 10)
tags:             [location, variable, binding, lexical-scope, set!, place]
status:           draft
precedes:         [RACKET.OBJECT, RACKET.ACTION]
---

## Subject

The location. A storage cell created for each variable binding, holding a value. Top-level variables are both variable and location. Local variables (including procedure arguments) are replaced at runtime by fresh, ungeneratable locations — one per application. The Subject is accessed by evaluating a variable expression, which extracts the current value from the location's binding.

### Core definition — Variables and Locations (§1.1.8)

> A variable is a placeholder for a value, and expressions in an initial program refer to variables. A top-level variable is both a variable and a location. Any other variable is always replaced by a location at run-time; thus, evaluation of expressions involves only locations. A single local variable (i.e., a non-top-level, non-module-level variable), such as an argument variable, can correspond to different locations during different applications.

The Subject is dual: a variable is a source-program name; a location is the runtime storage cell. At runtime, all variables resolve to locations:

```racket
(define x 10)            ; top-level variable x — also a location
(define (f y) y)         ; y is a variable, replaced by a fresh location per call
(f 10)                   ; creates location xloc for y, places 10 in it
```

### Fresh location per application (§1.1.7)

> A new location is created for each variable on each application. The argument value is placed in the location, and each instance of the variable in the procedure body is replaced with the new location.

Procedure application creates a fresh Subject. Each call gets its own storage cell, enabling recursion and lexical closure:

```racket
(define (make-counter init)
  (lambda ()
    (begin
      (set! init (+ init 1))
      init)))

(define c1 (make-counter 0))  ; creates location initloc1 = 0
(define c2 (make-counter 10)) ; creates location initloc2 = 10
(c1)                          ; initloc1 → 0+1 = 1
(c1)                          ; initloc1 → 1+1 = 2
(c2)                          ; initloc2 → 10+1 = 11
```

### Top-level variables (§1.1.4)

> A set of top-level variables are available for substitutions on demand during evaluation.
>
> Each evaluation step, then, transforms the current set of definitions and program into a new set of definitions and program. Before a `define` can be moved into the set of definitions, its expression must be reduced to a value.

Top-level Subjects are part of the global definition set. `define` adds a new Subject; `set!` mutates an existing one:

```racket
(define x (+ 9 1))  ; creates x in definitions, assigns value 10
(set! x 8)           ; mutates x's location to 8
```

### Imperative update of objects (§1.1.5)

> In addition to `set!` for imperative update of top-level variables, various procedures enable the modification of elements within a compound data structure.

Compound Subjects (vector slots, struct fields, hash-table entries) are mutated through procedures like `vector-set!`, not through `set!`. The distinction parallels value vs object:

```racket
(define v (vector 10 20))   ; v: location holding a reference to a vector object
(vector-set! v 0 11)        ; mutates the object, not the location v
(set! v (vector 30 40))     ; mutates the location v to a new reference
```

### Module-level variables (§1.1.9)

> A module is essentially a prefix on a defined name, so that different modules can define the same name.

Modules scope Subjects. A `require` instantiates a module and creates its variables with module-specific prefixes:

```racket
(module m racket
  (define x 10))      ; x is module-prefixed — distinct from any top-level x
(require 'm)          ; instantiates module m, creates its variables
```

### Subject forms

```racket
(define x 10)           ; top-level variable — both variable and location
(let ([y 20]) y)        ; local variable — replaced by fresh location
(lambda (z) z)          ; argument variable — fresh location per call
(vector-set! v 0 5)     ; compound mutation — modifies object, not location
(set! x 42)             ; location mutation — changes stored value
x                       ; variable reference — evaluates to stored value
```

## Summary

```
(define x 10)            ; Subject: top-level location x ← 10
(let ([y 20]) y)         ; Subject: fresh location yloc ← 20
(lambda (z) z)           ; Subject: argument z replaced by zloc per call
(set! x 42)              ; mutation: xloc ← 42
(vector-set! v 0 5)      ; mutation: object slot, not location v
```
