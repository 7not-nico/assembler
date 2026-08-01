# Ruby Hash — Iterating

```ruby
h = {a: 1, b: 2, c: 3}
```

## Keys, values, or both

```ruby
h.each { |k, v| puts "#{k}: #{v}" }       # key-value (alias: each_pair)
h.each_pair { |k, v| ... }                 # same
h.each_key { |k| puts k }                  # [:a, :b, :c]
h.each_value { |v| puts v }                # [1, 2, 3]
```

## Order

Insertion order is preserved. New entries are added at the end. Re-creating a deleted entry moves it to the end.

```ruby
h = {a: 1, b: 2}
h[:c] = 3          # {a: 1, b: 2, c: 3}
h.delete(:a)       # {b: 2, c: 3}
h[:a] = 1          # {b: 2, c: 3, a: 1}  — re-added at end
```
