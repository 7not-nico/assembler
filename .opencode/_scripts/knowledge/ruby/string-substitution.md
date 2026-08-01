# Ruby String Substitution

`sub` — one substitution, returns new string. `gsub` — all substitutions, returns new string. Bang versions mutate.

## Arguments

| Argument | Type | Example |
|----------|------|---------|
| `pattern` | `Regexp` or `String` | `s.sub(/x/, 'y')` or `s.sub('x', 'y')` |
| `replacement` | `String` | `s.gsub(/x/, 'y')` — literal or back-references |
| `replacement` | `Hash` | `s.gsub(/x/, {'x' => 'y'})` — key match |
| `replacement` | block | `s.gsub(/x/) { \|match\| match.upcase }` |

## Back-references in replacement string

```ruby
s = "hello"
s.sub(/(.)(.)/, '\2\1')        # "ehllo" — \n capture groups
s.sub(/(?<a>.)(?<b>.)/, '\k<b>\k<a>')  # "ehllo" — named captures
s.sub(/./, '\&')                # "&" — $& (full match)
s.sub(/./, "\\'")               # "'" — $' (after match)
s.sub(/./, "\\`")               # "`" — $` (before match)
s.sub(/./, '\+')                # last capture
```

Block form avoids backslash escaping:

```ruby
"1234".gsub(/\d/) { |match| match.succ }  # "2345"
```
