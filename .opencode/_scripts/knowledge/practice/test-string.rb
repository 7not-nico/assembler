# verify: core-string.md + string-slice.md + string-substitution.md + string-query.md + string-case.md + string-modify.md + string-encoding.md + string-convert.md
require_relative "_helper"

# --- string.md: creation ---
assert(String.new, "", "String.new empty")
assert(String.new("x"), "x", "String.new with arg")
assert("hello".class, String, "string literal class")

# --- string-slice.md: slicing ---
s = "hello there"
assert(s[0], "h", "[] index")
assert(s[-1], "e", "[] negative index")
assert(s[0, 5], "hello", "[] start, length")
assert(s[-5, 5], "there", "[] negative start")
assert(s[0..4], "hello", "[] range inclusive")
assert(s[/[aeiou]/], "e", "[] regexp")
assert(s["lo"], "lo", "[] substring match")
assert(s["xyz"], nil, "[] no match")

# slice! removal
s2 = "hello"
assert(s2.slice!(1), "e", "slice! removal")
assert(s2, "hllo", "slice! mutated")

# --- string-substitution.md: sub/gsub ---
assert("hello".sub(/[aeiou]/, "*"), "h*llo", "sub one")
assert("hello".gsub(/[aeiou]/, "*"), "h*ll*", "gsub all")
assert("hello".gsub(/[aeiou]/, ""), "hll", "gsub remove")
assert("hello".sub(/(.)(.)/, '\2\1'), "ehllo", "sub backref")
assert("1234".gsub(/\d/) { |m| m.succ }, "2345", "gsub block")

# hash replacement
h = {'foo' => 'bar'}
assert("food".sub('foo', h), "bard", "sub hash replacement")

# --- string-query.md: querying ---
assert("hello".length, 5, "length")
assert("hello".bytesize, 5, "bytesize")
assert("".empty?, true, "empty? true")
assert("hello".empty?, false, "empty? false")
assert("hello".include?("ell"), true, "include? true")
assert("hello".include?("xyz"), false, "include? false")
assert("hello".start_with?("he"), true, "start_with? true")
assert("hello".end_with?("lo"), true, "end_with? true")
assert("hello".index("l"), 2, "index")
assert("hello".rindex("l"), 3, "rindex")
assert("hello".count("l"), 2, "count chars")
assert("hello".match?(/l+/), true, "match? true")
assert("hello".match?(/x/), false, "match? false")

# --- string-case.md: casing ---
assert("hello".upcase, "HELLO", "upcase")
assert("HELLO".downcase, "hello", "downcase")
assert("hello".capitalize, "Hello", "capitalize")
assert("Hello".swapcase, "hELLO", "swapcase")

# bang versions mutate
s = "hello"
s.upcase!
assert(s, "HELLO", "upcase! mutates")

# --- string-modify.md: mutation ---
s = "hello"
s.insert(3, "xy")
assert(s, "helxylo", "insert")
s = "hello"
s << " world"
assert(s, "hello world", "<< concat")
s = "hello"
s.clear
assert(s, "", "clear")
s = "hello"
s.replace("bye")
assert(s, "bye", "replace")
s = "hello"
s.reverse!
assert(s, "olleh", "reverse!")
s = "hello"
s.delete!("l")
assert(s, "heo", "delete!")
s = "hello"
s.tr!("l", "x")
assert(s, "hexxo", "tr!")

# --- string-encoding.md ---
assert("hello".encoding, Encoding::UTF_8, "default encoding UTF-8")
assert("hello".valid_encoding?, true, "valid_encoding?")
assert("hello".ascii_only?, true, "ascii_only?")
assert("こんにちは".length, 5, "multi-byte length")
assert("こんにちは".bytesize, 15, "multi-byte bytesize")
assert("こんにちは"[2], "に", "multi-byte slice")

# --- string-convert.md: conversion ---
assert("42".to_i, 42, "to_i")
assert("3.14".to_f, 3.14, "to_f")
assert("hello".to_sym, :hello, "to_sym")
assert("FF".hex, 255, "hex")
assert("77".oct, 63, "oct")
assert("hello".chars, ["h", "e", "l", "l", "o"], "chars")
assert("hello".bytes, [104, 101, 108, 108, 111], "bytes")
assert("a b c".split, ["a", "b", "c"], "split")
assert("a,b,c".split(","), ["a", "b", "c"], "split with delimiter")

report "ruby-string"
