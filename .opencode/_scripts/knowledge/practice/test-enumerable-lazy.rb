# verify: enumerable-lazy.md
require_relative "_helper"

result = (1..Float::INFINITY).lazy.select(&:odd?).map { |n| n * 2 }.first(5)
assert(result, [2, 6, 10, 14, 18], "lazy chain")

result = [1, 2, 3].lazy.map { |n| n * 2 }.to_a
assert(result, [2, 4, 6], "lazy to_a")

report "ruby-enumerable-lazy"
