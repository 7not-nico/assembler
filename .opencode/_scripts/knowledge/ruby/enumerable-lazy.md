# Ruby Enumerable — Lazy

## Enumerator::Lazy (Ruby 2.0+)

Chain operations without intermediate arrays:

```ruby
(1..Float::INFINITY).lazy
  .select(&:odd?)
  .map { |n| n * 2 }
  .first(5)                               # [2, 6, 10, 14, 18]
```

Without lazy, `(1..Float::INFINITY).select(...)` would hang.

## .lazy

Returns `Enumerator::Lazy` — most Enumerable methods available:

```ruby
[1, 2, 3].lazy.map { |n| n * 2 }.to_a    # [2, 4, 6]
```

## Force evaluation

```ruby
lazy_enum = (1..Float::INFINITY).lazy.select(&:odd?)
lazy_enum.first(3)                        # [1, 3, 5]
lazy_enum.take(3).to_a                    # [1, 3, 5]
lazy_enum.to_a                            # hangs — infinite
```

Lazy chain evaluated only when forced (`.first`, `.to_a`, `.each`).
