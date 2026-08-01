# Ruby Regexp — Quantifiers

## Greedy quantifiers (match as much as possible)

| Quantifier | Meaning |
|------------|---------|
| `*` | 0 or more |
| `+` | 1 or more |
| `?` | 0 or 1 |
| `{n}` | exactly n |
| `{n,}` | n or more |
| `{,m}` | 0 to m |
| `{n,m}` | n to m |

```ruby
/".*"/.match('"hello" "world"')      # '"hello" "world"' — greedy
/a+/.match("aaa")                     # "aaa"
/^.{8,}$/.match("password")          # at least 8 chars
```

## Lazy quantifiers (match minimal, `?` suffix)

```ruby
/".*?"/.match('"hello" "world"')     # '"hello"' — lazy
/".+?"/.match('"hello" "world"')     # '"hello"'
```

| Greedy | Lazy |
|--------|------|
| `*` | `*?` |
| `+` | `+?` |
| `?` | `??` |
| `{n,m}` | `{n,m}?` |

## Possessive quantifiers (no backtrack, `+` suffix)

```ruby
/".*+"/.match('"hello"')             # works
/".*+"/.match('"hello" "world"')     # no backtrack — fails
```

| Greedy | Possessive |
|--------|------------|
| `*` | `*+` |
| `+` | `++` |
| `?` | `?+` |
| `{n,m}` | `{n,m}+` |

Possessive + atomic group are the tool for catastrophic backtracking prevention.
