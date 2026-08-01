#!/usr/bin/env ruby
# extract all function names from fixtures
# flag verb patterns, uppercase starts, underscore separators

root = File.dirname(__dir__)
verb = %w[get set put add remove run exec read write push pop take make build create start stop find calc compute]

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)
  in_test = false
  in_trait = false

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    in_test = true if line.strip.start_with?('#[test]')
    in_trait = true if line.match?(/\bimpl\s+\w+\s+for\s+\w+/)
    next unless line.match?(/\bfn\s+(\w+)/)
    func = line.match(/fn\s+(\w+)/)[1]
    next if func == 'main'
    in_test = false if in_test
    in_trait = false if in_trait && line.strip == '}'

    flags = []
    flags << 'test_fn' if in_test
    flags << 'trait_fn' if in_trait
    flags << 'upper' if func[0] =~ /[A-Z]/
    flags << 'underscore' if func.match?(/[a-z]_[a-z]/)
    flags << 'verb' if verb.include?(func.downcase)

    if flags.any?
      puts "#{name}:#{lineno} — '#{func}' (#{flags.join(', ')})"
    end
  end
end