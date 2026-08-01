# Chaining Patterns — Lambda Composition

## Native composition (Ruby 2.6+)

`>>` pipes left-to-right (apply f, then g). `<<` composes right-to-left (apply g, then f).

```ruby
double = ->(x) { x * 2 }
add_one = ->(x) { x + 1 }

(double >> add_one).call(5)  # => 11 — (5*2)+1
(double << add_one).call(5)  # => 12 — (5+1)*2
```

Works on any Proc — including all `_rb/` module exports.

## Dynamic pipeline from a list

```ruby
steps = [->(x) { x * 2 }, ->(x) { x + 3 }, ->(x) { x.to_s }]
pipeline = steps.reduce(->(x) { x }, &:>>)
pipeline.call(5)  # => "13"
```

## Manual chain (used in scripts/)

Explicit intermediate values — each step visible, no hidden composition:

```ruby
texts = files.map { |f| f[:path].read }
entries = ParseAll.call(texts, files.map { |f| f[:name] })
by_id = entries.group_by { |e| e[:id] }
dupes = by_id.select { |_, g| g.size > 1 }
```

## When to use each

| Pattern | Use case |
|---------|----------|
| `>>` / `<<` | Ad-hoc composition of 2–3 known lambdas |
| Manual chain | Sequential steps in a script body |
| `reduce(:>>)` | Dynamic pipeline from a list of steps |

## Precedence (Ruby 3.4)

`<<` and `>>` share precedence level 6 — above `&`, below `+`, `-`. Linear chains are safe without parentheses:

```ruby
double >> add_one >> square
# parsed as: (double >> add_one) >> square  — left-associative
```

But mixing with other operators requires parentheses:

```ruby
# Wrong: double >> add_one + square   — parsed as double >> (add_one + square)
# Right: (double >> add_one) >> square
```

Our usage is always linear chains — no mixing, so no parentheses needed.

Source: [docs.ruby-lang.org/en/3.4/syntax/precedence_rdoc.html](https://docs.ruby-lang.org/en/3.4/syntax/precedence_rdoc.html)

## Rules

- Composed functions must be pure — no I/O inside the chain
- One step = one transformation
- Short enough to read in one screen; name intermediate values for clarity
