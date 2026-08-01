#!/usr/bin/env ruby
# Batch refactoring: replace inlined operator switches with calc.Apply().
# Run: ruby script/refactor.rb

FILES = Dir["calc_*.go"].sort

# Pattern: direct assignment like "subject = subject + object"
# Replace with: "result, err := calc.Apply(op, subject, object)"
DIRECT_ASSIGN = /
  \t\t\tswitch\s+(\w+)\s*\{\n
  (?:\t\t\tcase\s*"\+":\s*\n\s*\1\s*=\s*\1\s*\+\s*(\w+)\s*\n)?
  (?:\t\t\tcase\s*"\-":\s*\n\s*\1\s*=\s*\1\s*-\s*(\w+)\s*\n)?
  (?:\t\t\tcase\s*"\*":\s*\n\s*\1\s*=\s*\1\s*\*\s*(\w+)\s*\n)?
  (?:\t\t\tcase\s*"\/":\s*\n(?:\s*if\s+\2\s*==\s*0\s*\{[^}]*\}\s*\n)?\s*\1\s*=\s*\1\s*\/\s*(\w+)\s*\n)?
  (?:\t\t\tcase\s*"\*\*":\s*\n\s*\1\s*=\s*math\.Pow\(\1,\s*(\w+)\)\s*\n)?
  \t\t\tdefault:\s*\n
  (?:\t\t\t\treturn\s+0,\s*fmt\.Errorf\([^)]+\)\s*\n)?
  \t\t\}
/mx

def replace_direct_assign(content, op_var, obj_var)
  old = <<~OLD
  \t\t\tswitch #{op_var} {
  \t\t\tcase "+":
  \t\t\t\t#{op_var} #{op_var} = #{op_var} + #{obj_var}
  \t\t\tcase "-":
  \t\t\t\t#{op_var} = #{op_var} - #{obj_var}
  \t\t\tcase "*":
  \t\t\t\t#{op_var} = #{op_var} * #{obj_var}
  \t\t\tcase "/":
  \t\t\t\tif #{obj_var} == 0 {
  \t\t\t\t\tfmt.Println("  ✗ division by zero")
  \t\t\t\t\tcontinue
  \t\t\t\t}
  \t\t\t\t#{op_var} = #{op_var} / #{obj_var}
  \t\t\tcase "**":
  \t\t\t\t#{op_var} = math.Pow(#{op_var}, #{obj_var})
  \t\t\tdefault:
  \t\t\t\treturn 0, fmt.Errorf("unknown action: %s", #{op_var})
  \t\t\t}
  OLD

  new = <<~NEW
  \t\t\tresult, err := calc.Apply(#{op_var}, #{op_var}, #{obj_var})
  \t\t\tif err != nil {
  \t\t\t\tfmt.Printf("  ✗ %v\\n", err)
  \t\t\t\tcontinue
  \t\t\t}
  \t\t\t#{op_var} = result
  NEW

  content.sub(old, new)
end

results = { ok: 0, skipped: 0, errors: [] }

FILES.each do |f|
  content = File.read(f)
  original = content.dup

  # Skip files that already use calc.Apply or are special variants
  if content.include?("calc.Apply")
    results[:skipped] += 1
    next
  end

  # Detect variants that need manual refactoring (methods, thunks, channels, stack)
  if content.include?("func (")  # method variant
    results[:skipped] += 1
    next
  end

  if f == "calc_evl.go" || f == "calc_chn.go" || f == "calc_stk.go" || f == "calc_dfr.go" || f == "calc_evl.go"
    results[:skipped] += 1
    next
  end

  # Try to find and replace the direct assignment pattern
  # Look for switch on op/action variable with + - * / ** cases
  if content =~ /switch\s+(op|action|token)\s*\{/
    op_var = $1
    if content =~ /case\s*"\*":\s*\n\s*#{op_var}\s*=\s*#{op_var}\s*\*\s*(\w+)/
      obj_var = $1

      new_content = content.dup

      # Pattern: simple switch op { case "+": subject = subject + object ... }
      patterns = [
        # Pattern 1: with division check
        [ /switch\s+#{op_var}\s*\{\n\s*case\s*"\+":\s*\n\s*#{op_var}\s*=\s*#{op_var}\s*\+\s*#{obj_var}\s*\n\s*case\s*"\-":\s*\n\s*#{op_var}\s*=\s*#{op_var}\s*-\s*#{obj_var}\s*\n\s*case\s*"\*":\s*\n\s*#{op_var}\s*=\s*#{op_var}\s*\*\s*#{obj_var}\s*\n\s*case\s*"\/":\s*\n\s*if\s+#{obj_var}\s*==\s*0\s*\{[^}]*\}\s*\n\s*#{op_var}\s*=\s*#{op_var}\s*\/\s*#{obj_var}\s*\n\s*case\s*"\*\*":\s*\n\s*#{op_var}\s*=\s*math\.Pow\(#{op_var},\s*#{obj_var}\)\s*\n\s*}/m,
          "result, err := calc.Apply(#{op_var}, #{op_var}, #{obj_var})\n\t\t\tif err != nil {\n\t\t\t\tfmt.Printf(\"  ✗ %v\\n\", err)\n\t\t\t\tcontinue\n\t\t\t}\n\t\t\t#{op_var} = result" ],
      ]

      patterns.each do |pattern, replacement|
        if new_content.sub!(pattern, replacement)
          puts "  #{f}: refactored switch → calc.Apply()"
          break
        end
      end

      if new_content == content
        puts "  #{f}: SKIPPED (pattern not matched)"
        results[:skipped] += 1
      else
        File.write(f, new_content)
        results[:ok] += 1
      end
    else
      puts "  #{f}: SKIPPED (no object variable found)"
      results[:skipped] += 1
    end
  else
    results[:skipped] += 1
  end
end

puts
puts "#{results[:ok]} refactored, #{results[:skipped]} skipped"
puts "Run 'go build ./...' to verify."
