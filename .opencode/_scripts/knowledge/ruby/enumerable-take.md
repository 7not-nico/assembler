# Ruby Enumerable — Taking / Dropping (first, take, drop)

## first

```ruby
(1..100).first(3)                   # [1, 2, 3]
(1..100).first                      # 1
[].first                            # nil
```

## take

```ruby
[5, 2, 8, 1].take(2)               # [5, 2]
[].take(0)                          # []
```

## drop

```ruby
[5, 2, 8, 1].drop(2)               # [8, 1]
[5, 2, 8, 1].drop(0)               # [5, 2, 8, 1]
```
