---
id:               HASKELL.SUBJECT
language:         Haskell
role:             subject
title:            The pure function and monad
definition:       "Haskell is a general purpose, purely functional programming language. Haskell provides higher-order functions, non-strict semantics, static polymorphic typing, user-defined algebraic datatypes, pattern-matching, a monadic I/O system"
sources:
  - section:      Haskell 2010 §1 Introduction
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch1.html
  - section:      Haskell 2010 §3 Expressions
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch3.html
  - section:      Haskell 2010 §6 Predefined Types and Classes
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch6.html
  - section:      Haskell 2010 §5 Modules
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch5.html
canonical:        f x
tags:             [function, monad, pure, io, value, state-carrier]
status:           draft
precedes:         [HASKELL.OBJECT, HASKELL.ACTION]
---

## Subject

The pure function and monad. In Haskell, the fundamental entity is the function — a first-class value that maps inputs to outputs. Purely functional means no side effects; state is threaded through monadic computations.

### Purely functional foundation (§1)

> Haskell is a general purpose, purely functional programming language incorporating many recent innovations in programming language design. Haskell provides higher-order functions, non-strict semantics, static polymorphic typing, user-defined algebraic datatypes, pattern-matching, a monadic I/O system.

A Haskell program is a collection of functions. The Subject in Haskell is the function or value bound by a declaration. Functions are first-class — they can be passed as arguments, returned as results, and stored in data structures.

### Expressions denote values (§3)

> An expression denotes a value and has a static type; expressions are at the heart of Haskell programming "in the small."

Every expression evaluates to a value of a known type. The Subject is the value that expressions denote:

```haskell
x = 42              -- value binding: x denotes 42
f = \n -> n + 1     -- function binding: f denotes a function
```

### Monadic IO as state carrier (§6)

> The IO type serves as a tag for operations (actions) that interact with the outside world. The IO type is abstract: no constructors are visible to the user. IO is an instance of the Monad and Functor classes.

Stateful computation is modeled through monads. The IO monad carries the world state through the program:

```haskell
main :: IO ()
main = do
    putStrLn "hello"   -- IO action that produces state change
    line <- getLine    -- binds input, threading IO state
```

Monadic bind `(>>=) :: IO a -> (a -> IO b) -> IO b` threads the state — the Subject transforms through each action while the world state remains implicit.

### Program entry point (§5)

> A Haskell program is a collection of modules, one of which must be called Main and must export the value main. The value of the program is the value of the identifier main in module Main, which must be a computation of type IO τ for some type τ. When the program is executed, the computation main is performed, and its result (of type τ) is discarded.

The initial Subject of every Haskell program is `main :: IO τ`. The program's execution is the evaluation of this IO computation.

### Functions are abstract (§6)

> Functions are an abstract type: no constructors directly create functional values.

Unlike algebraic datatypes, functions have no visible constructors. They are created by lambda abstraction and applied by juxtaposition.

## Summary

```
f x                 -- function as Subject, applied to Object
main :: IO ()       -- program entry point, carries world state
x = 42              -- value binding as Subject
\ n -> n + 1        -- lambda creates function Subject
action >>= f        -- monadic bind threads state
```
