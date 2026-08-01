# Ruby String

`String` holds an arbitrary sequence of bytes, typically text or binary data.

## Creation

```ruby
s = "hello"            # double-quoted literal
s = 'hello'            # single-quoted literal
s = String.new          # ""
s = String.new("x")     # "x"
s = String.try_convert("x")  # "x" or nil
```

## Bang (`!`) convention

Methods ending in `!` mutate `self` and return `self` (or `nil` if no change). Non-bang versions return a new string.

Exception: some methods mutate without `!` (e.g., `replace`, `clear`, `insert`, `<<`).

## Official Docs

<https://docs.ruby-lang.org/en/3.4/String.html>
