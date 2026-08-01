#!/usr/bin/env ruby
# Phase 3: Refactor SAO's inline switch to use calc.Apply().
# Run: ruby script/phase3-refactor-sao.rb

c = File.read("calc_sao.go")

old = "\t\tswitch op {\n\t\tcase \"+\":\n\t\t\tsubject = subject + obj\n\t\tcase \"-\":\n\t\t\tsubject = subject - obj\n\t\tcase \"*\":\n\t\t\tsubject = subject * obj\n\t\tcase \"/\":\n\t\t\tif obj == 0 {\n\t\t\t\treturn 0, fmt.Errorf(\"division by zero\")\n\t\t\t}\n\t\t\tsubject = subject / obj\n\t\tcase \"**\":\n\t\t\tsubject = math.Pow(subject, obj)\n\t\tdefault:\n\t\t\treturn 0, fmt.Errorf(\"unknown operator: %s\", op)\n\t\t}"
new = "\t\tresult, err := calc.Apply(op, subject, obj)\n\t\tif err != nil {\n\t\t\treturn 0, err\n\t\t}\n\t\tsubject = result"

if c.sub!(old, new)
  c.sub!("\t\"math\"\n", "")
  c.sub!("\t\"strings\"\n", "\t\"strings\"\n\n\t\"go-coding/calc\"")
  File.write("calc_sao.go", c)
  puts "calc_sao.go: refactored"
else
  puts "calc_sao.go: FAILED — pattern not matched"
  exit 1
end
