# Ruby Closures

Proc captures the surrounding scope — variables, methods, everything — and retains access even when passed elsewhere.

```ruby
def gen_times(factor)
  proc { |n| n * factor }  # factor captured
end
times3 = gen_times(3)
times3.call(12)  # 36

times5 = gen_times(5)
times5.call(12)  # 60
```

## Shared variable binding

Multiple closures can share the same captured variable:

```ruby
count = 0
inc = -> { count += 1 }
dec = -> { count -= 1 }

inc.call  # 1
inc.call  # 2
dec.call  # 1
```

## Closure captures variable, not value

```ruby
x = 10
snapshot = -> { puts x }
x = 20
snapshot.call  # 20, not 10
```

## Orphaned Proc

If a proc outlives the method that created it, `return` and `break` raise `LocalJumpError`. Lambdas can't be orphaned — their return/break exits the lambda itself.
