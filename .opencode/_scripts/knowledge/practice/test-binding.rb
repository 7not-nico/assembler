# verify: core-binding.md
require_relative "_helper"

def get_binding
  x = 10
  y = 20
  binding
end

b = get_binding

# --- querying ---
assert(b.local_variables.sort, [:x, :y], "local_variables")
assert(b.local_variable_defined?(:x), true, "local_variable_defined? true")
assert(b.local_variable_defined?(:z), false, "local_variable_defined? false")
assert(b.local_variable_get(:x), 10, "local_variable_get")

# --- modifying ---
b.local_variable_set(:x, 99)
assert(b.local_variable_get(:x), 99, "local_variable_set modifies")

# --- eval ---
assert(b.eval("x + y"), 119, "eval in binding context")

# --- source_location ---
loc = b.source_location
assert(loc.is_a?(Array), true, "source_location is Array")
assert(loc[0].include?("test-binding.rb"), true, "source_location file")
assert(loc[1] > 0, true, "source_location line number")

# --- scope capture pattern ---
def capture(val)
  binding
end

c = capture(42)
assert(c.eval("val"), 42, "captured binding eval")

report "ruby-binding"
