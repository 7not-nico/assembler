# verify: enumerable-uniq.md
require_relative "_helper"

assert([1, 1, 2, 3, 3].uniq, [1, 2, 3], "uniq")
assert([{ a: 1 }, { a: 1 }, { a: 2 }].uniq { |h| h[:a] }, [{ a: 1 }, { a: 2 }], "uniq block")

report "ruby-enumerable-uniq"
