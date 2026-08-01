# verify: enumerable-iterate.md
require_relative "_helper"

result = %w[a b c].each_with_index.map { |e, i| "#{i}:#{e}" }
assert(result, ["0:a", "1:b", "2:c"], "each_with_index.map")

result = %w[a b c].map.with_index(1) { |e, i| "#{i}:#{e}" }
assert(result, ["1:a", "2:b", "3:c"], "map.with_index(1)")

result = %w[a b c d].select.with_index { |_, i| i.even? }
assert(result, ["a", "c"], "select.with_index")

assert([1, 2, 3].reverse_each.to_a, [3, 2, 1], "reverse_each")
assert([1, 2, 3].cycle(2).to_a, [1, 2, 3, 1, 2, 3], "cycle")

report "ruby-enumerable-iterate"
