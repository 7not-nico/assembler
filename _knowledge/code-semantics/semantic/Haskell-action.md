---
id:               HASKELL.ACTION
language:         Haskell
role:             action
title:            The function application and pattern match
definition:       "Function application is written e1 e2. Application associates to the left. An operator is a function that can be applied using infix syntax, or partially applied using a section"
sources:
  - section:      Haskell 2010 §3 Expressions
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch3.html
  - section:      Haskell 2010 §6 Predefined Types and Classes
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch6.html
  - section:      Haskell 2010 §1 Introduction
    url:          https://www.haskell.org/onlinereport/haskell2010/haskellch1.html
canonical:        f x
tags:             [application, pattern-matching, lambda, do-notation, infix]
status:           draft
precedes:         []
---

## Action

The function application and pattern match. In Haskell, the primary action is function application — juxtaposing a function with its argument. Pattern matching selects among alternatives. Do-notation sequences monadic actions.

### Function application (§3)

> Function application is written e1 e2. Application associates to the left, so the parentheses may be omitted in (f x) y.

```
fexp → [fexp] aexp    (function application)
```

Application is left-associative. `f x y` means `(f x) y` — apply `f` to `x`, then apply the result to `y`:

```haskell
f x y z           -- parsed as ((f x) y) z
map f xs          -- apply map to f, then result to xs
```

> An operator is a function that can be applied using infix syntax (Section 3.4), or partially applied using a section (Section 3.5).

```haskell
x + y             -- infix operator application
(+) x y           -- prefix application (operator in parens)
x `f` y           -- function as infix (backtick notation)
(+1)              -- left section: partial application
(1+)              -- right section: partial application
```

### Lambda abstraction (§3)

> Lambda abstractions are written \ p1 ... pn -> e, where the pi are patterns.

```haskell
\x -> x + 1       -- lambda: function that adds 1
\ (x:xs) -> x     -- lambda with pattern matching
```

> The set of patterns must be linear — no variable may appear more than once in the set.

### Pattern matching

Pattern matching deconstructs algebraic data types — it is the primary control action:

```haskell
case expr of
    []     -> 0
    (x:xs) -> 1 + length xs

-- Pattern matching in function definitions:
length []     = 0
length (x:xs) = 1 + length xs
```

Pattern matching appears in:
- `case` expressions
- Function definitions (equational style)
- `let` and `where` bindings
- Lambda abstractions
- List comprehensions
- `do` notation bindings

### Strict and non-strict application (§6.2)

> Function application in Haskell is non-strict; that is, a function argument is evaluated only when required.

Haskell's default Action is lazy — arguments are evaluated only when demanded:

```haskell
f $ x             -- non-strict application (default semantics)
f $! x            -- strict application (force x before f)
```

> `$` has low, right-associative binding precedence, so it sometimes allows parentheses to be omitted.

```haskell
f $ g $ h x       -- = f (g (h x))
map ($ 0) xs      -- apply each function to 0
```

> `$!` is strict (call-by-value) application, defined in terms of seq.

```haskell
seq :: a -> b -> b
seq ⊥ b = ⊥
seq a b = b, if a ≠ ⊥
```

`seq` forces evaluation of its first argument, then returns the second. It is the only way to introduce strictness into a non-strict language.

### Monadic sequencing as action (§6)

Monadic actions are sequenced through bind and do-notation:

```haskell
do x <- action1
   y <- action2 x
   return (x + y)

-- desugars to:
action1 >>= \x ->
  action2 x >>= \y ->
    return (x + y)
```

The `>>=` (bind) operator threads the monadic state — it is the Action that connects Subject transformations.

### Bottom: the error action (§3)

> Errors during expression evaluation, denoted by ⊥ ("bottom"), are indistinguishable by a Haskell program from non-termination. Since Haskell is a non-strict language, all Haskell types include ⊥.

```haskell
error :: String -> a      -- raise an error
undefined :: a            -- undefined value (⊥)
```

`error` and `undefined` are the abort Actions — they terminate the program.

## Summary

```
f x               -- function application (left-associative)
x + y             -- infix operator application
\x -> e           -- lambda abstraction
case e of { p -> b }  -- pattern matching action
do { x <- a; b }  -- monadic sequencing
f $ x             -- non-strict application
f $! x            -- strict application
error "msg"       -- abort action (⊥)
```
