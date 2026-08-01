# verify: kernel-tap.md
require_relative "_helper"

# --- tap ---
side_effects = []
result = [1, 2, 3].map { |n| n * 2 }
                   .tap { |arr| side_effects << arr }
                   .select(&:even?)
assert(result, [2, 4, 6], "tap returns receiver")
assert(side_effects, [[2, 4, 6]], "tap captures in block")

# --- tap returns the receiver ---
obj = "hello"
result = obj.tap { |s| s.upcase! }
assert(result, "HELLO", "tap returns receiver after mutation")
assert(result.equal?(obj), true, "tap returns same object")

# --- then / yield_self ---
result = "hello".then { |s| s.upcase + "!" }
assert(result, "HELLO!", "then transforms")

result2 = 3.then { |n| n * 10 }
           .then { |n| n.to_s }
           .then { |s| s + "x" }
assert(result2, "30x", "then chain")

# --- yield_self alias ---
result3 = "foo".yield_self(&:upcase)
assert(result3, "FOO", "yield_self alias")

# --- itself ---
assert([1, 2, 3, 1, 2].uniq(&:itself), [1, 2, 3], "itself for uniq")
assert([3, 2, 1].sort_by(&:itself), [1, 2, 3], "itself for sort_by")

# --- then vs tap ---
chain = "abc"
tap_result = chain.tap { |s| s.upcase! }
then_result = chain.then { |s| s.upcase }
assert(tap_result, "ABC", "tap mutates and returns same")
assert(then_result, "ABC", "then transforms and returns new")

report "ruby-kernel-tap"
