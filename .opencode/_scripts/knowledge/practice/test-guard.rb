# verify: guard-clause.md
require_relative "_helper"

# --- guard return unless ---
guard = ->(x) {
  return nil unless x
  x * 2
}
assert(guard.call(nil), nil, "guard nil returns nil")
assert(guard.call(5), 10, "guard non-nil returns value")

# --- nil coalescing ---
fetch = ->(h, k) {
  h.key?(k) ? h[k] : nil
}
assert(fetch.call({ a: 1 }, :a), 1, "fetch existing")
assert(fetch.call({ a: 1 }, :b), nil, "fetch missing nil")

fallback = ->(h, k, default) {
  h.key?(k) ? h[k] : default
}
assert(fallback.call({ a: 1 }, :b, 99), 99, "fetch with fallback")

# --- empty check chain ---
clean = ->(v) {
  return nil if v.nil? || v.to_s.strip.empty?
  v.to_s.strip
}
assert(clean.call(nil), nil, "clean nil")
assert(clean.call(""), nil, "clean empty")
assert(clean.call("  "), nil, "clean whitespace")
assert(clean.call("foo"), "foo", "clean value")

# --- two-step guard (structural then semantic) ---
validate = ->(val) {
  return nil if val.nil?
  return nil if val == "NULL"
  return nil if val.strip.empty?
  val.strip
}
assert(validate.call(nil), nil, "validate nil")
assert(validate.call("NULL"), nil, "validate NULL")
assert(validate.call("  "), nil, "validate whitespace")
assert(validate.call("hello"), "hello", "validate value")

report "ruby-guard"
