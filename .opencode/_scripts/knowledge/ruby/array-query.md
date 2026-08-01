# Ruby Array — Querying

## Size

```ruby
[1, 2, 3].length    # 3
[1, 2, 3].size      # 3
[1, 2, 3].count     # 3
[1, 2, 3].count(2)  # 1  — count occurrences
[1, 2, 3].count { |x| x > 1 }  # 2
[].empty?           # true
```

## Membership

```ruby
[1, 2, 3].include?(2)     # true
[1, 2, 3].include?(4)     # false
```

## Predicates

```ruby
[1, 2, 3].all? { |x| x > 0 }   # true
[1, 2, 3].any? { |x| x > 2 }   # true
[1, 2, 3].none? { |x| x > 5 }  # true
[1, 2, 3].one? { |x| x == 2 }  # true
```

## Equality

```ruby
[1, 2] == [1, 2]     # true
[1, 2] === [1, 2]    # true
[1, 2].eql?([1, 2])  # true
[1, 2] <=> [1, 3]    # -1  (spaceship)
[1, 2] <=> [1, 2]    # 0
[1, 2] <=> [1, 1]    # 1
```
