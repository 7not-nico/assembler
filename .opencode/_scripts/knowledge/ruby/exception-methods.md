# Ruby Exception — Instance Methods (message, backtrace, cause, inspect)

## message / to_s

```ruby
e = RuntimeError.new("something broke")
e.message    # "something broke"
e.to_s       # "something broke"
e.inspect    # "#<RuntimeError: something broke>"
```

## backtrace

```ruby
begin
  raise "oops"
rescue => e
  e.backtrace        # Array of strings: ["file.rb:3:in ..."]
  e.full_message     # formatted string with trace
end
```

## backtrace_locations

```ruby
e.backtrace_locations  # Array of Thread::Backtrace::Location objects
                       # richer API than backtrace strings
```

## cause — chained exception

```ruby
begin
  raise "inner"
rescue => inner
  raise RuntimeError, "outer", cause: inner
end

# Later:
$!.cause   # inner exception
$!.cause.cause  # nil if no further chain
```

## == — equality

```ruby
RuntimeError.new("x") == RuntimeError.new("x")  # true — same class + message
```
