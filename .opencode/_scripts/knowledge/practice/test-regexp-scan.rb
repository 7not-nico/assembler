# verify: regexp-scan.md
require_relative "_helper"

# scan
assert("hello world".scan(/l/), ["l", "l", "l"], "scan")
assert("abc123def456".scan(/\d+/), ["123", "456"], "scan digits")

# scan with captures
assert("a:1 b:2".scan(/(\w+):(\d+)/), [["a", "1"], ["b", "2"]], "scan captures")

# scan with block
result = []
"abc123".scan(/\d/) { |d| result << d.to_i }
assert(result, [1, 2, 3], "scan block")

# split
assert("a,b,c".split(/,/), ["a", "b", "c"], "split")
assert("a,b,c".split(/,/, 2), ["a", "b,c"], "split limit")
assert("a,b,c".split(/(,)/), ["a", ",", "b", ",", "c"], "split include delimiter")

# partition
assert("hello.world.ruby".partition(/\./), ["hello", ".", "world.ruby"], "partition")
assert("hello.world.ruby".rpartition(/\./), ["hello.world", ".", "ruby"], "rpartition")

report "ruby-regexp-scan"
