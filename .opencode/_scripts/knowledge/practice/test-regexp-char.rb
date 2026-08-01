# verify: regexp-char.md + regexp-quant.md + regexp-anchor.md
require_relative "_helper"

# --- regexp-char.md ---
assert(/\d+/.match?("123"), true, "\\d digit")
assert(/\D+/.match?("abc"), true, "\\D non-digit")
assert(/\w+/.match?("hello_123"), true, "\\w word")
assert(/\s+/.match?("  "), true, "\\s whitespace")

# Custom class
assert(/[aeiou]/.match?("e"), true, "char class vowel")
assert(/[^aeiou]/.match?("b"), true, "negated char class")
assert(/[a-z&&[^aeiou]]/.match?("b"), true, "intersection")

# POSIX
assert(/[[:alpha:]]+/.match?("hello"), true, "posix alpha")
assert(/[[:digit:]]+/.match?("123"), true, "posix digit")

# Unicode property
assert(/\p{L}+/.match?("hello"), true, "unicode letter")
assert(/\p{Nd}+/.match?("123"), true, "unicode digit")

# Dot with /m
assert(/^.*$/.match?("hello\nworld"), true, "dot matches newline with /m")

# --- regexp-quant.md ---
assert(/a*/.match?(""), true, "zero or more")
assert(/a+/.match?("aaa"), true, "one or more")
assert(/a?/.match?(""), true, "zero or one")
assert(/^.{8,}$/.match?("password"), true, "min length")

# Lazy vs greedy
greedy = /".*"/.match('"hello" "world"')
assert(greedy[0], '"hello" "world"', "greedy matches max")

lazy = /".*?"/.match('"hello" "world"')
assert(lazy[0], '"hello"', "lazy matches min")

# --- regexp-anchor.md ---
assert(/\Ahello/.match?("hello world"), true, "\\A anchor")
assert(/world\z/.match?("hello world"), true, "\\z anchor")
assert(/\bcat\b/.match?("the cat sat"), true, "word boundary")
assert(/\bcat\b/.match?("category"), false, "word boundary no match")

report "ruby-regexp-char"
