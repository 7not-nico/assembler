# verify: hash-patterns.md
require_relative "_helper"

h = { a: 1, b: 2, c: 3 }

# --- fetch / dig ---
assert(h.fetch(:a), 1, "fetch existing")
assert(h.fetch(:x, :default), :default, "fetch default")
assert_raises(KeyError, "fetch missing") { h.fetch(:x) }

nested = { outer: { inner: 42 } }
assert(nested.dig(:outer, :inner), 42, "dig nested")
assert(nested.dig(:outer, :missing), nil, "dig missing")

# --- || defaults ---
meta = { id: "FOO" }
assert(meta[:id] || "fallback", "FOO", "|| existing")
assert(meta[:missing] || "fallback", "fallback", "|| missing")

# --- ** merge ---
info = { types: %w[a b], name: "test" }
merged = { group: :g, ring: 0, **info }
assert(merged[:group], :g, "splat merge group")
assert(merged[:types], %w[a b], "splat merge types")

# --- key? ---
assert(h.key?(:a), true, "key? exists")
assert(h.key?(:z), false, "key? missing")

# --- compact ---
with_nil = { a: 1, b: nil, c: 3 }
assert(with_nil.compact, { a: 1, c: 3 }, "compact")

# --- transform_values ---
assert({ a: 1, b: 2 }.transform_values { |v| v * 10 }, { a: 10, b: 20 }, "transform_values")

report "ruby-hash-patterns"
