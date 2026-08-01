# Ruby Exception — Raise

## raise / fail

```ruby
raise "message"                        # RuntimeError with message
raise ArgumentError, "bad arg"         # specific type
raise ArgumentError.new("bad")         # explicit new
raise                                  # re-raise current exception
fail "message"                         # alias for raise
```

## raise with cause (Ruby 2.1+)

```ruby
begin
  raise "inner"
rescue => e
  raise RuntimeError, "outer", cause: e  # chained exception
end
```

## Raise without arguments

```ruby
begin
  raise "original"
rescue
  raise  # re-raises the same exception with same backtrace
end
```
