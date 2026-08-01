# Ruby Array — Removing Elements

## From ends

```ruby
arr = [1, 2, 3, 4, 5]
arr.pop          # 5    — removes last, returns it
arr.pop(2)       # [3, 4]  — removes last 2
arr.shift        # 1    — removes first, returns it
arr.shift(2)     # [2]  — removes first 2
```

## By value or index

```ruby
arr = [1, 2, 2, 3]
arr.delete(2)    # 2    — removes ALL 2s, returns matched
arr.delete(99)   # nil  — not found
arr.delete_at(0) # 1    — removes at index

arr = [1, 2, 3, 4, 5]
arr.slice!(1)    # 2    — removes at index, returns it
arr              # [1, 3, 4, 5]
```

## Conditional

```ruby
arr = [1, 2, 3, 4, 5, 6]
arr.delete_if { |x| x > 4 }     # [1, 2, 3, 4]
arr.keep_if { |x| x.even? }     # [2, 4]
arr.reject! { |x| x < 4 }       # [4]
arr.select! { |x| x >= 4 }      # same
```

## Cleanup

```ruby
[1, nil, 2, nil].compact   # [1, 2]        — new, no nils
[1, nil, 2].compact!       # [1, 2]        — mutates
[1, 2, 1, 3].uniq          # [1, 2, 3]     — new, no dupes
[1, 2, 1, 3].uniq!         # [1, 2, 3]     — mutates
arr.clear                  # []            — removes all
```
