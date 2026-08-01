---
id:               FORTH.SUBJECT
language:         Forth
role:             subject
title:            The data stack
definition:       "Forth is a language for direct communication between human beings and machines. Forth provides an economical, productive environment for interactive compilation and execution of programs"
sources:
  - section:      Forth 2012 Foreword
    url:          https://forth-standard.org/standard/foreword
  - section:      Forth 2012 §6.1 Core Words
    url:          https://forth-standard.org/standard/core
canonical:        1 2 + .
tags:             [stack, data-stack, return-stack, state-carrier, cell]
status:           draft
precedes:         [FORTH.OBJECT, FORTH.ACTION]
---

## Subject

The data stack. Forth carries all state on a LIFO data stack. Words consume values from and leave results on the stack. Every word's stack effect is documented with notation `( before -- after )`.

### Stack as primary state carrier

> Forth is a language for direct communication between human beings and machines. Forth provides an economical, productive environment for interactive compilation and execution of programs.

All data flows through the stack. Words push arguments onto the stack and pop results from it:

```forth
1 2 + .            \ push 1, push 2, + consumes both, pushes 3, . prints
```

Words are described by their stack effect:

```
DUP   ( x -- x x )        \ duplicate top
DROP  ( x -- )            \ discard top
SWAP  ( x y -- y x )      \ exchange top two
OVER  ( x y -- x y x )    \ copy second to top
ROT   ( x y z -- y z x )  \ rotate third to top
```

### Return stack

Standard Forth has two stacks. The return stack stores loop indices, return addresses, and temporary values:

```forth
>R   ( x -- )     \ push from data to return stack
R>   ( -- x )     \ pop from return to data stack
R@   ( -- x )     \ copy top of return stack

: example ( n -- )
    >R            \ save on return stack
    R@            \ peek at saved value
    R>            \ restore
;
```

### Named state: VARIABLE and VALUE

Forth provides named storage for persistent state:

```forth
VARIABLE count    \ create variable with cell storage
42 count !        \ store 42
count @           \ fetch → 42

100 VALUE max     \ define value
max               \ fetch → 100
200 TO max        \ set max to 200
```

## Summary

```
1 2 +              \ stack: ( 1 -- ) ( 1 2 -- ) ( 3 -- )
DUP                \ ( x -- x x )
SWAP               \ ( x y -- y x )
>R  R>             \ data/return stack transfer
VARIABLE x         \ named persistent state
```
