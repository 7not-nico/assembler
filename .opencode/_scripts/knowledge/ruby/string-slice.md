# Ruby String Slicing

`String#[]` (aliased `slice`) returns a substring. `String#[]=` mutates. `String#slice!` removes and returns.

## Forms

```ruby
s = "hello there"

s[0]           # "h"          — single char at index
s[-1]          # "r"          — negative counts from end
s[0, 5]        # "hello"      — start, length
s[-5, 5]       # "there"      — negative start
s[0..4]        # "hello"      — range (inclusive)
s[0...5]       # "hello"      — range (exclusive)
s[/[aeiou]/]   # "e"          — regexp match
s[/[aeiou](.)\1/, 1]  # "l"   — regexp capture (index)
s[/(?<v>.)(?<w>.)/, "w"]  # "e" — named capture
s["lo"]        # "lo"         — substring match
s["xyz"]       # nil          — no match
```

## `[]=` — mutation

```ruby
s = "hello"
s[0] = "H"        # "Hello"
s[-1] = "!"       # "Hell!"
s[0..4] = "hi"    # "hi!"
```

## `slice!` — removal

```ruby
s = "hello"
s.slice!(1)  # "e", s == "hllo"
```
