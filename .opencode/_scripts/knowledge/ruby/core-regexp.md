# Ruby Regexp

`Regexp` represents a regular expression pattern.

## Creation

```ruby
/pattern/                          # literal
/pattern/i                         # case-insensitive
Regexp.new("pattern")              # from string
Regexp.new("pattern", Regexp::IGNORECASE)
%r{pattern}                        # %r literal — avoids escaping /
%r|pattern|                        # delimiters can be | ! ( etc.
```

## Options / modifiers

| Flag | Class const | Meaning |
|------|-------------|---------|
| `i` | `Regexp::IGNORECASE` | Case-insensitive |
| `x` | `Regexp::EXTENDED` | Ignore whitespace, allow comments |
| `m` | `Regexp::MULTILINE` | Dot matches newline (dot-all) |
| `o` | `Regexp::ONCE` | Interpolate once |
| `n` | `Regexp::NOENCODING` | ASCII-8BIT pattern |
| `e` | | EUC-JP encoding |
| `s` | | Windows-31J encoding |
| `u` | | UTF-8 encoding |

## Inline mode modifiers

```ruby
/(?i)te(?-i)st/             # case-insensitive for "te" only
/(?i:subexpr)/               # scoped case-insensitivity
```

## Timeout (Ruby 3.2+)

```ruby
Regexp.timeout = 5.0        # global timeout seconds (nil = no timeout)
/foo/.timeout = 10.0        # per-regexp override (nil = fallback to global)
```

## ReDoS prevention (Ruby 3.4+)

```ruby
Regexp.linear_time?(/a*/)          # true — safe
Regexp.linear_time?(/(a*)\1/)      # false — exponential backtracking
```

```ruby
/foo/i                            # case-insensitive
/foo/imx                           # multiple flags
```

## Interpolation

```ruby
pattern = "foo"
/#{pattern}/                       # /foo/ — interpolates string
```

## Special variables

```ruby
$~   # last MatchData
$&   # last match string
$`   # pre-match string
$'   # post-match string
$1   # first capture
```

## Official Docs

<https://docs.ruby-lang.org/en/3.4/Regexp.html>
