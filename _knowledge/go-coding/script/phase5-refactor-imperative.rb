#!/usr/bin/env ruby
# Phase 5: Refactor IMPERATIVE's ops map to use calc.Apply().
# Replaces the ops variable declaration and its usage.
# Run: ruby script/phase5-refactor-imperative.rb

c = File.read("calc_imperative.go")

# Find the ops map declaration
idx = c.index("var ops = map[string]func(float64, float64) float64{")
unless idx
  puts "calc_imperative.go: no ops map found"
  exit 1
end

# Find the closing brace of the map
end_idx = c.index("}", idx)
while c[end_idx + 1] != "\n"  # find the actual closing of the map
  end_idx = c.index("}", end_idx + 1)
  break unless end_idx
end

old_map = c[idx..end_idx]
new_comment = "// ops — operator logic moved to calc.Apply()"

# Replace the ops map
c[idx..end_idx] = new_comment

# Replace usage of ops[op](subject, object)
c.gsub!("ops[op](subject, object)", "calc.Apply(op, subject, object)")

# Remove unused math import
c.sub!("\t\"math\"\n", "")

File.write("calc_imperative.go", c)
puts "calc_imperative.go: ops map replaced with calc.Apply()"
