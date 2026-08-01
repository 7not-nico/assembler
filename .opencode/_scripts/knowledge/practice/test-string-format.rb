# verify: string-formatting.md
require_relative "_helper"

# --- ljust ---
assert("foo".ljust(5), "foo  ", "ljust 5")
assert("foo".ljust(5) == "foo  ", true, "ljust comparison")

# --- join with separator ---
assert(%w[a b c].join(" | "), "a | b | c", "join pipe")

# --- truncation ---
s = "hello world this is long"
assert(s[0..8], "hello wor", "truncate 0..8")
assert(s[0..4], "hello", "truncate 0..4")

# --- interpolation ---
n = 3
assert("#{n} item#{n != 1 ? 's' : ''}", "3 items", "plural 3")
n2 = 1
assert("#{n2} item#{n2 != 1 ? 's' : ''}", "1 item", "singular 1")

# --- table construction pattern ---
rows = [["A", 1], ["BB", 22]]
widths = [0, 1].map { |i|
  [rows.map { |r| r[i].to_s.size }.max, 1].max
}
assert(widths, [2, 2], "column widths")
head = %w[ID Val].map.with_index { |h, i| h.ljust(widths[i]) }.join(" | ")
assert(head, "ID | Val", "header row")

# --- inspect ---
assert("hello".inspect, '"hello"', "string inspect")
assert(42.inspect, "42", "integer inspect")

report "ruby-string-formatting"
