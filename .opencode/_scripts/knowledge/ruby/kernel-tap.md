# Ruby Kernel — tap, then, itself for functional piping

## tap

Yields the object to the block, returns the object. Used for side effects in chains.

```ruby
[1, 2, 3].map { |n| n * 2 }
         .tap { |arr| logger.debug("mapped: #{arr}") }
         .select(&:even?)
# => [2, 4, 6]
```

Useful for debugging or logging in the middle of a chain without breaking it.

## then / yield_self

Yields the object to the block, returns the block result. Used for transformation.

```ruby
"hello".then { |s| s.upcase + "!" }  # "HELLO!"
```

```ruby
3.then { |n| n * 10 }
 .then { |n| n.to_s }
 .then { |s| s + "x" }
# => "30x"
```

`then` and `yield_self` are aliases.

## itself

Returns the object itself. Useful as a default block.

```ruby
[1, 2, 3, 1, 2].uniq(&:itself)  # [1, 2, 3]
```

```ruby
grouped = [1, 2, 3, 4].group_by { |n| n.even? }
# => {false=>[1, 3], true=>[2, 4]}
grouped.default_proc = proc { |h, k| h[k] = [] }
```

## Comparison

| Method | Returns | Use case |
|--------|---------|----------|
| `tap` | The receiver | Side effects, debugging |
| `then` | Block result | Transformation pipeline |
| `itself` | The receiver | Identity function |
