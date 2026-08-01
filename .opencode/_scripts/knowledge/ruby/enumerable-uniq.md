# Ruby Enumerable — Uniq

## uniq

```ruby
[1, 1, 2, 3, 3].uniq                   # [1, 2, 3]
[{ a: 1 }, { a: 1 }, { a: 2 }].uniq { |h| h[:a] }  # [{ a: 1 }, { a: 2 }]
```

Returns elements by first occurrence. With block, uses block result as uniqueness key.
