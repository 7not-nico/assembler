# Ruby Enumerable — Zip

## zip — combine elements positionally

```ruby
[1, 2, 3].zip([:a, :b, :c])            # [[1, :a], [2, :b], [3, :c]]
[1, 2].zip([:a, :b, :c], [:x, :y])     # [[1, :a, :x], [2, :b, :y]]
```

Shorter arrays get `nil` padding:

```ruby
[1, 2, 3].zip([:a])                     # [[1, :a], [2, nil], [3, nil]]
```

With block — returns nil, yields each tuple:

```ruby
result = []
[1, 2, 3].zip([:a, :b, :c]) { |pair| result << pair }
result  # [[1, :a], [2, :b], [3, :c]]
```
