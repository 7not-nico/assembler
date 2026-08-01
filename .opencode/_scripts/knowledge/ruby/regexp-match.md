# Ruby Regexp — Matching (=~, match, match?, MatchData)

## =~ operator

Returns integer offset (or nil):

```ruby
/cat/ =~ "the cat sat"             # 4 — index of first char
"the cat sat" =~ /cat/             # 4 — commutative
/xyz/ =~ "hello"                   # nil
```

## match? (Ruby 2.4+) — fastest, no side effects

```ruby
/cat/.match?("the cat sat")        # true — no MatchData created
```

## match

```ruby
m = /cat/.match("the cat sat")
m.class                             # MatchData
m[0]                                # "cat" — whole match
```

With block:

```ruby
/cat/.match("the cat sat") { |m| m[0] }  # "cat"
```

## MatchData

```ruby
m = /(c)(a)(t)/.match("the cat sat")
m[0]       # "cat"   — whole match
m[1]       # "c"     — capture 1
m[2]       # "a"     — capture 2
m[3]       # "t"     — capture 3
m[1, 2]    # ["c", "a"]
m[1..2]    # ["c", "a"]

m.pre_match   # "the "
m.post_match  # " sat"
m.begin(0)    # 4 — start index of whole match
m.end(0)      # 7 — end index (exclusive)
m.offset(1)   # [4, 5] — [start, end) for capture 1

m.length      # 4 — captures + 1 (whole)
m.captures    # ["c", "a", "t"] — captures only
m.names       # [] — named capture names
```

## Global match variables

```ruby
"the cat sat" =~ /cat/
$~             # #<MatchData "cat">
$&             # "cat"
$`             # "the "
$'             # " sat"
```

## ~ — match against $_

```ruby
$_ = "hello world"
~ /world/      # 6 — same as $_ =~ /world/
```
