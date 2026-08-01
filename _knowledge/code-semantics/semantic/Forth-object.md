---
id:               FORTH.OBJECT
language:         Forth
role:             object
title:            The stack cell value
definition:       "Forth provides low-level access to computer-controlled hardware, and the ability to extend the language itself. A cell is the primary unit of storage"
sources:
  - section:      Forth 2012 Foreword
    url:          https://forth-standard.org/standard/foreword
  - section:      Forth 2012 §6.1 Core Words
    url:          https://forth-standard.org/standard/core
canonical:        42
tags:             [cell, integer, value, address, flag]
status:           draft
precedes:         []
---

## Object

The stack cell value. Forth operates on cell-sized values pushed and popped from the data stack. A cell is large enough to hold an address. Values include integers, addresses, and flags.

### Cell as fundamental unit

```forth
42                  \ integer cell value
-1                  \ true flag (all bits set)
0                   \ false flag
```

### Numeric operations on values

```forth
2 3 +               \ → 5
7 4 -               \ → 3
3 4 *               \ → 12
10 3 /              \ → 3 (integer division)
10 3 MOD            \ → 1 (remainder)
```

### Boolean values

Forth uses 0 for false and -1 (all bits set) for true:

```forth
1 1 =               \ → -1 (true)
1 0 =               \ → 0 (false)
0=                  \ true if top is 0
0<                  \ true if top is negative
```

### Address values

Addresses are cell-sized values for memory operations:

```forth
VARIABLE x
x                    \ pushes address of x
42 x !               \ store 42 at address
x @                  \ fetch → 42
```

### Character values

```forth
CHAR A               \ → 65 (ASCII code)
EMIT                 \ display character from code
```

### Stack measurement

```forth
DEPTH               \ ( -- n ) number of items on data stack
```

## Summary

```
42                   \ integer cell
-1                   \ true flag
0                    \ false flag
x                    \ address of x (cell)
CHAR A               \ character code (65)
```
