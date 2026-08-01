#!/usr/bin/env ruby
# validate fixtures against naming conventions

root = File.dirname(__dir__)
issues = []

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)
  code = lines.reject { |l| l.strip.start_with?('//') || l.strip.empty? || l.strip.start_with?('#!') }

  # track trait impl blocks — methods inside are allowed
  in_trait = false

  code.each_with_index do |line, idx|
    lineno = idx + 1
    in_trait = true if line.match?(/\bimpl\s+\w+\s+for\s+\w+/)
    in_trait = false if !in_trait && idx > 0 && code[idx-1].match?(/\bimpl\s+\w+\s+for\s+\w+/) && line.strip == '}'
    in_trait = false if in_trait && line.strip == '}'

    # underscore prefix variable
    line.scan(/let\s+(_[a-z])/) do |m|
      issues << "#{name}:#{lineno} — underscore prefix '#{m[0]}'"
    end

    # methods outside trait impls
    if !in_trait && line.match?(/\bfn\s+\w+\(&\s*self\b/)
      func = line.match(/fn\s+(\w+)/)&.[](1)
      issues << "#{name}:#{lineno} — method '#{func}' should be free function"
    end

    # method names with underscore
    if line.match?(/\bfn\s+\w+\(/)
      func = line.match(/fn\s+(\w+)/)&.[](1)
      if func && func.match?(/[a-z]_[a-z]/)
        issues << "#{name}:#{lineno} — method '#{func}' has underscore"
      end
    end

    # struct names must be Upper
    line.scan(/struct\s+([a-z]\w*)\b/) do |m|
      issues << "#{name}:#{lineno} — struct '#{m[0]}' should be Upper"
    end

    # function names must be lower (not Upper)
    line.scan(/^(pub\s+)?fn\s+([A-Z]\w*)\b(?!\s*\{)/) do |m|
      next if m[1] == 'main' || m[1] == 'Ok' || m[1] == 'None' || m[1] == 'Some'
      issues << "#{name}:#{lineno} — function '#{m[1]}' should be lower"
    end
  end
end

if issues.empty?
  puts "all fixtures pass convention checks"
else
  issues.each { |i| puts i }
  puts "\n#{issues.size} issues found"
end