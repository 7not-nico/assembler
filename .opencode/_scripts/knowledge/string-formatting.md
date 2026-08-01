# Ruby String Formatting — Table Layout

Used in `_rb/report.rb` for tabular output.

## Padding

```ruby
h.ljust(widths[i])     # left-pad to width
v.to_s.ljust(widths[i]) # value must be string first
```

## Table join

```ruby
headers.map.with_index { |h, i| h.ljust(widths[i]) }.join(" | ")
```

## Truncation (for violation snippets)

```ruby
line[0..50]   # first 51 chars
line[0..60]   # first 61 chars
```

## String interpolation

```ruby
"#{head}\n#{sep}\n#{body}"
"#{n} #{word}#{n != 1 ? 's' : ''}"   # pluralize
```

## inspect for debug

```ruby
data[fname].inspect   # quote-wrapped string representation
```
