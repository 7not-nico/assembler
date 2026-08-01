# verify: enumerable-chain.md
require_relative "_helper"

# --- map ---
assert([1, 2, 3].map { |n| n * 2 }, [2, 4, 6], "map")
assert(%w[a b c].map(&:upcase), ["A", "B", "C"], "map symbol")

# --- filter_map ---
assert([1, 2, 3, 4].filter_map { |n| n * 2 if n.even? }, [4, 8], "filter_map")

# --- flat_map ---
assert([1, 2, 3].flat_map { |n| [n, -n] }, [1, -1, 2, -2, 3, -3], "flat_map")
result = RingGroups = {
  a: [1, 2],
  b: [3, 4]
}
assert(RingGroups.flat_map { |_g, items| items.map { |i| i * 10 } }, [10, 20, 30, 40], "flat_map nested map")

# --- group_by + select ---
entries = [{ id: "A" }, { id: "B" }, { id: "A" }]
by_id = entries.group_by { |e| e[:id] }
dupes = by_id.select { |_, g| g.size > 1 }
assert(dupes.keys, ["A"], "group_by select dupes")

# --- each_with_index filter_map ---
items = %w[a b c]
result = items.each_with_index.filter_map { |v, i| v if i.even? }
assert(result, %w[a c], "each_with_index filter_map evens")

# --- reduce pipeline ---
steps = [->(x) { x + 1 }, ->(x) { x * 2 }]
pipe = steps.reduce(->(x) { x }, &:>>)
assert(pipe.call(5), 12, "reduce pipeline (5+1)*2")

report "ruby-enumerable-chain"
