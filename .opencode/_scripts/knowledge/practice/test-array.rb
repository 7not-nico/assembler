# verify: core-array.md + array-access.md + array-add.md + array-remove.md + array-query.md + array-transform.md + array-set.md
require_relative "_helper"

# --- array.md: creation ---
assert([], [], "empty literal")
assert([1, 'a', :b].length, 3, "mixed types")
assert(Array.new, [], "Array.new")
assert(Array.new(3), [nil, nil, nil], "Array.new(3)")
assert(Array.new(3) { |i| i }, [0, 1, 2], "Array.new with block")
assert(Array(1..5), [1, 2, 3, 4, 5], "Array(range)")
assert(%w[a b c], ["a", "b", "c"], "%w literal")
assert(%i[a b c], [:a, :b, :c], "%i literal")

# --- array-access.md: fetching ---
arr = [10, 20, 30, 40, 50]
assert(arr[0], 10, "[] index")
assert(arr[-1], 50, "[] negative")
assert(arr[0, 3], [10, 20, 30], "[] start, length")
assert(arr[0..2], [10, 20, 30], "[] range")
assert(arr.at(0), 10, "at")
assert(arr.fetch(0), 10, "fetch")
assert(arr.fetch(99, "x"), "x", "fetch default")
assert(arr.first, 10, "first")
assert(arr.first(3), [10, 20, 30], "first(3)")
assert(arr.last, 50, "last")
assert(arr.last(2), [40, 50], "last(2)")
assert(arr.take(2), [10, 20], "take")
assert(arr.drop(2), [30, 40, 50], "drop")
assert(arr.values_at(0, 2), [10, 30], "values_at")
assert([3, 1, 4].min, 1, "min")
assert([3, 1, 4].max, 4, "max")
assert([3, 1, 4, 1, 5].sort, [1, 1, 3, 4, 5], "sort")

# assoc / rassoc
pairs = [[:a, 1], [:b, 2]]
assert(pairs.assoc(:a), [:a, 1], "assoc")
assert(pairs.rassoc(2), [:b, 2], "rassoc")

# index
assert(arr.index(20), 1, "index")
assert(arr.rindex(20), 1, "rindex") # only one 20

# --- array-add.md: adding ---
a = [1, 2]
a.push(3)
assert(a, [1, 2, 3], "push")
a << 4
assert(a, [1, 2, 3, 4], "<<")
a.unshift(0)
assert(a, [0, 1, 2, 3, 4], "unshift")
a.insert(3, 'x')
assert(a, [0, 1, 2, 'x', 3, 4], "insert")

b = [1, 2]
b.concat([3, 4])
assert(b, [1, 2, 3, 4], "concat")
assert([1, 2] + [3, 4], [1, 2, 3, 4], "+ non-mutating")

c = [1, 2]
c.fill(0)
assert(c, [0, 0], "fill all")

# --- array-remove.md: removing ---
a = [1, 2, 3, 4, 5]
assert(a.pop, 5, "pop")
assert(a, [1, 2, 3, 4], "pop mutated")
assert(a.shift, 1, "shift")
assert(a, [2, 3, 4], "shift mutated")
a.delete(3)
assert(a, [2, 4], "delete by value")
a.delete_at(0)
assert(a, [4], "delete_at")

assert([1, nil, 2, nil].compact, [1, 2], "compact")
assert([1, 2, 1, 3].uniq, [1, 2, 3], "uniq")
assert([].empty?, true, "empty? true on empty")
assert([1].empty?, false, "empty? false on non-empty")

d = [1, 2, 3, 4]
d.delete_if { |x| x > 2 }
assert(d, [1, 2], "delete_if")
d.clear
assert(d, [], "clear")

# --- array-query.md: querying ---
assert([1, 2, 3].length, 3, "length")
assert([1, 2, 3].include?(2), true, "include? true")
assert([1, 2, 3].include?(4), false, "include? false")
assert([1, 2, 3].all? { |x| x > 0 }, true, "all? true")
assert([1, 2, 3].any? { |x| x > 2 }, true, "any? true")
assert([1, 2, 3].none? { |x| x > 5 }, true, "none? true")
assert([1, 2, 3].one? { |x| x == 2 }, true, "one? true")
assert([1, 2] == [1, 2], true, "== equal")
assert([1, 2] <=> [1, 3], -1, "<=> -1")
assert([1, 2] <=> [1, 2], 0, "<=> 0")
assert([1, 2] <=> [1, 1], 1, "<=> 1")

# --- array-transform.md: transforming ---
assert([1, 2, 3].map { |x| x * 2 }, [2, 4, 6], "map")
assert([1, 2, 3, 4].select { |x| x > 2 }, [3, 4], "select")
assert([1, 2, 3, 4].reject { |x| x > 2 }, [1, 2], "reject")
assert([3, 1, 4].sort, [1, 3, 4], "sort")
assert([1, 2, 3].reverse, [3, 2, 1], "reverse")
assert([1, 2, 3, 4].rotate, [2, 3, 4, 1], "rotate")
assert([1, [2, [3]]].flatten, [1, 2, 3], "flatten")
assert([1, [2, [3]]].flatten(1), [1, 2, [3]], "flatten depth")

# --- array-set.md: set ops ---
a = [1, 2, 3]
b = [3, 4, 5]
assert(a | b, [1, 2, 3, 4, 5], "union |")
assert(a & b, [3], "intersection &")
assert(a - b, [1, 2], "difference -")
assert(a + b, [1, 2, 3, 3, 4, 5], "concat +")

report "ruby-array"
