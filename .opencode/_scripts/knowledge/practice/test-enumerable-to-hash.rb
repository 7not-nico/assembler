# verify: enumerable-to-hash.md
require_relative "_helper"

assert(%w[cat dog].map { |w| [w, w.length] }.to_h, {"cat"=>3, "dog"=>3}, "to_h from pairs")
assert((1..3).to_h { |n| [n, n ** 2] }, { 1=>1, 2=>4, 3=>9 }, "to_h with block")

report "ruby-enumerable-to-hash"
