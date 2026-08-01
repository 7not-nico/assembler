# Ruby Integer — Iteration

## times

Calls block `self` times with values `0` through `self-1`:

```ruby
5.times { |i| print i }  # 01234
5.times { "hello" }      # 5 iterations
```

## upto / downto

```ruby
3.upto(6) { |i| print i }      # 3456
6.downto(3) { |i| print i }    # 6543
```

Returns an Enumerator when no block:

```ruby
3.upto(6).to_a    # [3, 4, 5, 6]
6.downto(3).to_a  # [6, 5, 4, 3]
```

## succ / pred

```ruby
42.succ   # 43
42.next   # 43  — alias
42.pred   # 41
```
