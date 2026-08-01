# Ruby Integer — Bitwise

```ruby
a = 0b0101  # 5
b = 0b0110  # 6
```

| Method | Result | Description |
|--------|--------|-------------|
| `a & b` | `0b0100` (4) | AND — both 1 |
| `a \| b` | `0b0111` (7) | OR — either 1 |
| `a ^ b` | `0b0011` (3) | XOR — different |
| `~a` | | One's complement (infinite sign bits) |
| `a << 1` | `0b1010` (10) | Left shift |
| `a >> 1` | `0b0010` (2) | Right shift |

## Bit slicing `[]`

```ruby
n = 0b1010  # 10
n[0]   # 0  — LSB
n[1]   # 1
n[3]   # 1
n[-1]  # 0  — negative always 0
n[0, 3]  # 2  — 3 bits from offset 0 (0b010)
n[0..2]  # 2  — range (0b010)
```

## Bit predicates

```ruby
mask = 0b0101
n = 0b1101
n.allbits?(mask)    # true  — all mask bits set in n
n.anybits?(mask)    # true  — any mask bit set in n
n.nobits?(mask)     # false — no mask bits set in n
```

## bit_length

```ruby
42.bit_length   # 6  — bits needed to represent (101010)
0.bit_length    # 0
-1.bit_length   # 0
(-2**12).bit_length  # 12
```
