# Ruby Array — Transforming

Non-mutating (return new array) unless `!` suffix.

## Map / select / reject

```ruby
[1, 2, 3].map { |x| x * 2 }        # [2, 4, 6]
[1, 2, 3].collect { |x| x * 2 }    # alias for map
[1, 2, 3].map! { |x| x * 2 }       # mutates

[1, 2, 3, 4].select { |x| x > 2 }   # [3, 4]
[1, 2, 3, 4].filter { |x| x > 2 }   # alias for select
[1, 2, 3, 4].reject { |x| x > 2 }   # [1, 2]
```

## Order

```ruby
[3, 1, 4, 1, 5].sort           # [1, 1, 3, 4, 5]
[3, 1, 4].sort.reverse         # [4, 3, 1]
[3, 1, 4].sort { |a,b| b <=> a }  # [4, 3, 1]  desc
[1, 2, 3].reverse              # [3, 2, 1]
[1, 2, 3, 4].rotate            # [2, 3, 4, 1]
[1, 2, 3, 4].rotate(2)         # [3, 4, 1, 2]
[1, 2, 3].shuffle              # random order
```

## Structure

```ruby
[1, [2, [3]]].flatten         # [1, 2, 3]
[1, [2, [3]]].flatten(1)      # [1, 2, [3]]  — depth limit
[1, 1, 2, 2].uniq             # [1, 2]
[1, nil, 2].compact           # [1, 2]
[1, 2, 3, 4].chunk { |x| x.even? }  # enumerator of [bool, [items]]
[1, 1, 2, 2, 3].slice_when { |a,b| a != b }  # [[1,1],[2,2],[3]]
```

## Iteration

```ruby
[1, 2, 3].each { |x| puts x }
[1, 2, 3].reverse_each { |x| puts x }
[1, 2, 3].each_with_index { |x, i| puts "#{i}: #{x}" }
```
