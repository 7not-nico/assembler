# Ruby Hash — Transforming

Non-mutating unless `!` suffix.

## Transform keys / values

```ruby
h = {a: 1, b: 2}
h.transform_keys { |k| k.to_s }      # {"a"=>1, "b"=>2}
h.transform_keys! { |k| k.upcase }  # mutates
h.transform_values { |v| v * 2 }     # {a: 2, b: 4}
h.transform_values! { |v| v * 2 }   # mutates
```

## Select / Reject

```ruby
h = {a: 1, b: 2, c: 3}
h.select { |k, v| v > 1 }     # {b: 2, c: 3}
h.filter { |k, v| v > 1 }     # alias
h.reject { |k, v| v > 1 }     # {a: 1}
```

## Slice / Except

```ruby
h = {a: 1, b: 2, c: 3}
h.slice(:a, :c)              # {a: 1, c: 3}
h.except(:a)                 # {b: 2, c: 3}
```

## Compact

```ruby
{a: 1, b: nil}.compact       # {a: 1}
```

## Invert / Flatten

```ruby
{a: 1, b: 2}.invert          # {1=>:a, 2=>:b}  — values become keys
{a: 1, b: 2}.flatten         # [:a, 1, :b, 2]
{a: 1, b: 2}.flatten(1)      # [:a, 1, :b, 2]
```

## Subset / Superset

```ruby
{a: 1} < {a: 1, b: 2}       # true — proper subset
{a: 1} <= {a: 1, b: 2}      # true — subset
{a: 1, b: 2} > {a: 1}       # true — proper superset
{a: 1, b: 2} >= {a: 1}      # true — superset
```
