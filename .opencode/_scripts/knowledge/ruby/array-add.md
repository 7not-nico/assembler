# Ruby Array — Adding Elements

All methods mutate `self`.

```ruby
arr = [1, 2]
```

## To end

```ruby
arr.push(3)       # [1, 2, 3]
arr << 4          # [1, 2, 3, 4]
arr.append(5)     # [1, 2, 3, 4, 5]
```

## To beginning

```ruby
arr.unshift(0)    # [0, 1, 2, 3, 4, 5]
arr.prepend(-1)   # [-1, 0, 1, 2, 3, 4, 5]
```

## At position

```ruby
arr.insert(3, 'x')        # insert before index 3
arr.insert(3, 'a', 'b')   # insert multiple
```

## Combine

```ruby
arr.concat([6, 7])        # [-1, 0, 1, 2, 3, 4, 5, 6, 7]
arr + [8, 9]              # non-mutating concat (returns new)
```

## Fill

```ruby
arr.fill(0)               # fill all with 0
arr.fill(0, 2..4)         # fill range with 0
arr.fill { |i| i * 2 }    # fill with block
```
