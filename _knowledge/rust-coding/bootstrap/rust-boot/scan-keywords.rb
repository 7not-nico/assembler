#!/usr/bin/env ruby
# check fixtures for names that conflict with Rust reserved keywords
# source: https://doc.rust-lang.org/stable/reference/keywords.html

root = File.expand_path('../..', __dir__)
reserve = File.join(__dir__, 'reserve.txt')
all = File.readlines(reserve).map(&:strip).reject { |l| l.empty? || l.start_with?('#') }

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    next if line.strip.start_with?('//') || line.strip.start_with?('#!')

    # check let bindings
    line.scan(/let\s+(\w+)\s*(?::|(?=\s*[=;]))/) do |match|
      var = match[0]
      next if var == '_' || var == 'mut'
      if all.include?(var)
        puts "#{name}:#{lineno} — variable '#{var}' is a reserved keyword"
      end
    end

    # check function names
    line.scan(/\bfn\s+(\w+)/) do |match|
      fn = match[0]
      next if fn == 'main'
      if all.include?(fn)
        puts "#{name}:#{lineno} — function '#{fn}' is a reserved keyword"
      end
    end

    # check struct names
    line.scan(/struct\s+(\w+)/) do |match|
      s = match[0]
      if all.include?(s.downcase)
        puts "#{name}:#{lineno} — struct '#{s}' conflicts with reserved keyword"
      end
    end
  end
end