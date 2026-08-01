---
id:               COMMONLISP.OBJECT
language:         CommonLisp
role:             object
title:            The self-evaluating object
definition:       "A form that is neither a symbol nor a cons is defined to be a self-evaluating object. Evaluating such an object yields the same object as a result"
sources:
  - section:      CLHS §3.1.2.1.3 Self-Evaluating Objects
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_abac.htm
  - section:      CLHS §3.1.2.1.3.1 Examples
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_abac.htm
  - section:      CLHS §4 Types
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/04_a.htm
canonical:        42
tags:             [self-evaluating, type, number, character, string, symbol]
status:           draft
precedes:         []
---

## Object

The self-evaluating object. In Common Lisp, objects that are neither symbols nor conses evaluate to themselves. The type system encompasses numbers, characters, strings, symbols, conses, arrays, hash tables, functions, and CLOS objects.

### Self-evaluating objects (§3.1.2.1.3)

> A form that is neither a symbol nor a cons is defined to be a self-evaluating object. Evaluating such an object yields the same object as a result.

```lisp
42                  ; integer → evaluates to 42
3.14                ; float → evaluates to 3.14
"hello"             ; string → evaluates to "hello"
#\A                 ; character → evaluates to #\A
#(1 2 3)            ; vector → evaluates to #(1 2 3)
:keyword            ; keyword symbol → evaluates to :KEYWORD
```

### Type hierarchy (§4)

Common Lisp has a rich type system with both built-in and user-defined types:

```
t                   ; the universal type
  atom              ; not a cons
    number
      integer       ; (fixnum, bignum)
      ratio         ; exact fractions
      float         ; (short, single, double, long)
      complex       ; complex numbers
    character       ; Unicode characters
    symbol          ; named data object
    function        ; callable objects
    stream          ; input/output streams
    hash-table      ; key-value mappings
    array           ; n-dimensional array
      vector        ; 1-dimensional array
    string          ; (vector character)
    pathname        ; file system names
    random-state    ; random number state
  cons              ; (car . cdr) or list
    list            ; cons or null
      null          ; the empty list
structure           ; defstruct instances
standard-object     ; CLOS instances
```

### Symbols as objects

Symbols are unique, named data objects with multiple cells:

```lisp
'symbol-name        ; value cell — variable binding
(symbol-function '+)  ; function cell — function binding
(symbol-plist 'sym)   ; property list — metadata
(symbol-package 'sym) ; package — namespace
```

### Return values

> The evaluation of a form always yields a primary value, and possibly zero or more additional values.

Every evaluation produces values:

```lisp
(+ 1 2)             ; → 1 (primary value)
(truncate 7 3)      ; → 2, 1 (primary + secondary values)
(values 1 2 3)      ; → multiple values
(values)            ; → zero values
```

## Summary

```
42                  ; number → self-evaluating
#\A                 ; character → self-evaluating
"hello"             ; string → self-evaluating
T                   ; symbol (constant) → self-evaluating
:key                ; keyword → self-evaluating
'(1 2)              ; quoted list → Object
(x . y)             ; dotted pair → cons Object
#(1 2)              ; vector → self-evaluating
```
