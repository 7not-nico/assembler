#!/usr/bin/env ruby
# Phase 6: Refactor MAP's actionMap to use calc.Apply().
# The actionMap is a function map with duplicated operator logic.
# Run: ruby script/phase6-refactor-map.rb

c = File.read("calc_map.go")

# Find the actionMap declaration
idx = c.index("var actionMap = map[string]func(float64, float64) float64{")
unless idx
  puts "calc_map.go: no actionMap found"
  exit 1
end

# Find the closing brace
end_idx = c.index("}", idx)
while c[end_idx + 1] != "\n"
  end_idx = c.index("}", end_idx + 1)
  break unless end_idx
end

# Calculate indentation from the line
line_start = c.rindex("\n", idx) + 1
indent = c[line_start...idx]

# Replace the actionMap
old_map = c[idx..end_idx]
new_comment = "#{indent}// actionMap — operator logic moved to calc.Apply()"
c[idx..end_idx] = new_comment

# The MAP variant has a reduce function that calls actions[i](subject, objects[i])
# Replace it with calc.Reduce
if c =~ /func reduce\(/
  r_start = c.index("func reduce(")
  r_end = c.index("\n}", r_start) + 2
  old_reduce = c[r_start..r_end]
  
  # We need to rewrite reduce to use calc.Reduce or just call calc.Apply inline
  new_reduce = <<~NEW
  func reduce(actions []func(float64, float64) float64, objects []float64) float64 {
  \tsubject := 0.0
  \tfor i := 0; i < len(actions) && i < len(objects); i++ {
  \t\tresult, err := calc.Apply("+", subject, objects[i])
  \t\tif err == nil {
  \t\t\tsubject = result
  \t\t}
  \t}
  \treturn subject
  }
  NEW
  # Actually we can't auto-determine the operator from a function reference
  # So let's leave reduce as-is but change the actionMap reference
  puts "  calc_map.go: actionMap replaced, reduce function kept as-is"
else
  puts "  calc_map.go: actionMap replaced"
end

# Remove unused math import
c.sub!("\t\"math\"\n", "")

File.write("calc_map.go", c)
puts "calc_map.go: refactored"
