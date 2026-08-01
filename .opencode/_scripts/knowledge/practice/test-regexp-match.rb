# verify: regexp-match.md
require_relative "_helper"

assert(/cat/ =~ "the cat sat", 4, "=~ returns offset")
assert(/xyz/ =~ "hello", nil, "=~ returns nil on no match")
assert(/cat/.match?("the cat sat"), true, "match? true")
assert(/dog/.match?("the cat sat"), false, "match? false")

m = /cat/.match("the cat sat")
assert(m.class, MatchData, "match returns MatchData")
assert(m[0], "cat", "match[0]")

m2 = /(c)(a)(t)/.match("the cat sat")
assert(m2[1], "c", "capture 1")
assert(m2[2], "a", "capture 2")
assert(m2.pre_match, "the ", "pre_match")
assert(m2.post_match, " sat", "post_match")
assert(m2.begin(0), 4, "begin(0)")
assert(m2.end(0), 7, "end(0)")
assert(m2.offset(1), [4, 5], "offset(1)")

report "ruby-regexp-match"
