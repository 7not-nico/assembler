# Ruby Enumerable — Filtering (select, reject, grep, partition)

## select / filter

```ruby
[1, 2, 3, 4].select(&:even?)      # [2, 4]
{ a: 1, b: 2, c: 3 }.select { |_, v| v > 1 }  # { b: 2, c: 3 }
```

## reject

```ruby
[1, 2, 3, 4].reject(&:even?)      # [1, 3]
{ a: 1, b: 2 }.reject { |_, v| v == 1 }  # { b: 2 }
```

## grep — pattern match via `===`

```ruby
%w[cat dog cow bird].grep(/c/)      # ["cat", "cow"]
[1, 2.5, "x"].grep(Numeric)        # [1, 2.5]
(1..10).grep(5..7)                  # [5, 6, 7]
```

## grep_v — inverse grep

```ruby
%w[cat dog cow].grep_v(/c/)         # ["dog"]
```

## partition — split into two arrays

```ruby
[1, 2, 3, 4].partition(&:even?)    # [[2, 4], [1, 3]]
```
