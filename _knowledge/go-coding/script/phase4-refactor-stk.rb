#!/usr/bin/env ruby
# Phase 4: Refactor STK's inline switch to use calc.Apply().
# Run: ruby script/phase4-refactor-stk.rb

c = File.read("calc_stk.go")

old = "\t\t\t\tvar result float64\n\t\t\t\tswitch token {\n\t\t\t\tcase \"+\":\n\t\t\t\t\tresult = a + b\n\t\t\t\tcase \"-\":\n\t\t\t\t\tresult = a - b\n\t\t\t\tcase \"*\":\n\t\t\t\t\tresult = a * b\n\t\t\t\tcase \"/\":\n\t\t\t\t\tresult = a / b\n\t\t\t\tcase \"**\":\n\t\t\t\t\tresult = math.Pow(a, b)\n\t\t\t\t}"
new = "\t\t\t\tresult, err := calc.Apply(token, a, b)\n\t\t\t\tif err != nil {\n\t\t\t\t\tfmt.Printf(\"  ✗ %v\\n\", err)\n\t\t\t\t\tcontinue\n\t\t\t\t}"

if c.sub!(old, new)
  c.sub!("\t\"math\"\n", "")
  c.sub!("\t\"os\"\n", "\t\"os\"\n\n\t\"go-coding/calc\"")
  File.write("calc_stk.go", c)
  puts "calc_stk.go: refactored"
else
  puts "calc_stk.go: FAILED — pattern not matched"
  exit 1
end
