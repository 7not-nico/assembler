# ring: 1 (PURE)
# tests: _rb/entity.rb — LoadAllEntities, LoadEntities

require_relative "../_rb/loader"
require_relative "../_rb/paths"
require_relative "../_rb/frontmatter"
require_relative "../_rb/entity"

failures = 0

check = ->(desc, actual, expected) {
  if actual == expected
    puts "  ✓ #{desc}"
  else
    puts "  ✗ #{desc}: expected #{expected.inspect}, got #{actual.inspect}"
    failures += 1
  end
}

puts "=== LoadAllEntities ==="

all = LoadAllEntities.call
check.call("returns array", all.is_a?(Array), true)
check.call("has many entries", all.size > 300, true)
check.call("each has id", all.all? { |e| e[:id] }, true)
check.call("each has type", all.all? { |e| e[:type] }, true)
check.call("each has file", all.all? { |e| e[:file] }, true)

ids = all.map { |e| e[:id].to_s }
check.call("MAX.DRY exists", ids.include?("MAX.DRY"), true)
check.call("PROT.COMMAND exists", ids.include?("PROT.COMMAND"), true)
check.call("PAT.TRACER.BULLETS exists", ids.include?("PAT.TRACER.BULLETS"), true)

puts "=== LoadEntities ==="

maxims = LoadEntities.call("maxims")
check.call("returns array", maxims.is_a?(Array), true)
check.call("all are maxims", maxims.all? { |e| e[:type] == "maxims" }, true)
check.call("MAX prefix", maxims.all? { |e| e[:id].to_s.start_with?("MAX.") }, true)

empty = LoadEntities.call("nonexistent")
check.call("nonexistent type returns []", empty, [])

puts failures == 0 ? "ok — all pass" : "FAIL — #{failures} failures"
exit(failures)
