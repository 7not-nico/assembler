# Ruby Float — Convert (web input → float)

## String#to_f — silent parse

```ruby
"3.14".to_f          # 3.14
"3.14e5".to_f        # 314000.0
"  -42.5  ".to_f     # -42.5  — whitespace ignored
"abc".to_f           # 0.0    — silent fail (!)
"12abc".to_f         # 12.0   — parses leading digits
"".to_f              # 0.0
```

`to_f` never raises. Returns `0.0` on invalid input — indistinguishable from `"0".to_f`.

## Kernel#Float — strict parse

```ruby
Float("3.14")         # 3.14
Float("3.14e5")       # 314000.0
Float("-42.5")        # -42.5
Float("  \n 3.14 ")   # 3.14  — whitespace OK

Float("abc")          # ArgumentError: invalid value for Float()
Float("12abc")        # ArgumentError: trailing junk
Float(nil)            # TypeError: can't convert nil into Float
Float(3)              # 3.0   — numeric inputs work
```

Use `Float()` for web/API input validation — it raises on malformed strings.

## Safe parse pattern

```ruby
def parse_float(s)
  Float(s)
rescue TypeError, ArgumentError
  nil
end
```

## Formatting floats for output

```ruby
3.14159.round(2)      # 3.14
format("%.2f", 3.14159)  # "3.14"
sprintf("%.2f", 3.14159) # "3.14"
"%.2f" % 3.14159      # "3.14"
3.14159.to_s          # "3.14159"
```

## Integer conversion

```ruby
3.14.to_i       # 3    — truncates
3.14.floor      # 3
3.14.ceil       # 4
3.14.round      # 3
3.14.truncate   # 3
```

## Predicates

```ruby
0.0.finite?    # true
1.0/0.0        # Infinity
(1.0/0.0).finite?   # false
(1.0/0.0).infinite?  # 1 — positive
(-1.0/0.0).infinite? # -1
(0.0/0.0).nan?       # true
```
