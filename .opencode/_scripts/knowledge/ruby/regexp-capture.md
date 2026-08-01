# Ruby Regexp — Capture Groups

## Numbered captures

```ruby
m = /(cat) (sat)/.match("the cat sat")
m[1]       # "cat"
m[2]       # "sat"
m.captures # ["cat", "sat"]
```

Non-capturing group `(?:...)`:

```ruby
/(?:cat) (sat)/.match("cat sat")
m = $~
m[1]       # "sat" — only one capture
m.captures # ["sat"]
```

## Named captures (Ruby 1.9+)

```ruby
m = /(?<animal>\w+) (?<action>\w+)/.match("cat sat")
m[:animal]       # "cat"
m["action"]      # "sat"
m.names          # ["animal", "action"]
```

## Backreferences

```ruby
/(\w+) \1/.match("cat cat")        # #<MatchData "cat cat">
/(?<word>\w+) \k<word>/.match("cat cat")  # named backreference
```

## Lookahead / lookbehind

```ruby
# Positive lookahead
/foo(?=bar)/.match("foobar")       # matches "foo" when followed by "bar"

# Negative lookahead
/foo(?!bar)/.match("foobaz")       # matches "foo" when NOT followed by "bar"

# Positive lookbehind
/(?<=foo)bar/.match("foobar")      # matches "bar" when preceded by "foo"

# Negative lookbehind
/(?<!foo)bar/.match("bazbar")      # matches "bar" when NOT preceded by "foo"
```

## Atomic group — `(?>...)`

Never backtracks into the group:

```ruby
# Without atomic
/^(\w+): (.*)$/.match("foo: x y")  # works

# Atomic — prevents catastrophic backtracking
/^(?>\w+): (.*)$/.match("foo: x y")
```

## Subexpression calls — `\g<name>` / `\g<n>`

Recursive patterns — calls the subexpression again:

```ruby
/\A(?<paren>\((?:\g<paren>)*\))*\z/.match("(())")  # nested parens
```

## Absence operator — `(?~...)`

Matches anything that does NOT match the contained subexpression:

```ruby
/(?~real)/.match("surrealist")           # "surrea"
/sur(?~real)ist/.match("surrealist")     # nil — absence excludes full match
```

## Conditional — `(?(n)yes|no)`

Match different patterns depending on whether a group matched:

```ruby
/\A(foo)?(?(1)T|F)\z/                    # "fooT" or "F"
```
