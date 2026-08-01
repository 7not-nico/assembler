# Ruby Binding — scope introspection and evaluation

## Obtaining

```ruby
def get_binding
  x = 10
  y = 20
  binding
end
b = get_binding
```

## Querying

```ruby
b.local_variables          # [:x, :y]
b.local_variable_defined?(:x)  # true
b.local_variable_get(:x)       # 10
```

## Modifying

```ruby
b.local_variable_set(:x, 99)
b.local_variable_get(:x)  # 99
```

## Evaluation in context

```ruby
b.eval("x + y")  # 119
```

## Source location

```ruby
b.source_location  # ["file.rb", 4]
```

## Common pattern: capturing scope for later

```ruby
def capture
  val = 42
  binding
end

b = capture
b.eval("val")  # 42
```

Note: `binding` is a `Kernel` method, not a constructor. It captures the current execution context.
