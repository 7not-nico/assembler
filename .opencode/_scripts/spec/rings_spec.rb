# ring: 1 (PURE)
# tests: _rb/rings.rb — TypeToRing, RingGroups

require_relative "../_rb/loader"
require_relative "../_rb/rings"

failures = 0

check = ->(desc, actual, expected) {
  if actual == expected
    puts "  ✓ #{desc}"
  else
    puts "  ✗ #{desc}: expected #{expected.inspect}, got #{actual.inspect}"
    failures += 1
  end
}

puts "=== TypeToRing ==="

r = TypeToRing.call("maxims")
check.call("maxims group", r[:group], :axiomatic)
check.call("maxims ring", r[:ring], 0)

r = TypeToRing.call("cognitions")
check.call("cognitions group", r[:group], :encyclopedic)
check.call("cognitions ring", r[:ring], 1)

r = TypeToRing.call("persons")
check.call("persons group", r[:group], :chronicle)
check.call("persons ring", r[:ring], 0)

r = TypeToRing.call("nonexistent")
check.call("nonexistent type", r, nil)

r = TypeToRing.call("")
check.call("empty type", r, nil)

puts "=== RingGroups ==="

check.call("encyclopedic has rings", RingGroups[:encyclopedic].keys.sort, [0, 1, 2, 3])
check.call("architectonic has rings", RingGroups[:architectonic].keys.sort, [0, 1, 2])
check.call("chronicle has rings", RingGroups[:chronicle].keys.sort, [0, 1, 2])
check.call("axiomatic has rings", RingGroups[:axiomatic].keys.sort, [0, 1, 2])
check.call("composition has rings", RingGroups[:composition].keys.sort, [0, 1, 2, 3])

check.call("specifications ring 0",
  TypeToRing.call("specifications"),
  { group: :axiomatic, ring: 0, name: "Maxim, Precept, Specification" })

puts failures == 0 ? "ok — all pass" : "FAIL — #{failures} failures"
exit(failures)
