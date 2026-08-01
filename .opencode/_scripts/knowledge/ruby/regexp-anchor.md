# Ruby Regexp — Anchors & Boundaries

## Line anchors

| Anchor | Meaning |
|--------|---------|
| `^` | Start of line |
| `$` | End of line (before newline) |

```ruby
/^hello/.match("hello world")        # #<MatchData "hello">
/world$/.match("hello world")        # #<MatchData "world">
```

## String anchors

| Anchor | Meaning |
|--------|---------|
| `\A` | Start of string (never after newline) |
| `\z` | Absolute end of string |
| `\Z` | End of string (before optional newline) |

```ruby
/\Ahello/.match("hello\nworld")      # matches
/^hello/.match("hello\nworld")       # matches first line
/\Ahello/.match("foo\nhello")        # nil — not start of string
```

## Word boundary

```ruby
/\b\w+\b/.match("hello world")       # "hello" — whole words
/\bcat\b/.match("the cat sat")       # "cat"
/\bcat\b/.match("category")          # nil — no boundary
/\B/.match("hello")                  # between adjacent word chars
```

## Lookaround as anchors

```ruby
# Positive lookahead
/\d+(?=%)/.match("50% off")          # "50" — followed by %

# Negative lookahead
/\d+(?!%)/.match("50 off")           # "50" — not followed by %

# Positive lookbehind
/(?<=\$)\d+/.match("$50")            # "50" — preceded by $

# Negative lookbehind
/(?<!\$)\d+/.match("50")             # "50" — not preceded by $
```

## Multi-line mode — dot-all, not line-anchor mode

In Ruby, `/m` enables dot-all mode (`.` matches `\n`). Unlike other languages, `/m` does NOT affect `^`/`$` — they always match at line boundaries.

```ruby
/^hello$/.match("foo\nhello\nbar")             # nil — $ anchored to absolute end
/^hello$/m.match("foo\nhello\nbar")             # nil — still nil! /m is dot-all, not multi-line
```

To match across lines with anchors, use `\A`/`\z` (always absolute) or `^`/`$` which always act line-based regardless of `/m`:
