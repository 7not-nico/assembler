# verify: enumerable-zip.md
require_relative "_helper"

assert([1, 2, 3].zip([:a, :b, :c]), [[1, :a], [2, :b], [3, :c]], "zip")
assert([1, 2].zip([:a, :b, :c], [:x, :y]), [[1, :a, :x], [2, :b, :y]], "zip multiple")
assert([1, 2, 3].zip([:a]), [[1, :a], [2, nil], [3, nil]], "zip nil padding")

report "ruby-enumerable-zip"
