#!/usr/bin/env ruby
# extract all variable names from fixtures
# flag underscore prefix, multi-word underscore, verb patterns

root = File.dirname(__dir__)
verb = %w[get set put add remove run exec read write push pop take make build create start stop find calc compute]

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    next if line.strip.start_with?('//') || line.strip.start_with?('#!')

    # match let bindings: let name = ... or let name: Type = ...
    line.scan(/let\s+(\w+)\s*(?::|(?=\s*[=;]))/) do |match|
      var = match[0]
      next if var == '_' || var == 'mut'

      flags = []
      flags << 'underscore_prefix' if var.start_with?('_')
      flags << 'underscore_sep' if var.match?(/[a-z]_[a-z]/)
      flags << 'verb' if verb.include?(var.downcase)

      if flags.any?
        puts "#{name}:#{lineno} — '#{var}' (#{flags.join(', ')})"
      end
    end
  end
end