#!/usr/bin/env ruby
# check agentive suffix usage in method names per SPEC.CODE.ELEMENT.NAME
# Methods use [subject] + agentive {vowel}r suffix: -er, -or, -ier

root = File.expand_path('../..', __dir__)
issues = []

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)
  in_trait = false

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    next if line.strip.start_with?('//') || line.strip.start_with?('#!')
    in_trait = true if line.match?(/\bimpl\s+\w+\s+for\s+\w+/)
    in_trait = false if in_trait && line.strip == '}'

    # check fn with &self — method using agentive suffix
    if line.match?(/\bfn\s+(\w+)\(/) && !in_trait
      fn = line.match(/fn\s+(\w+)/)[1]
      next if fn == 'main'

      # check for banned patterns
      issues << "#{name}:#{lineno} — gerund '#{fn}' ends in -ing" if fn.match?(/ing$/)
      issues << "#{name}:#{lineno} — derived noun '#{fn}' uses -tion" if fn.match?(/tion$/)
      issues << "#{name}:#{lineno} — derived noun '#{fn}' uses -ment" if fn.match?(/ment$/)
      issues << "#{name}:#{lineno} — derived noun '#{fn}' uses -ance" if fn.match?(/ance$/)
      issues << "#{name}:#{lineno} — derived noun '#{fn}' uses -ion" if fn.match?(/ion$/)
    end
  end
end

if issues.empty?
  puts "no naming violations found"
else
  issues.each { |i| puts i }
  puts "\n#{issues.size} violations"
end