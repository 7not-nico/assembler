# Ruby Enumerable — Indexed Iteration (each_with_index, map.with_index, reverse_each, cycle)

## each_with_index

```ruby
%w[a b c].each_with_index.map { |e, i| "#{i}:#{e}" }  # ["0:a", "1:b", "2:c"]
```

## map.with_index

```ruby
%w[a b c].map.with_index(1) { |e, i| "#{i}:#{e}" }    # ["1:a", "2:b", "3:c"]
%w[x y z].map.with_index { |e, i| [i, e] }             # [[0, "x"], [1, "y"], [2, "z"]]
```

## select.with_index / reject.with_index

```ruby
%w[a b c d].select.with_index { |_, i| i.even? }  # ["a", "c"]
```

## reverse_each

```ruby
[1, 2, 3].reverse_each.to_a               # [3, 2, 1]
```

## cycle

```ruby
[1, 2, 3].cycle(2).to_a                   # [1, 2, 3, 1, 2, 3]
[1, 2, 3].cycle.first(5)                  # [1, 2, 3, 1, 2]
```
