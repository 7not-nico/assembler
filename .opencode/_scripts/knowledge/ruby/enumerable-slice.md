# Ruby Enumerable — Slicing (each_slice, each_cons)

## each_slice

Iterate in fixed-size groups:

```ruby
(1..6).each_slice(3).to_a          # [[1, 2, 3], [4, 5, 6]]
(1..5).each_slice(2).to_a          # [[1, 2], [3, 4], [5]]
```

## each_cons

Consecutive sliding window:

```ruby
(1..5).each_cons(3).to_a           # [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
(1..4).each_cons(2).to_a           # [[1, 2], [2, 3], [3, 4]]
```

Both return Enumerator when no block:

```ruby
(1..10).each_slice(3)   # #<Enumerator>
(1..10).each_cons(3)    # #<Enumerator>
```
