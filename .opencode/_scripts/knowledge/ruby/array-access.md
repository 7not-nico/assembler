# Ruby Array Access

Non-mutating methods for fetching elements.

## By index

```ruby
arr = [10, 20, 30, 40, 50]
arr[0]        # 10       — index
arr[-1]       # 50       — negative index
arr[0, 3]     # [10,20,30]  — start, length
arr[0..2]     # [10,20,30]  — range
arr.at(0)     # 10       — alias for []
arr.slice(0)  # 10       — alias for []
arr.fetch(0)  # 10       — raises IndexError if out of bounds
arr.fetch(99, "x")  # "x"  — default value
arr.values_at(0, 2) # [10, 30]
```

## First/last/take/drop

```ruby
arr.first      # 10
arr.first(3)   # [10, 20, 30]
arr.last       # 50
arr.last(2)    # [40, 50]
arr.take(2)    # [10, 20]   — first n
arr.drop(2)    # [30, 40, 50]  — after first n
```

## Association

```ruby
a = [[:a, 1], [:b, 2]]
a.assoc(:a)   # [:a, 1]   — first element with matching key
a.rassoc(2)   # [:b, 2]   — first element with matching value
```

## Binary search

```ruby
[1, 3, 5, 7].bsearch { |x| x > 4 }       # 5
[1, 3, 5, 7].bsearch_index { |x| x > 4 } # 2
```

## Min/max

```ruby
[3, 1, 4, 1, 5].min        # 1
[3, 1, 4, 1, 5].max        # 5
[3, 1, 4, 1, 5].minmax     # [1, 5]
[3, 1, 4, 1, 5].min(3)     # [1, 1, 3]
```

## Index lookup

```ruby
arr = [10, 20, 30, 20]
arr.index(20)    # 1   — first index
arr.rindex(20)   # 3   — last index
arr.find_index { |x| x > 25 }  # 2
```

## Random

```ruby
[1, 2, 3].sample      # random element
[1, 2, 3].sample(2)   # random subset
```
