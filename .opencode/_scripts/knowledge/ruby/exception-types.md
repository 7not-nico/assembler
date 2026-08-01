# Ruby Exception — StandardError subclasses

## Common subtypes

| Exception | Typical cause |
|-----------|---------------|
| `ArgumentError` | Wrong number/type of arguments |
| `TypeError` | Object not of expected type |
| `RuntimeError` | Default for `raise` with no class |
| `NameError` / `NoMethodError` | Undefined method/variable |
| `IndexError` / `KeyError` | Out-of-bounds index or missing hash key |
| `IOError` / `EOFError` | File/IO read failure or end reached |
| `ZeroDivisionError` | Division by zero |
| `SystemCallError` / `Errno::*` | OS-level errors (file not found, permission) |
| `RegexpError` | Invalid regexp pattern |
| `StopIteration` | End of iteration (used by `Kernel#loop`) |

## Rescue hierarchy

```ruby
begin
  # code
rescue SystemCallError    # catch OS errors first
rescue StandardError      # catch all others
end
```

## Custom exceptions

```ruby
class MyError < StandardError; end

raise MyError, "custom message"
```
