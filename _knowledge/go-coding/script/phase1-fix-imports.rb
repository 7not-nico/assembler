#!/usr/bin/env ruby
# Phase 1: Fix import blocks in all calc_*.go files.
# Adds missing "go-coding/calc" and "go-coding/lib" imports.
# Fixes corrupted "\1)" patterns from bad regex replacements.
# Run: ruby script/phase1-fix-imports.rb

files = Dir["calc_*.go"].sort

# Fix corrupted \1) patterns first
files.each do |f|
  c = File.read(f)
  if c.include?("\\1)")
    c.gsub!("\\1)", "\t)")
    File.write(f, c)
    puts "  #{f}: fixed \\1) corruption"
  end
end

# Add missing imports
files.each do |f|
  content = File.read(f)
  original = content.dup

  needs_lib = content.include?("lib.") && !content.include?("\"go-coding/lib\"")
  needs_calc = content.include?("calc.") && !content.include?("\"go-coding/calc\"")

  next unless needs_lib || needs_calc

  if content =~ /^(\t*)\)$/m
    indent = $1
    indent_size = indent.length
    imports = []
    # Insert in reverse order so first listed appears first
    imports.unshift("\t\"go-coding/calc\"") if needs_calc
    imports.unshift("\t\"go-coding/lib\"") if needs_lib
    import_block = imports.join("\n")

    content.sub!(/^(\t*)\)$/m) { "#{import_block}\n#{indent})" }
  end

  if content != original
    File.write(f, content)
    changes = []
    changes << "calc" if needs_calc
    changes << "lib" if needs_lib
    puts "  #{f}: added #{changes.join(', ')} import"
  end
end

puts "\nDone. Run 'go build ./...' to verify."
