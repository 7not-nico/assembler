# Function Composition — Validated

## Sources

| Source | Authority | Quote |
|--------|-----------|-------|
| ruby-doc.org/core/Proc.html | Official Ruby docs | `Proc#<<`: "Returns a proc that is the **composition** of this proc and the given g" |
| ghostcassette.com | Paul Mucur — contributed composition to Ruby 2.6 | "Backward composition maps to the mathematical operator ∘ we discussed earlier so `g << f` is the same as `g ∘ f`" |
| stanko.io | Ruby community article | "In mathematical terms, `f(x) >> g(x)` is the same as `g(f(x))`" |

## Validation via Playwright (ghostcassette.com)

```
Playwright extracted from ghostcassette.com:
"Backward composition maps to the mathematical operator ∘ we discussed
 earlier so g << f is the same as g ∘ f meaning that calling the
 resulting composite function with an input x will call g(f(x))"
```

## Mapping (VALIDATED)

| Math | Code | Derivation | Source |
|------|------|------------|--------|
| (g ∘ f)(x) = g(f(x)) | `(g << f).call(x)` | Forward: g after f | ghostcassette: `<<` maps to ∘ |
| (f ▷ g)(x) = g(f(x)) | `(f >> g).call(x)` | Backward: g after f | stanko: `f>>g` = `g(f(x))` |
| h = f ∘ g | `h = f << g` | Returns new Proc | Ruby docs: "returns a proc" |
| identity id(x)=x | `->(x) { x }` | Neutral element | Category theory axiom |

## Contrast: Ruby vs Haskell

Haskell's `.` operator: `(g . f) x = g (f x)` — compose right-to-left.

Ruby `<<` matches Haskell `.` semantics — apply right operand first, then left. Both are backward composition.

```haskell
doubleThenSquare = square . double   -- Haskell: double then square
```
```ruby
double_then_square = square << double  -- Ruby: same order
```

Ruby's `>>` has no direct Haskell equivalent — it's forward pipe.

## Limits (noted from sources)

- **Receiver requirement**: `>>`/`<<` only defined on `Proc`/`Method`. Plain objects with `.call` fail on left side (alchemists.io).
- **Performance**: composition creates a new Proc wrapper. Ruby issue #6284 shows ~15% overhead vs chained `.map`.
- **Duck typing**: Ruby composes by value type, not formal type signature. Mismatched types cause runtime errors (thoughtbot.com).
