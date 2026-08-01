---
id:               HASKELL.OBJECT
language:         Haskell
role:             object
title:            The type and type class
definition:       "Haskell provides static polymorphic typing. An expression denotes a value and has a static type. The Haskell Prelude contains predefined classes, types, and functions that are implicitly imported into every Haskell program"
sources:
  - section:      Haskell 2010 §1 Introduction
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch1.html
  - section:      Haskell 2010 §6 Predefined Types and Classes
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch6.html
  - section:      Haskell 2010 §3 Expressions
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch3.html
canonical:        "42 :: Int"
tags:             [type, type-class, polymorphic, kind, algebraic]
status:           draft
precedes:         []
---

## Object

The type and type class. In Haskell, every expression has a static type that classifies its value. Types are the Object — they determine what values are valid and what operations are available.

### Static polymorphic typing (§1)

> Haskell provides higher-order functions, non-strict semantics, static polymorphic typing, user-defined algebraic datatypes.

> An expression denotes a value and has a static type.

Every value in Haskell belongs to a type. The type is determined at compile time and checked statically:

```haskell
42        :: Num a => a        -- polymorphic numeric literal
True      :: Bool              -- boolean
"hello"   :: String            -- string (= [Char])
\x -> x   :: a -> a            -- polymorphic identity function
```

### Standard types (§6.1)

The Prelude defines these built-in types:

```haskell
data Bool    = False | True                    -- boolean
data Char    = ...                             -- Unicode character
data [a]     = [] | a : [a]                    -- list (special syntax)
data Maybe a = Nothing | Just a                -- optional value
data Either a b = Left a | Right b             -- choice
data Ordering = LT | EQ | GT                   -- comparison result
data ()      = ()                              -- unit (trivial type)
```

> Lists are an algebraic datatype of two constructors: `[]` ("nil") and `:` ("cons"). Lists are an instance of classes Read, Show, Eq, Ord, Monad, Functor, and MonadPlus.

Numeric types:

```haskell
Int         -- fixed-precision integer
Integer     -- arbitrary-precision integer
Float       -- single-precision floating point
Double      -- double-precision floating point
```

### IO as abstract type (§6.1.7)

> The IO type serves as a tag for operations (actions) that interact with the outside world. The IO type is abstract: no constructors are visible to the user.

`IO a` is the type of an action that, when performed, may interact with the outside world and produce a value of type `a`. It is abstract — the implementation is hidden.

### Type class hierarchy (§6.3)

Type classes provide constrained polymorphism. The standard hierarchy:

```
Eq          -- equality: (==), (/=)
  Ord       -- ordering: compare, (<), (<=), (>), (>=)
  Num       -- numeric operations: (+), (-), (*), fromInteger
    Real    -- real numbers: toRational
    Fractional -- fractional division: (/), fromRational
      Floating -- trigonometric: sin, cos, exp, log
Show        -- string conversion: show, showsPrec
Read        -- string parsing: readsPrec, readList
Enum        -- enumerable: succ, pred, toEnum, fromEnum
Bounded     -- min and max bounds: minBound, maxBound
Functor     -- map over structure: fmap
Monad       -- sequencing: (>>=), (>>), return, fail
MonadPlus   -- monoid over monads: mzero, mplus
```

> The Eq class provides equality (==) and inequality (/=) methods. All basic datatypes except for functions and IO are instances of this class.

### Function types (§6.1.6)

> Functions are an abstract type: no constructors directly create functional values.

```haskell
id      :: a -> a            -- identity function
const   :: a -> b -> a       -- constant function
(.)     :: (b -> c) -> (a -> b) -> a -> c  -- composition
($)     :: (a -> b) -> a -> b              -- application
```

A function type `a -> b` is the Object for function values. Functions are abstract — they have no data constructors, only application.

## Summary

```
42        :: Num a => a       -- polymorphic numeric Object
True      :: Bool             -- boolean Object
"hello"   :: String           -- string Object
\x -> x   :: a -> a           -- function type Object
Just 42   :: Num a => Maybe a -- algebraic type Object
main      :: IO ()            -- IO action Object
```
