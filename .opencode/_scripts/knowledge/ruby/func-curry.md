# Ruby Currying

`Proc#curry` transforms a multi-argument proc into a chain of single-argument procs (partial application). Ruby 1.9+.

```ruby
add = ->(x, y) { x + y }
add_5 = add.curry[5]
add_5.call(10)  # 15
```

## With variable arity

Optional arity argument for procs with splats:

```ruby
b = proc {|x, y, z| (x||0) + (y||0) + (z||0) }
b.curry[1][2][3]       # 6
b.curry[1, 2][3, 4]   # 6  (4th arg unused)
b.curry(5)[1][2][3][4][5]  # 6 (pad to 5 args)
```

## Practical: filter factories

```ruby
divisible_by = ->(x, y) { y % x == 0 }.curry
(1..10).select(&divisible_by.(5))  # [5, 10]
(1..10).select(&divisible_by.(2))  # [2, 4, 6, 8, 10]
```
