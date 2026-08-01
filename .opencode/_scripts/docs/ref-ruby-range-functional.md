# Range patterns for functional Ruby (3.4)

Context: `_rb/*.rb` uses pure lambdas, stdlib only. Ranges replace manual index/guard logic.

## Ring/boundary checks

```ruby
# overlap? — check two entity ring ranges intersect
(0..2).overlap?(1..3)   # => true
(0..2).overlap?(3..4)   # => false
(0..).overlap?(..0)     # => true  (endless × beginless)

# cover? — check value within range (obeys exclude_end?)
(1..4).cover?(2)        # => true
(1...4).cover?(4)       # => false

# cover? with range arg — check range containment
(0..6).cover?(2..4)     # => true
(0..6).cover?(2..7)     # => false
```

## Case dispatch

```ruby
# beginless ranges for guard clauses
case ring
when ..1   then "inner"
when 2..4  then "middle"
else           "outer"
end

# endless ranges in when
case count
when 0    then "empty"
when 1..3 then "few"
when 4..  then "many"
end
```

## Slicing

```ruby
items[3..]    # instead of items[3..-1]
items[..2]    # instead of items[0..2]
```

## Edge cases

| Expression | Result | Note |
|------------|--------|------|
| `(..4).begin` | `nil` | beginless begin |
| `(1..).end` | `nil` | endless end |
| `(nil..).inspect` | `(nil..)` | both beginless+endless |
| `(1...4).last` | `4` | `last` ignores `exclude_end?` |
| `(..4).each` | `RangeError` | beginless can't iterate |
