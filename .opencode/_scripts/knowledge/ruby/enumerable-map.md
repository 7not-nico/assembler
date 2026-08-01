# Ruby Enumerable — Mapping (map, flat_map, filter_map)

## map / collect

```ruby
[1, 2, 3].map { |n| n * 2 }        # [2, 4, 6]
%w[a b c].map(&:upcase)            # ["A", "B", "C"]
{ a: 1, b: 2 }.map { |k, v| [k, v * 2] }  # [[:a, 2], [:b, 4]]
```

## flat_map / collect_concat

Flattens one level after mapping:

```ruby
[1, 2, 3].flat_map { |n| [n, -n] }  # [1, -1, 2, -2, 3, -3]
%w[cat dog].flat_map(&:chars)        # ["c", "a", "t", "d", "o", "g"]
```

## filter_map (Ruby 2.7+)

Map + compact in one pass:

```ruby
[1, 2, 3, 4].filter_map { |n| n * 2 if n.even? }  # [4, 8]
```
