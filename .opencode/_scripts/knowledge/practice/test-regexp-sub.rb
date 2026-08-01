# verify: regexp-sub.md
require_relative "_helper"

# sub — first match only
assert("hello world".sub(/l/, "L"), "heLlo world", "sub first match")

# gsub — all matches
assert("hello world".gsub(/l/, "L"), "heLLo worLd", "gsub all")

# gsub with backreference
assert("hello".gsub(/(.)\1/, '\1-\1'), "hel-lo", "gsub backref")

# gsub with block
assert("abc123".gsub(/\d/) { |d| d.to_i + 1 }, "abc234", "gsub block")

# gsub with hash — include all matched chars
assert("hello".gsub(/[elo]/, "e" => "3", "l" => "l", "o" => "0"), "h3ll0", "gsub hash")

# gsub with block using match captures
assert("abc123".gsub(/(\d)(\d)/) { $1.to_i + $2.to_i }, "abc33", "gsub captures block")

# in-place
s = "hello"
s.sub!(/l/, "L")
assert(s, "heLlo", "sub!")
s = "hello"
s.gsub!(/l/, "L")
assert(s, "heLLo", "gsub!")
s = "hello"
result = s.sub!(/x/, "y")
assert(result, nil, "sub! nil on no match")
assert(s, "hello", "sub! untouched on no match")

report "ruby-regexp-sub"
