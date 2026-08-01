# Ruby Hash — Accessing Values

## Basic

```ruby
h = {a: 1, b: 2, c: 3}
h[:a]       # 1           — returns default if missing
h[:x]       # nil         — default is nil unless set
```

## fetch

```ruby
h.fetch(:a)           # 1
h.fetch(:x)           # KeyError
h.fetch(:x, 0)        # 0  — default value
h.fetch(:x) { |k| "missing #{k}" }  # "missing x"
```

## Multiple values

```ruby
h.values_at(:a, :c)       # [1, 3]
h.fetch_values(:a, :c)    # [1, 3]
h.fetch_values(:a, :x)    # KeyError
```

## Keys and values

```ruby
h.keys        # [:a, :b, :c]
h.values      # [1, 2, 3]
h.key(2)      # :b  — first key with given value
```

## Associations

```ruby
h.assoc(:a)   # [:a, 1]     — [key, value] pair
h.rassoc(2)   # [:b, 2]     — first pair with matching value
```

## dig

Nested access:

```ruby
h = {a: {b: {c: 3}}}
h.dig(:a, :b, :c)     # 3
h.dig(:a, :x)         # nil  — no error
```
