# ring: 1 (PURE)
# tests: _rb/validate.rb — CheckField, CheckRequired

require_relative "../_rb/loader"
require_relative "../_rb/validate"

failures = 0

check = ->(desc, actual, expected) {
  if actual == expected
    puts "  ✓ #{desc}"
  else
    puts "  ✗ #{desc}: expected #{expected.inspect}, got #{actual.inspect}"
    failures += 1
  end
}

puts "=== CheckField ==="

# string type
check.call("string valid", CheckField.call("hello", { type: "string" }), [])
check.call("string empty", CheckField.call("", { type: "string" }), ["must be non-empty string"])
check.call("string nil", CheckField.call(nil, { type: "string" }), ["must be non-empty string"])
check.call("string min_length pass", CheckField.call("abc", { type: "string", min_length: 2 }), [])
check.call("string min_length fail", CheckField.call("a", { type: "string", min_length: 2 }), ["min length 2"])

# integer type
check.call("integer valid", CheckField.call(5, { type: "integer" }), [])
check.call("integer string", CheckField.call("5", { type: "integer" }), ["must be integer >= 0"])
check.call("integer minimum pass", CheckField.call(3, { type: "integer", minimum: 1 }), [])
check.call("integer minimum fail", CheckField.call(0, { type: "integer", minimum: 1 }), ["must be integer >= 1"])

# array type
check.call("array valid", CheckField.call([1, 2], { type: "array" }), [])
check.call("array nil", CheckField.call(nil, { type: "array" }), ["must be array"])
check.call("array string", CheckField.call("a", { type: "array" }), ["must be array"])

# enum
check.call("enum valid", CheckField.call("active", { type: "string", enum: "active,draft" }), [])
check.call("enum invalid", CheckField.call("archived", { type: "string", enum: "active,draft" }), ["must be one of active/draft"])

# pattern
check.call("pattern valid", CheckField.call("MAX.TEST", { type: "string", pattern: '^MAX\.' }), [])
check.call("pattern invalid", CheckField.call("BAD.TEST", { type: "string", pattern: '^MAX\.' }), ["pattern mismatch"])

puts "=== CheckRequired ==="

check.call("required present", CheckRequired.call({ id: "x", title: "y" }, :id), nil)
check.call("required missing", CheckRequired.call({ title: "y" }, :id), "required field absent")
check.call("required nil value", CheckRequired.call({ id: nil }, :id), nil)

puts failures == 0 ? "ok — all pass" : "FAIL — #{failures} failures"
exit(failures)
