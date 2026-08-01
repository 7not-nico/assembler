#!/usr/bin/env ruby
# Rust reserved keywords reference
# source: https://doc.rust-lang.org/stable/reference/keywords.html

strict = %w[
  _ as async await break const continue crate dyn
  else enum extern false fn for if impl in let
  loop match mod move mut pub ref return self Self
  static struct super trait true type unsafe use where while
]

reserved = %w[
  abstract become box do final gen macro
  override priv try typeof unsized virtual yield
]

weak = %w[
  static macro_rules raw safe union
]

puts "=== strict keywords (#{strict.size}) ==="
puts strict.join(' ')

puts "\n=== reserved keywords (#{reserved.size}) ==="
puts reserved.join(' ')

puts "\n=== weak keywords (#{weak.size}) ==="
puts weak.join(' ')

puts "\ntotal: #{strict.size + reserved.size + weak.size}"