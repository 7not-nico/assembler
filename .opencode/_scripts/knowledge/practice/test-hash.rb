# verify: core-hash.md + hash-access.md + hash-default.md + hash-modify.md + hash-query.md + hash-transform.md + hash-iterate.md + hash-key.md
require_relative "_helper"

# --- hash.md: creation ---
assert({}.class, Hash, "empty hash class")
assert({a: 1}[:a], 1, "JSON-style literal")
assert({:a => 1}[:a], 1, "hash-rocket literal")
x = 42; assert({x:}, {x: 42}, "value omitted syntax {x:} means {x: x}")

h = Hash.new
assert(h, {}, "Hash.new empty")
h = Hash.new(0)
assert(h[:missing], 0, "Hash.new default value")
h = Hash.new { |h2, k| h2[k] = [] }
assert(h[:a], [], "Hash.new default proc")

# --- hash-access.md: fetching ---
h = {a: 1, b: 2, c: 3}
assert(h[:a], 1, "[] access")
assert(h[:x], nil, "[] missing returns nil")
assert(h.fetch(:a), 1, "fetch")
assert_raises(KeyError, "fetch missing") { h.fetch(:x) }
assert(h.fetch(:x, 0), 0, "fetch default")
assert(h.values_at(:a, :c), [1, 3], "values_at")
assert(h.assoc(:a), [:a, 1], "assoc")
assert(h.rassoc(2), [:b, 2], "rassoc")
assert(h.key(1), :a, "key by value")
assert(h.keys, [:a, :b, :c], "keys")
assert(h.values, [1, 2, 3], "values")

nested = {a: {b: {c: 3}}}
assert(nested.dig(:a, :b, :c), 3, "dig")
assert(nested.dig(:a, :x), nil, "dig missing")

# --- hash-default.md: defaults ---
h = Hash.new(0)
assert(h[:x], 0, "default value")
h.default = -1
assert(h[:x], -1, "default= changed")

h = Hash.new { |h2, k| h2[k] = [] }
h[:a] << 1
assert(h[:a], [1], "default proc auto-create")
assert(h[:b], [], "default proc fresh per key")

# --- hash-modify.md: modifying ---
h = {}
h[:a] = 1
assert(h, {a: 1}, "[]= assignment")
h.store(:b, 2)
assert(h, {a: 1, b: 2}, "store")

h.merge!(b: 3, c: 4)
assert(h, {a: 1, b: 3, c: 4}, "merge!")
assert(h.delete(:a), 1, "delete returns value")
assert(h.delete(:x), nil, "delete missing nil")
assert(h, {b: 3, c: 4}, "delete mutated")
assert(h.shift, [:b, 3], "shift first entry")

h.replace({x: 9})
assert(h, {x: 9}, "replace")
h.clear
assert(h, {}, "clear")

h2 = {a: 1, b: nil, c: 3}
h2.compact!
assert(h2, {a: 1, c: 3}, "compact! removes nil values")

h3 = {a: 1, b: 2, c: 3}
h3.delete_if { |k, v| v < 3 }
assert(h3, {c: 3}, "delete_if")

# --- hash-query.md: querying ---
assert({a: 1}.size, 1, "size")
assert({a: 1}.length, 1, "length")
assert({}.empty?, true, "empty? true")
assert({a: 1}.empty?, false, "empty? false")
assert({a: 1}.include?(:a), true, "include? true")
assert({a: 1}.include?(:x), false, "include? false")
assert({a: 1}.key?(:a), true, "key? true")
assert({a: 1}.has_key?(:a), true, "has_key? true")
assert({a: 1}.value?(1), true, "value? true")
assert({a: 1}.has_value?(1), true, "has_value? true")
assert({a: 1, b: 2}.any? { |k, v| v > 1 }, true, "any? true")

# --- hash-transform.md: transforming ---
h = {a: 1, b: 2}
assert(h.transform_keys { |k| k.to_s }, {"a"=>1, "b"=>2}, "transform_keys")
assert(h.transform_values { |v| v * 2 }, {a: 2, b: 4}, "transform_values")
assert(h.select { |k, v| v > 1 }, {b: 2}, "select")
assert(h.reject { |k, v| v > 1 }, {a: 1}, "reject")
assert({a: 1, b: nil}.compact, {a: 1}, "compact")
assert({a: 1, b: 2, c: 3}.slice(:a, :c), {a: 1, c: 3}, "slice")
assert({a: 1, b: 2}.except(:a), {b: 2}, "except")
assert({a: 1, b: 2}.invert, {1=>:a, 2=>:b}, "invert")
assert({a: 1} < {a: 1, b: 2}, true, "proper subset")
assert({a: 1, b: 2} > {a: 1}, true, "proper superset")
assert({a: 1, b: 2} >= {a: 1}, true, "superset")
assert({a: 1} <= {a: 1, b: 2}, true, "subset")

# --- hash-iterate.md: iterating ---
h = {a: 1, b: 2}
keys = []; h.each_key { |k| keys << k }
assert(keys, [:a, :b], "each_key")

vals = []; h.each_value { |v| vals << v }
assert(vals, [1, 2], "each_value")

pairs = []; h.each { |k, v| pairs << [k, v] }
assert(pairs, [[:a, 1], [:b, 2]], "each")

# --- hash-key.md: keys ---
assert([1, 2].hash == [1, 2].hash, true, "same array hash")
assert([1, 2].eql?([1, 2]), true, "same array eql?")

a0 = [:foo, :bar]
h = {a0 => 1}
a0[0] = :bam
assert(h[a0], nil, "key modification damages index")
h.rehash
assert(h[a0], 1, "rehash repairs index")

# compare_by_identity
h2 = {}.compare_by_identity
h2["hello"] = 1
h2["hello"] = 2
assert(h2.size, 2, "compare_by_identity treats strings as distinct")
assert(h2.compare_by_identity?, true, "compare_by_identity? true")

# string keys auto-freeze
s = "foo"
h3 = {s => 1}
assert(h3.keys.first.frozen?, true, "string key auto-frozen")

report "ruby-hash"
