#!/usr/bin/env ruby
# Phase 2: Replace inlined operator switches with calc.Apply() calls.
# Uses exact string matching for reliable refactoring.
# Run: ruby script/phase2-refactor-switch.rb

require 'shellwords'

# Each entry: [filename, old_switch_block, new_calc_call]
REFACTORS = [
  # calc_aso.go: switch op { case "+": subject = subject + object ... }
  ["calc_aso.go",
   <<~'OLD',
  		switch op {
  		case "+":
  			subject = subject + object
  		case "-":
  			subject = subject - object
  		case "*":
  			subject = subject * object
  		case "/":
  			if object == 0 {
  				fmt.Println("  ✗ division by zero")
  				continue
  			}
  			subject = subject / object
  		case "**":
  			subject = math.Pow(subject, object)
  		}
   OLD
   <<~'NEW',
  		result, err := calc.Apply(op, subject, object)
  		if err != nil {
  			fmt.Printf("  ✗ %v\n", err)
  			continue
  		}
  		subject = result
   NEW
  ],

  # calc_oas.go: same pattern
  ["calc_oas.go",
   <<~'OLD',
  		switch op {
  		case "+":
  			subject = subject + object
  		case "-":
  			subject = subject - object
  		case "*":
  			subject = subject * object
  		case "/":
  			if object == 0 {
  				fmt.Println("  ✗ division by zero")
  				continue
  			}
  			subject = subject / object
  		case "**":
  			subject = math.Pow(subject, object)
  		}
   OLD
   <<~'NEW',
  		result, err := calc.Apply(op, subject, object)
  		if err != nil {
  			fmt.Printf("  ✗ %v\n", err)
  			continue
  		}
  		subject = result
   NEW
  ],

  # calc_osa.go: same pattern
  ["calc_osa.go",
   <<~'OLD',
  		switch op {
  		case "+":
  			subject = subject + object
  		case "-":
  			subject = subject - object
  		case "*":
  			subject = subject * object
  		case "/":
  			if object == 0 {
  				fmt.Println("  ✗ division by zero")
  				continue
  			}
  			subject = subject / object
  		case "**":
  			subject = math.Pow(subject, object)
  		}
   OLD
   <<~'NEW',
  		result, err := calc.Apply(op, subject, object)
  		if err != nil {
  			fmt.Printf("  ✗ %v\n", err)
  			continue
  		}
  		subject = result
   NEW
  ],

  # calc_ifc.go: switch with op variable, nested inside type switch
  ["calc_ifc.go",
   <<~'OLD',
   			switch op {
   			case "+":
   				subject = subject + object
   			case "-":
   				subject = subject - object
   			case "*":
   				subject = subject * object
   			case "/":
   				subject = subject / object
   			case "**":
   				subject = math.Pow(subject, object)
   			}
   OLD
   <<~'NEW',
   			result, err := calc.Apply(op, subject, object)
   			if err != nil {
   				fmt.Printf("  ✗ %v\n", err)
   				continue
   			}
   			subject = result
   NEW
  ],
]

results = { refactored: 0, skipped: 0, errors: [] }

REFACTORS.each do |file, old_text, new_text|
  unless File.exist?(file)
    results[:errors] << "#{file}: not found"
    next
  end

  content = File.read(file)
  if content.include?(old_text)
    content.sub!(old_text, new_text)
    File.write(file, content)
    puts "  #{file}: refactored switch → calc.Apply()"
    results[:refactored] += 1
  else
    puts "  #{file}: pattern not found (may already be refactored)"
    results[:skipped] += 1
  end
end

puts
puts "#{results[:refactored]} refactored, #{results[:skipped]} skipped"
if results[:errors].any?
  puts "Errors:"
  results[:errors].each { |e| puts "  #{e}" }
end
puts
puts "Run 'go build ./...' to verify."
