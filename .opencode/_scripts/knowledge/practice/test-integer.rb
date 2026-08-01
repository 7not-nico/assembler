# verify: core-integer.md + integer-arithmetic.md + integer-bitwise.md + integer-compare.md + integer-convert.md + integer-iterate.md
require_relative "_helper"

# --- integer.md: creation ---
assert(42.class, Integer, "decimal literal")
assert(0xFF, 255, "hex literal")
assert(0b1010, 10, "binary literal")
assert(0o777, 511, "octal literal")
assert(?A, "A", "char literal returns string")
assert(1_000_000, 1000000, "separator")
assert(Integer(3.14), 3, "Integer conversion")

# --- integer-arithmetic.md ---
assert(2 + 3, 5, "add")
assert(2 - 3, -1, "subtract")
assert(2 * 3, 6, "multiply")
assert(2 ** 3, 8, "exponent")
assert(4 / 3, 1, "int division truncates")
assert(4 / 3.0, 4 / 3.0, "float division")
assert(10 % 3, 1, "modulo")
assert(4.div(3), 1, "div")
assert(4.divmod(3), [1, 1], "divmod")
assert(4.remainder(3), 1, "remainder")
assert(5.pow(3, 7), 6, "modular pow")

# --- integer-bitwise.md ---
a = 0b0101
b = 0b0110
assert(a & b, 0b0100, "bitwise AND")
assert(a | b, 0b0111, "bitwise OR")
assert(a ^ b, 0b0011, "bitwise XOR")

n = 0b1010
assert(n[0], 0, "bit slice index 0")
assert(n[1], 1, "bit slice index 1")
assert(n[0, 3], 2, "bit slice offset,length")
assert(n[0..2], 2, "bit slice range")

assert(n.allbits?(0b1010), true, "allbits? true")
assert(n.allbits?(0b1111), false, "allbits? false")
assert(n.anybits?(0b0010), true, "anybits? true")
assert(n.nobits?(0b0100), true, "nobits? true")
assert(42.bit_length, 6, "bit_length")

# --- integer-compare.md ---
assert(1 < 2, true, "<")
assert(1 <= 1, true, "<=")
assert(1 == 1, true, "==")
assert(1 == 1.0, true, "== numeric")
assert(1.eql?(1), true, "eql?")
assert(1 <=> 2, -1, "<=> -1")
assert(1 <=> 1, 0, "<=> 0")
assert(1 <=> 0, 1, "<=> 1")
assert(1 <=> 'x', nil, "<=> nil for incomparable")

# --- integer-convert.md ---
assert(42.to_s, "42", "to_s")
assert(42.to_s(16), "2a", "to_s hex")
assert(42.to_s(2), "101010", "to_s binary")
assert(42.to_f, 42.0, "to_f")
assert(65.chr, "A", "chr")
assert(42.digits, [2, 4], "digits")
assert(42.digits(16), [10, 2], "digits hex")

assert(5.ceil, 5, "ceil")
assert(5.ceil(-1), 10, "ceil(-1)")
assert(5.floor, 5, "floor")
assert(5.floor(-1), 0, "floor(-1)")
assert(5.round(-1), 10, "round(-1)")
assert((-42).abs, 42, "abs")
assert(42.succ, 43, "succ")
assert(42.next, 43, "next")
assert(42.pred, 41, "pred")

assert(Integer.sqrt(25), 5, "Integer.sqrt")
assert(Integer.try_convert(1), 1, "Integer.try_convert int")
assert(Integer.try_convert(1.25), 1, "Integer.try_convert float")
assert(Integer.try_convert([]), nil, "Integer.try_convert nil")

# --- integer-iterate.md ---
result = []
5.times { |i| result << i }
assert(result, [0, 1, 2, 3, 4], "times")

assert(3.upto(6).to_a, [3, 4, 5, 6], "upto")
assert(6.downto(3).to_a, [6, 5, 4, 3], "downto")

report "ruby-integer"
