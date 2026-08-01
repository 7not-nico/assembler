# Ruby Integer

`Integer` represents an integer value. Inherits from `Numeric`, includes `Comparable`. Immutable — singleton methods raise exception.

## Creation

```ruby
42           # decimal
0xFF         # hex
0b1010       # binary
0o777        # octal
0o10         # = 8
0d255        # decimal explicit
?A           # "A" — character literal (returns String in 1.9+)
Integer(3.14) # 3 — conversion
```

## Literals with separators

```ruby
1_000_000    # 1000000
0x_DEAD_BEEF # hex with separators
```

## Constants

```ruby
Integer::GMP_VERSION  # GMP library version string
```

## Official Docs

<https://docs.ruby-lang.org/en/3.4/Integer.html>
