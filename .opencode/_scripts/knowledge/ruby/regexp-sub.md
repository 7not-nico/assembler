# Ruby Regexp — Substitution (sub, gsub)

## sub — replace first match

```ruby
"hello world".sub(/l/, "L")            # "heLlo world"
```

## gsub — replace all matches

```ruby
"hello world".gsub(/l/, "L")           # "heLLo worLd"
"hello world".gsub(/[aeiou]/, "?")     # "h?ll? w?rld"
```

## With backreferences in replacement string

```ruby
"hello".gsub(/(.)\1/, '\1-\1')         # "hel-lo"  — capture ref
"hello".gsub(/(.)\1/, "\\1-\\1")       # same, double-escaped
"hello".gsub(/(.)\1/, '\k<1>-\k<1>')  # same, named ref
```

## With block

```ruby
"hello".gsub(/l/) { |m| m.upcase }     # "heLLo"
"abc123".gsub(/\d/) { |d| d.to_i + 1 }  # "abc234"
```

## With hash — include all matched keys

```ruby
"hello".gsub(/[elo]/, "e" => "3", "l" => "l", "o" => "0")  # "h3ll0"
# unmatched hash keys → replaced with empty string
```

## With block and captures

```ruby
"abc123".gsub(/(\d)(\d)/) { $1.to_i + $2.to_i }  # "abc33"
# "12" replaced by 3; remaining "3" unchanged
```

## In-place versions

```ruby
s = "hello"
s.sub!(/l/, "L")        # s = "heLlo"
s.gsub!(/l/, "L")       # s = "heLLo"
s.sub!(/x/, "y")        # nil — no match, s unchanged
```
