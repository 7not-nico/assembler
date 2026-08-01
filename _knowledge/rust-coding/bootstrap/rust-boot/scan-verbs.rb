#!/usr/bin/env ruby
# check verb misuse using lexicon
# verb heuristic only for function names (not variables)

root = File.expand_path('../..', __dir__)
lexicon = File.join(__dir__, '..', 'verb.txt')
known = File.readlines(lexicon).map(&:strip).reject { |l| l.empty? || l.start_with?('#') }

# verb suffix patterns for function heuristic (exclude -ing which is often noun)
func_suffix = /(ate|ify|ize|en|ish|ise)$/

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)
  in_test = false
  in_trait = false

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    next if line.strip.start_with?('//') || line.strip.start_with?('#!')
    in_test = true if line.strip.start_with?('#[test]')
    in_trait = true if line.match?(/\bimpl\s+\w+\s+for\s+\w+/)
    in_trait = false if in_trait && line.strip == '}'
    next if in_test || in_trait

    # function definition check
    if line.match?(/\bfn\s+(\w+)/)
      fn = line.match(/fn\s+(\w+)/)[1]
      next if fn == 'main'
      if known.include?(fn.downcase)
        puts "#{name}:#{lineno} — function '#{fn}' is a verb, use concrete noun"
      elsif fn.match?(func_suffix)
        puts "#{name}:#{lineno} — function '#{fn}' has verb suffix, use concrete noun"
      end
    end

    # variable check — only known verb list, no heuristic
    line.scan(/let\s+(\w+)\s*(?::|(?=\s*[=;]))/) do |match|
      var = match[0]
      next if var == '_' || var == 'mut'
      if known.include?(var.downcase)
        puts "#{name}:#{lineno} — variable '#{var}' is a verb, use descriptor"
      end
    end

    in_test = false if in_test && line.strip.start_with?('fn ')
  end
end