# verify: enumerable-slice.md
require_relative "_helper"

assert((1..6).each_slice(3).to_a, [[1, 2, 3], [4, 5, 6]], "each_slice")
assert((1..5).each_slice(2).to_a, [[1, 2], [3, 4], [5]], "each_slice uneven")
assert((1..5).each_cons(3).to_a, [[1, 2, 3], [2, 3, 4], [3, 4, 5]], "each_cons")
assert((1..4).each_cons(2).to_a, [[1, 2], [2, 3], [3, 4]], "each_cons pairs")

report "ruby-enumerable-slice"
