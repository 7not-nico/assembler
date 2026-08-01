# verify: enumerable-group.md
require_relative "_helper"

assert((1..6).group_by(&:even?), { false=>[1, 3, 5], true=>[2, 4, 6] }, "group_by parity")
assert(%w[cat dog cow bird].group_by(&:length), { 3=>["cat", "dog", "cow"], 4=>["bird"] }, "group_by length")

report "ruby-enumerable-group"
