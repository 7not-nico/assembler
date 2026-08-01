# verify: enumerable-take.md
require_relative "_helper"

assert((1..100).first(3), [1, 2, 3], "first N")
assert((1..100).first, 1, "first without arg")
assert([].first, nil, "first on empty")

assert([5, 2, 8, 1].take(2), [5, 2], "take")
assert([5, 2, 8, 1].drop(2), [8, 1], "drop")
assert([5, 2, 8, 1].drop(0), [5, 2, 8, 1], "drop 0")

report "ruby-enumerable-take"
