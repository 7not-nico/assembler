# verify: core-enumerable.md + query + filter + map + sort + reduce + chain
require_relative "_helper"

# --- enumerable.md: include? / member? ---
assert([1, 2, 3].include?(2), true, "include?")
assert({ a: 1 }.include?(:a), true, "hash include? key")

# --- enumerable-query.md ---
assert([1, 2, 3].all?(&:positive?), true, "all?")
assert([1, 0, 3].all?(&:positive?), false, "all? false")
assert([nil, 2].all?, false, "all? falsey")
assert(%w[foo bar baz].all?(/o/), false, "all? pattern false")
assert([1, 2.5, 3].all?(Numeric), true, "all? Numeric")

assert([1, 0, 3].any?(&:zero?), true, "any? true")
assert([nil, false].any?, false, "any? false")
assert(%w[cat dog].any?(/dog/), true, "any? pattern")

assert([1, 2, 3].none?(&:zero?), true, "none? true")
assert([1, 2, 3].one?(&:even?), true, "one? true")

assert([1, 2, 3].count, 3, "count")
assert([1, 2, 2, 3].count(2), 2, "count occurrences")
assert([1, 2, 3, 4].count(&:even?), 2, "count block")

assert([1, 2, 3].find(&:even?), 2, "find")
assert([1, 3, 5].find(&:even?), nil, "find nil")

# --- enumerable-filter.md ---
assert([1, 2, 3, 4].select(&:even?), [2, 4], "select")
assert([1, 2, 3, 4].reject(&:even?), [1, 3], "reject")
assert(%w[cat dog cow bird].grep(/c/), ["cat", "cow"], "grep")
assert(%w[cat dog cow].grep_v(/c/), ["dog"], "grep_v")
assert([1, 2, 3, 4].partition(&:even?), [[2, 4], [1, 3]], "partition")

# --- enumerable-map.md ---
assert([1, 2, 3].map { |n| n * 2 }, [2, 4, 6], "map")
assert(%w[a b c].map(&:upcase), ["A", "B", "C"], "map symbol")
assert([1, 2, 3].flat_map { |n| [n, -n] }, [1, -1, 2, -2, 3, -3], "flat_map")
assert([1, 2, 3, 4].filter_map { |n| n * 2 if n.even? }, [4, 8], "filter_map")

# --- enumerable-sort.md ---
assert([3, 1, 2].sort, [1, 2, 3], "sort")
assert(%w[apple pear banana].sort_by(&:length), ["pear", "apple", "banana"], "sort_by")
assert([3, 1, 2].min, 1, "min")
assert([3, 1, 2].max, 3, "max")
assert([3, 1, 2].minmax, [1, 3], "minmax")
assert(%w[apple pear banana].min_by(&:length), "pear", "min_by")
assert(%w[apple pear banana].max_by(&:length), "banana", "max_by")

# --- enumerable-reduce.md ---
assert([1, 2, 3].reduce(0) { |s, n| s + n }, 6, "reduce with init")
assert([1, 2, 3].reduce(:+), 6, "reduce symbol")

result = %w[cat dog].each_with_object({}) { |w, h| h[w] = w.length }
assert(result, {"cat"=>3, "dog"=>3}, "each_with_object")

# --- enumerable-chain.md ---
chunked = [1, 2, 4, 9, 10, 12].chunk { |n| n.even? }.to_a
assert(chunked, [[false, [1]], [true, [2, 4]], [false, [9]], [true, [10, 12]]], "chunk")
assert(%w[foo bar stuff].slice_before(/b/).to_a, [["foo"], ["bar", "stuff"]], "slice_before")
assert(%w[foo bar baz].slice_after(/b/).to_a, [["foo", "bar"], ["baz"]], "slice_after")
assert([1, 2, 4, 5, 9].slice_when { |a, b| b != a + 1 }.to_a, [[1, 2], [4, 5], [9]], "slice_when")

report "ruby-enumerable"
