# Ruby Lambda vs Non-lambda

Procs come in two flavors. The key differences:

| | Lambda | Non-lambda (`proc`/`Proc.new`) |
|--|--------|-------------------------------|
| `return` | exits the lambda | exits the embracing method |
| `break` | exits the lambda | exits the method that gave the block |
| wrong arg count | `ArgumentError` | extra discarded, missing=`nil` |
| single array arg | `ArgumentError` | deconstructed to params |

## Examples

```ruby
def test_return
  -> { return 3 }.call      # exits lambda, returns 3 into method
  proc { return 4 }.call    # exits test_return entirely
  return 5
end
test_return  # 4 (proc's return wins)

# non-lambda arg handling
p = proc {|x, y| [x, y] }
p.call(1, 2)       # [1, 2]
p.call([1, 2])     # [1, 2] — array deconstructed
p.call(1, 2, 8)    # [1, 2] — extra discarded
p.call(1)          # [1, nil]

# lambda arg handling  
l = lambda {|x, y| [x, y] }
l.call(1, 2)       # [1, 2]
l.call([1, 2])     # ArgumentError
l.call(1, 2, 8)    # ArgumentError
l.call(1)          # ArgumentError
```

## Predicate

```ruby
lambda {}.lambda?   # true
proc {}.lambda?     # false
Proc.new {}.lambda? # false
```
