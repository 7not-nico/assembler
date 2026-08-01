# verify: core-symbol.md
require_relative "_helper"

# --- identity guarantee ---
assert(:foo.object_id, :foo.object_id, "symbol identity: same object")
assert("foo".object_id != "foo".object_id, true, "string identity: different objects")

# --- creation ---
assert("foo".to_sym, :foo, "String#to_sym")
assert("foo".intern, :foo, "String#intern")

# --- conversion ---
assert(:foo.to_s, "foo", "to_s")
assert(:foo.name, "foo", "name (frozen)")
assert(:foo.inspect, ":foo", "inspect")
assert(:foo.to_sym, :foo, "to_sym returns self")

# --- querying ---
assert(:foo.length, 3, "length")
assert(:foo.size, 3, "size")
assert(:''.empty?, true, "empty? true for :''")
assert(:foo.empty?, false, "empty? false")
assert(:foo.match?(/f/), true, "match?")
assert(:foo.start_with?("f"), true, "start_with?")
assert(:foo.end_with?("o"), true, "end_with?")

# --- comparing ---
assert(:foo == :foo, true, "== same")
assert(:foo == :bar, false, "== different")
assert(:bar <=> :foo, -1, "<=> -1")
assert(:foo <=> :foo, 0, "<=> 0")
assert(:foo <=> :bar, 1, "<=> 1")
assert(:ABC.casecmp(:abc), 0, "casecmp 0")
assert(:ABC.casecmp?(:abc), true, "casecmp? true")

# --- casing ---
assert(:foo.capitalize, :Foo, "capitalize")
assert(:foo.upcase, :FOO, "upcase")
assert(:FOO.downcase, :foo, "downcase")
assert(:Foo.swapcase, :fOO, "swapcase")

# --- succ ---
assert(:foo.succ, :fop, "succ")

# --- Symbol#to_proc ---
assert(:to_s.to_proc.call(1000), "1000", "to_proc")
assert([1, 2, 3].map(&:to_s), ["1", "2", "3"], "map &:to_s")
assert(%w[a b].map(&:upcase), ["A", "B"], "map &:upcase")

report "ruby-symbol"
