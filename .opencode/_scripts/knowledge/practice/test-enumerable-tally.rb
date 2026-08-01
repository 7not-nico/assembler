# verify: enumerable-tally.md
require_relative "_helper"

assert(%w[a b a c a b].tally, {"a"=>3, "b"=>2, "c"=>1}, "tally")

h = {}
%w[a b a].tally(h)
assert(h, {"a"=>2, "b"=>1}, "tally with hash arg")

report "ruby-enumerable-tally"
