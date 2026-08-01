#!/usr/bin/env ruby
# check fixtures against semantic code conventions
# redundancies, methods inlined, variable distinctness, noun types

root = File.expand_path('../..', __dir__)
issues = []

# known abstract nouns that should not be function names
abstract = %w[
  duration computation iteration operation condition relation
  situation state quality amount quantity process function
  behavior activity performance capacity capability
]

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  lines = File.readlines(path)
  funcs = []
  in_trait = false

  lines.each_with_index do |line, idx|
    next if line.strip.start_with?('//')
    lineno = idx + 1
    in_trait = true if line.match?(/\bimpl\s+\w+\s+for\s+\w+/)
    in_trait = false if in_trait && line.strip == '}'

    # variable shadows function name
    funcs.each do |fn, fn_lineno|
      if line.match?(/\b#{fn}\b/) && !line.include?("fn #{fn}")
        if line.match?(/let\s+#{fn}\b/)
          issues << "#{name}:#{lineno} — variable '#{fn}' shadows function defined at line #{fn_lineno}"
        end
      end
    end

    # function definition
    if line.match?(/\bfn\s+(\w+)/) && !in_trait
      fn = line.match(/fn\s+(\w+)/)[1]
      next if fn == 'main'
      funcs << [fn, lineno]

      # abstract noun check
      if abstract.include?(fn.downcase)
        issues << "#{name}:#{lineno} — function '#{fn}' is abstract noun, use concrete noun"
      end
    end

    # methods on structs (impl blocks with &self)
    if line.match?(/\bimpl\s+(\w+)\b/) && !line.match?(/for\s+\w+/)
      impl_lineno = lineno
    end
    if line.match?(/\bfn\s+\w+\(&\s*self\b/)
      fn = line.match(/fn\s+(\w+)/)[1]
      next if in_trait
      issues << "#{name}:#{lineno} — method '#{fn}' uses &self, should be free function"
    end
  end
end

if issues.empty?
  puts "all fixtures pass semantic convention checks"
else
  issues.each { |i| puts i }
  puts "\n#{issues.size} issues found"
end