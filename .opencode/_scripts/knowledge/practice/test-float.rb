# verify: core-float.md + float-convert.md
require_relative "_helper"

# --- float.md ---
assert(1.0.class, Float, "float literal")
assert(1.5e2, 150.0, "scientific notation")
assert(Float(3), 3.0, "Float conversion")
assert(Float::EPSILON.is_a?(Float), true, "Float::EPSILON exists")
assert(Float::INFINITY.infinite?, 1, "Float::INFINITY")

# --- float-convert.md: String#to_f ---
assert("3.14".to_f, 3.14, "to_f basic")
assert("  -42.5  ".to_f, -42.5, "to_f whitespace")
assert("abc".to_f, 0.0, "to_f silent fail")
assert("12abc".to_f, 12.0, "to_f leading digits")
assert("".to_f, 0.0, "to_f empty string")

# --- float-convert.md: Kernel#Float ---
assert(Float("3.14"), 3.14, "Float() basic")
assert(Float("-42.5"), -42.5, "Float() negative")
assert(Float(3), 3.0, "Float() from int")

# Float raises
begin
  Float("abc")
  assert(false, true, "Float() invalid should raise")
rescue ArgumentError
  assert(true, true, "Float() raises ArgumentError")
end

begin
  Float(nil)
  assert(false, true, "Float() nil should raise")
rescue TypeError
  assert(true, true, "Float() raises TypeError on nil")
end

# --- float-convert.md: formatted output ---
assert(3.14159.round(2), 3.14, "round(2)")
assert(format("%.2f", 3.14159), "3.14", "format")
assert(sprintf("%.2f", 3.14159), "3.14", "sprintf")
assert("%.2f" % 3.14159, "3.14", "% operator")
assert(3.14159.to_f, 3.14159, "to_f identity")

# --- float-convert.md: int conversions ---
assert(3.14.to_i, 3, "to_i truncates")
assert(3.14.floor, 3, "floor")
assert(3.14.ceil, 4, "ceil")
assert(3.14.round, 3, "round")
assert((-3.14).abs, 3.14, "abs")

# --- float-convert.md: predicates ---
assert(0.0.finite?, true, "finite? true")
assert((1.0/0.0).finite?, false, "finite? false on Infinity")
assert((1.0/0.0).infinite?, 1, "infinite? positive")
assert((-1.0/0.0).infinite?, -1, "infinite? negative")
assert((0.0/0.0).nan?, true, "nan? true")

report "ruby-float"
