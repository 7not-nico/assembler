# Ruby Stabby Lambda — `->` syntax

## Definition

```ruby
name = ->(args) { body }
```

Used everywhere in `_rb/` modules. Only function definition form permitted per FP convention.

## Calling

```ruby
fn = ->(x) { x * 2 }
fn.call(3)      # 6
fn === 3        # 6 (case equality)
fn[3]           # 6
fn.(3)          # 6
```

Prefer `.call` for readability.

## Arity

```ruby
no_args = -> { 42 }
one_arg = ->(x) { x }
two_args = ->(a, b) { a + b }
optional = ->(a, b = 0) { a + b }
```

Lambdas enforce arity — wrong arg count raises `ArgumentError`.

## Default values

```ruby
NormalizeTags = ->(fm) {
  return fm unless fm
  fm[:tags] ||= []
  fm
}
```

Pattern: guard clause with early return via `return` (exits lambda, not enclosing method).

## Chaining composition

```ruby
double = ->(x) { x * 2 }
add_one = ->(x) { x + 1 }

double >> add_one   # left-to-right: double then add_one
double << add_one   # right-to-left: add_one then double
```

See `composition/flow-chaining-patterns.md`.
