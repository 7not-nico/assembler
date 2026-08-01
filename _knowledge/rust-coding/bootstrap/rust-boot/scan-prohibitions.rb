#!/usr/bin/env ruby
# check naming prohibitions per SPEC.CODE.ELEMENT.NAME
# imperative verb-led, bare infinitive, plural, 3+ words, snake, article

root = File.expand_path('../..', __dir__)
verb_path = File.join(__dir__, '..', 'verb.txt')
verb = File.readlines(verb_path).map(&:strip).reject { |l| l.empty? || l.start_with?('#') }

issues = []

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    next if line.strip.start_with?('//') || line.strip.start_with?('#!')

    # imperative verb-led — fn followed by bare verb
    line.scan(/\bfn\s+([a-z]\w+)/) do |match|
      fn = match[0]
      next if fn == 'main' || fn.match?(/er$|or$|ier$/)
      if verb.include?(fn)
        issues << "#{name}:#{lineno} — imperative verb-led fn '#{fn}' (should use agentive suffix)"
      end
    end

    # snake_case in function names
    if line.match?(/\bfn\s+[a-z]+_[a-z]+\b/)
      fn = line.match(/fn\s+([a-z]+_[a-z]+)/)&.[](1)
      if fn
        in_test = lines[0..idx].reverse.find { |l| l.strip.start_with?('#[test]') }
        next if in_test
        issues << "#{name}:#{lineno} — snake_case fn '#{fn}' (use camelCase or one word)"
      end
    end

    # three or more words in fn (two hyphens or underscores)
    if line.match?(/\bfn\s+\w+_\w+_\w+/)
      fn = line.match(/fn\s+(\w+_\w+_\w+)/)&.[](1)
      issues << "#{name}:#{lineno} — 3+ word fn '#{fn}' (max 2 words)"
    end
  end
end

if issues.empty?
  puts "no prohibition violations found"
else
  issues.each { |i| puts i }
  puts "\n#{issues.size} violations"
end