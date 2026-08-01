# Ruby Enumerable — Querying (all?, any?, none?, one?, include?, count, find, find_all)

## all?

```ruby
[1, 2, 3].all? { |n| n > 0 }      # true
[1, 0, 3].all?(&:positive?)       # false
[1, 2, 3].all?                     # true — none falsey
[nil, 2].all?                      # false
```

With argument (pattern match `===`):

```ruby
%w[foo bar baz].all?(/o/)          # false — "bar" doesn't match
[1, 2.5, 3].all?(Numeric)         # true
```

## any?

```ruby
[1, 0, 3].any?(&:zero?)           # true
[nil, false].any?                  # false
%w[cat dog].any?(/dog/)           # true
```

## none? / one?

```ruby
[1, 2, 3].none?(&:zero?)          # true
[nil, false].none?                 # true  — none truthy
[1, 2, 3].one?(&:even?)           # false — 2 is even but also... wait, just 2
[1, 3, 5].one?(&:even?)           # false — none even
[2, 4].one?(&:even?)              # false — two evens
[2].one?(&:even?)                 # true
```

## include? / member?

```ruby
[1, 2, 3].include?(2)             # true
{ a: 1, b: 2 }.include?(:a)       # true — key check
{ a: 1, b: 2 }.include?(:c)       # false
```

## count

```ruby
[1, 2, 3, 2].count                # 4
[1, 2, 3, 2].count(2)             # 2 — count occurrences
[1, 2, 3, 4].count(&:even?)       # 2
```

## find / detect

```ruby
[1, 2, 3].find(&:even?)           # 2
[1, 3, 5].find(&:even?)           # nil
[1, 3, 5].find(-> { :default }) { |n| n.even? }  # :default — ifnone proc
```

## find_all — alias for select

```ruby
[1, 2, 3, 4].find_all(&:even?)    # [2, 4]
```
