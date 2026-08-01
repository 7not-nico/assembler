# verify: core-regexp.md
require_relative "_helper"

re = /hello/i
assert(re.class, Regexp, "regexp literal")
assert(re.casefold?, true, "casefold? with i flag")

re2 = Regexp.new("hello", Regexp::IGNORECASE)
assert(re2.match?("HELLO"), true, "Regexp.new with flag")

assert(%r{hello}.match?("hello"), true, "%r{} literal")
assert(/foo/ix.match?("FOO\nBAR"), true, "multiple flags")

report "ruby-regexp"
