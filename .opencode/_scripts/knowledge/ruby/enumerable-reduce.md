# Ruby Enumerable — Reducing (reduce / inject)

## reduce / inject

Accumulate with initial value:

```ruby
[1, 2, 3].reduce(0) { |sum, n| sum + n }    # 6
[1, 2, 3].reduce(:+)                         # 6 — symbol shorthand
```

Without initial — first element used as seed:

```ruby
[1, 2, 3].reduce { |sum, n| sum + n }        # 6
[].reduce(0) { |s, n| s + n }                # 0
```

## Common reduce patterns

```ruby
# Sum
[1, 2, 3].sum                                # 6 — built-in (faster)

# Max
[3, 1, 4, 2].reduce { |a, b| a > b ? a : b } # 4
[3, 1, 4, 2].max                             # 4 — built-in

# Hash accumulator
%w[cat dog].reduce({}) { |h, w| h.merge(w => w.length) }  # {"cat"=>3, "dog"=>3}
```

## each_with_object — inject without return value

```ruby
%w[cat dog].each_with_object({}) { |w, h| h[w] = w.length }  # {"cat"=>3, "dog"=>3}
# vs reduce — each_with_object ignores block result
```
