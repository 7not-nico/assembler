---
id:               FORTH.ACTION
language:         Forth
role:             action
title:            The word execution
definition:       "Forth provides an economical, productive environment for interactive compilation and execution of programs. This extensibility allows the language to be quickly expanded and adapted to special needs"
sources:
  - section:      Forth 2012 Foreword
    url:          https://forth-standard.org/standard/foreword
  - section:      Forth 2012 §6.1 Core Words
    url:          https://forth-standard.org/standard/core
canonical:        ": square dup * ;"
tags:             [word, colon-definition, threaded-code, compile, execute]
status:           draft
precedes:         []
---

## Action

The word execution. Forth programs are composed of words — named sequences of instructions. The colon `:` compiles existing words into new definitions. The inner interpreter executes the threaded code. The outer interpreter reads input and dispatches words.

### Colon definition (§6.1.0450)

`:` compiles a new word by adding its body of word addresses to the dictionary:

```forth
: square ( n -- n^2 )
    dup *           \ compile DUP then *
;                   \ compile EXIT, end definition
```

Executing `square` runs its threaded code: DUP (duplicate stack), * (multiply), EXIT (return).

### Primitive stack actions

Words that manipulate the Subject (stack):

```forth
DUP    ( x -- x x )     \ copy top
DROP   ( x -- )         \ discard top
SWAP   ( x y -- y x )   \ exchange
OVER   ( x y -- x y x ) \ copy second
ROT    ( x y z -- y z x ) \ rotate third to top
NIP    ( x y -- y )     \ drop second
TUCK   ( x y -- y x y ) \ copy under top
2DUP   ( x y -- x y x y ) \ copy pair
```

### Arithmetic actions

```forth
+    ( n1 n2 -- sum )
-    ( n1 n2 -- diff )
*    ( n1 n2 -- product )
/    ( n1 n2 -- quotient )
MOD  ( n1 n2 -- remainder )
1+   ( n -- n+1 )
1-   ( n -- n-1 )
```

### Control flow actions

```forth
: test ( n -- )
    dup 0> IF ." positive" ELSE ." not positive" THEN ;

: countdown ( n -- )
    BEGIN
        dup . 1-
        dup 0= UNTIL
    DROP ;

: loop-example ( limit -- )
    0 DO
        i .            \ loop index
    LOOP ;
```

### Defining words

Words that create new Subject/Object structures:

```forth
VARIABLE x            \ create variable (Subject)
CONSTANT pi 314       \ create constant (Object)
: name ... ;           \ create colon definition (Action)
```

### Compilation vs interpretation

The outer interpreter has two states — interpret and compile:

```forth
SQUARE                \ interpret state: execute immediately
: word ... ;          \ compile state: compile into definition
[                     \ enter interpret state within a colon definition
]                     \ enter compile state
IMMEDIATE             \ mark word so it executes during compilation
```

### EXECUTE action

```forth
' DUP                 \ get execution token of DUP (tick)
EXECUTE               \ execute word by token
```

### Inner interpreter (threaded code)

The inner interpreter walks through the addresses in a word body, executing each word in sequence and advancing the instruction pointer.

## Summary

```
: word ( -- ) ... ;   \ colon definition — compile words
DUP SWAP ROT          \ stack manipulation
+ - * / MOD           \ arithmetic
IF ELSE THEN          \ conditional
DO LOOP               \ iteration
' EXECUTE             \ deferred execution
IMMEDIATE             \ compile-time word
```
