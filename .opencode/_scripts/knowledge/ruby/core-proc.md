# Ruby Proc

`Proc` encapsulates a block of code. *"A core of Ruby's functional programming features."*

## Creation

| Form | Semantics | Example |
|------|-----------|---------|
| `Proc.new` | non-lambda | `Proc.new { \|x\| x**2 }` |
| `proc` | non-lambda | `proc { \|x\| x**2 }` |
| `lambda` | lambda | `lambda { \|x\| x**2 }` |
| `->` | lambda | `->(x) { x**2 }` |
| `&block` param | caller-dependent | `def m(&block); block; end` |

## Invocation

```ruby
p = proc { |x| x**2 }
p.call(3)    # 9
p[3]         # 9
p.(3)        # 9
p.yield(3)   # 9
```

## Key Methods

| Method | Returns |
|--------|---------|
| `call`, `[]`, `.()`, `yield` | proc result |
| `arity` | required arg count (negative=optional) |
| `parameters(lambda:)` | `[[:req,:x], [:opt,:y]]` |
| `lambda?` | true if lambda, false if non-lambda |
| `binding` | the closure's Binding |
| `source_location` | `[file, line]` or nil |
| `==` / `eql?` | true only if same code block |
| `ruby2_keywords` | legacy keyword forwarding |
| `to_s` / `inspect` | unique id + source location |
