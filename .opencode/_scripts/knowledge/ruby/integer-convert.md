# Ruby Integer — Converting

## String

```ruby
42.to_s         # "42"
42.to_s(16)     # "2a"  — hex
42.to_s(2)      # "101010" — binary
255.to_s(8)     # "377" — octal
42.inspect      # "42"
```

## Float / chr / digits

```ruby
42.to_f         # 42.0
65.chr          # "A"
65.chr(Encoding::UTF_8)  # "A"
42.digits       # [2, 4]  — base-10 digits (LSB first)
42.digits(16)   # [10, 2]  — hex digits (LSB first)
```

## Rounding

```ruby
5.ceil          # 5     — no-op for integer
5.ceil(-1)      # 10    — round up to nearest 10
5.floor         # 5
5.floor(-1)     # 0     — round down to nearest 10
5.round         # 5
5.round(-1)     # 10    — round to nearest 10
5.truncate      # 5     — no-op for integer
5.truncate(-1)  # 0     — truncate to nearest 10
```

## Absolute / pred / succ

```ruby
(-42).abs       # 42
(-42).magnitude # 42    — alias
42.succ         # 43    — alias: next
42.pred         # 41
```

## Class methods

```ruby
Integer.sqrt(25)      # 5    — integer square root
Integer.sqrt(10**46)  # 10**23  — exact for big numbers
Integer.try_convert(1)      # 1
Integer.try_convert(1.25)   # 1    — via to_int
Integer.try_convert([])     # nil  — no to_int
```
