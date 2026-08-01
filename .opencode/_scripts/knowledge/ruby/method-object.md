# Ruby Method Object — higher-order functions from methods

## Obtaining

```ruby
def double(x) = x * 2
m = method(:double)
m.class  # => Method
```

## Calling

```ruby
m.call(5)   # 10
m[5]        # 10
m === 5     # 10
m.(5)       # 10
```

## Introspection

```ruby
m.arity            # 1
m.parameters       # [[:req, :x]]
m.source_location  # ["/path/file.rb", 1]
m.name             # :double
m.original_name    # :double
m.owner            # Object
m.receiver         # main
```

## to_proc

```ruby
method(:double).to_proc.call(5)  # 10
[1, 2, 3].map(&method(:double))  # [2, 4, 6]
```

Useful for referencing private methods in functional chains without wrapping in a lambda.

## UnboundMethod

```ruby
um = instance_method(:double)
um.bind(self).call(5)  # 10
```

## Method vs lambda

| | Method | Lambda |
|--|--------|--------|
| Arity | Strict | Strict |
| `return` | Exits method | Exits lambda |
| `.lambda?` | `true` | `true` |
