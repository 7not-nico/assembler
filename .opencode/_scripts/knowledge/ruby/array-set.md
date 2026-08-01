# Ruby Array — Set Operations

Array supports set-like operations without requiring the `Set` class.

## Union / Intersection / Difference

```ruby
a = [1, 2, 3]
b = [3, 4, 5]

a | b                # [1, 2, 3, 4, 5]  — union (no dupes)
a & b                # [3]                — intersection
a - b                # [1, 2]             — difference
a + b                # [1, 2, 3, 3, 4, 5] — concat (has dupes)
```

## Unique

```ruby
[1, 1, 2, 2, 3].uniq           # [1, 2, 3]
[1, 1, 2, 2, 3].uniq { |x| x.even? }  # [1, 2]  — uniq by block
```

## Common elements

```ruby
([1, 2, 3] & [2, 3, 4])        # [2, 3]
([1, 2, 3] - [2])              # [1, 3]
```
