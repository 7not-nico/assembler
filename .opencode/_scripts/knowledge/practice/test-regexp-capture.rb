# verify: regexp-capture.md
require_relative "_helper"

m = /(?<animal>\w+) (?<action>\w+)/.match("cat sat")
assert(m[:animal], "cat", "named capture []")
assert(m["action"], "sat", "named capture string key")
assert(m.names, ["animal", "action"], "names")

# Non-capturing
m2 = /(?:cat) (sat)/.match("cat sat")
assert(m2[1], "sat", "non-capturing group")

# Backreference
assert(/(\w+) \1/.match?("cat cat"), true, "backreference")
assert(/(\w+) \1/.match?("cat dog"), false, "backreference no match")

# Named backreference
assert(/(?<w>\w+) \k<w>/.match?("cat cat"), true, "named backreference")

# Lookahead
assert(/foo(?=bar)/.match?("foobar"), true, "positive lookahead")
assert(/foo(?!bar)/.match?("foobaz"), true, "negative lookahead")
assert(/foo(?!bar)/.match?("foobar"), false, "negative lookahead no match")

# Lookbehind
assert(/(?<=foo)bar/.match?("foobar"), true, "positive lookbehind")
assert(/(?<!foo)bar/.match?("bazbar"), true, "negative lookbehind")

# Absence operator
assert(/(?~real)/.match?("surrealist"), true, "absence operator")

report "ruby-regexp-capture"
