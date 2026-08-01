# Ruby Integer — Arithmetic

```ruby
2 + 3           # 5
2 - 3           # -1
2 * 3           # 6
2 ** 3          # 8    — exponentiation
2 ** -3         # (1/8)

# Division
4 / 3           # 1    — integer division truncates
4 / 3.0         # 1.333...
4 / Rational(3,1)  # (4/3)
4.fdiv(3)       # 1.3333333333333333  — always returns Float

# Modulo
10 % 3          # 1
10 % -3         # -2
-10 % 3         # 2
10.modulo(3)    # 1    — alias for %

# div and remainder
4.div(3)        # 1    — integer division
4.remainder(3)  # 1    — keeps sign of dividend
-4.remainder(3) # -1

# divmod — returns [quotient, modulo]
4.divmod(3)     # [1, 1]
-4.divmod(3)    # [-2, 2]

# pow — modular exponentiation
5.pow(3)        # 125
5.pow(3, 7)     # 6    — 5**3 % 7 (modular)
```
