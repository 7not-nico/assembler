# Ruby Symbol

`Symbol` represents a named identifier — a unique, immutable object. Symbols are designed as identifiers, not text/data (use `String` for that).

## Creation

```ruby
:foo         # symbol literal
:"foo bar"   # quoted symbol
:"foo#{x}"   # interpolation
String  → Symbol: "foo".to_sym  # :foo
String  → Symbol: "foo".intern  # :foo
Symbol  → String: :foo.to_s     # "foo"
Symbol  → String: :foo.name     # "foo" (frozen)
Symbol  → String: :foo.inspect  # ":foo"
```

## Identity guarantee

The same symbol object is reused across the entire program — regardless of context:

```ruby
:foo.object_id == :foo.object_id  # true — always same object
"foo".object_id == "foo".object_id  # false — different objects
```

## Querying

| Method | Returns |
|--------|---------|
| `length` / `size` | character count |
| `empty?` | true if `:''` |
| `encoding` | Encoding object |
| `=~ /regex/` | match index or nil (delegates to String) |
| `match(/regex/)` | MatchData or nil |
| `match?(/regex/)` | true/false |
| `start_with?(str)` | true/false |
| `end_with?(str)` | true/false |

## Comparing

| Method | Returns |
|--------|---------|
| `==` / `===` | true if same content and encoding |
| `<=>` | -1, 0, 1 (delegates to String#<=>) |
| `casecmp` | -1, 0, 1 (ASCII case-insensitive) |
| `casecmp?` | true/false (Unicode case folding) |

## Converting

```ruby
:foo.to_s          # "foo"
:foo.name          # "foo" (frozen)
:foo.inspect       # ":foo"
:foo.to_proc       # Proc: &:foo
:foo.succ          # :fop
:foo.capitalize    # :Foo
:foo.upcase        # :FOO
:foo.downcase      # :foo
:foo.swapcase      # :FOO
```

## Symbol#to_proc

The most common functional use — creates a lambda that calls the named method on its argument:

```ruby
[1, 2, 3].map(&:to_s)           # ["1", "2", "3"]
[1, 2, 3].map(&:even?)          # [false, true, false]
%w[a b c].map(&:upcase)         # ["A", "B", "C"]
```

Equivalent to: `[1, 2, 3].map { |x| x.to_s }`

## Official Docs

<https://docs.ruby-lang.org/en/3.4/Symbol.html>
