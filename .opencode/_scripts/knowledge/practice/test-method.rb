# verify: method-object.md
require_relative "_helper"

def double(x) = x * 2

# --- obtaining ---
m = method(:double)
assert(m.class, Method, "method object class")

# --- calling ---
assert(m.call(5), 10, "method.call")
assert(m[5], 10, "method.[]")
assert(m === 5, 10, "method.===")
assert(m.(5), 10, "method.()")

# --- introspection ---
assert(m.arity, 1, "method arity")
assert(m.parameters, [[:req, :x]], "method parameters")
loc = m.source_location
assert(loc.is_a?(Array), true, "source_location is Array")
assert(loc[0].include?("test-method.rb"), true, "source_location file")
assert(m.name, :double, "method name")
assert(m.original_name, :double, "method original name")
assert(m.owner, Object, "method owner (top-level defs live on Object)")

# --- to_proc ---
assert(method(:double).to_proc.call(5), 10, "to_proc.call")
assert([1, 2, 3].map(&method(:double)), [2, 4, 6], "map with method ref")

# --- multiple arities ---
def add(a, b) = a + b
m2 = method(:add)
assert(m2.call(3, 4), 7, "two-arg method")

# --- source_location for core methods ---
m3 = method(:puts)
loc3 = m3.source_location
assert(loc3.nil?, true, "core method source_location is nil")

report "ruby-method-object"
