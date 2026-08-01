#!/usr/bin/env ruby
# Fix missing closing braces on map declarations.
# Run: ruby script/fix-broken-maps.rb

files = ["calc_imperative.go", "calc_map.go"]

files.each do |f|
  c = File.read(f)
  
  # Find the last map entry before a function declaration
  # Pattern: "**": func(a, b float64) float64 { return math.Pow(a, b) },
  # Followed by blank lines then "func ..." or "// ..."
  if c =~ /("\*\*": func\(a, b float64\) float64 \{ return math\.Pow\(a, b\) \},)\n+/
    matched = $1
    rest = $'
    # Check if the next non-blank line is a function or comment
    if rest =~ /\A\n*(?:\/\/|func )/
      # Add closing brace
      c.sub!("#{matched}\n+") { "#{matched}\n}\n" }
      File.write(f, c)
      puts "#{f}: closing brace added"
    else
      puts "#{f}: no fix needed"
    end
  else
    puts "#{f}: pattern not found"
    # Debug: show the Pow line
    if c =~ /math\.Pow/
      puts "  Found math.Pow at:"
      puts c[c.index("math.Pow") - 40, 80]
    end
  end
end
