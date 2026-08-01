# ring: 1 (PURE)
# tests: _rb/violation.rb — ReportViolations

require_relative "../_rb/loader"
require_relative "../_rb/report"
require_relative "../_rb/violation"

failures = 0

check = ->(desc, actual, expected) {
  if actual == expected
    puts "  ✓ #{desc}"
  else
    puts "  ✗ #{desc}: expected #{expected.inspect}, got #{actual.inspect}"
    failures += 1
  end
}

puts "=== ReportViolations ==="

r = ReportViolations.call([], "test", "audit")
check.call("no violations", r, "ok — test audit: 0 violations")

r = ReportViolations.call([["BAD", "t", "f", "v", "problem"]], "test", "audit")
check.call("has violations", r.start_with?("test audit violations (1):"), true)
check.call("contains table", r.include?("ID"), true)
check.call("contains problem", r.include?("BAD"), true)

r = ReportViolations.call([["A", "t", "x", "1", "err"], ["B", "t", "y", "2", "err2"]], "multi", "check")
check.call("multiple violations count", r.start_with?("multi check violations (2):"), true)
check.call("both listed", r.include?("A") && r.include?("B"), true)

puts failures == 0 ? "ok — all pass" : "FAIL — #{failures} failures"
exit(failures)
