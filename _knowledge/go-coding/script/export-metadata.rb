#!/usr/bin/env ruby
# Export function doc comments from Go source files into metadata/.
# Parses each Go file, extracts:
#   - function name, signature, line number
#   - doc comment lines above the function
#   - semantic annotations (GO.SUBJECT, GO.OBJECT, GO.ACTION)
# Run: ruby script/export-metadata.rb

require 'fileutils'

GO_FILES = Dir["calc_*.go"].sort + ["main.go", "calc/core.go", "lib/*.go"]
OUT_DIR = "metadata"
FileUtils.mkdir_p(OUT_DIR)

def extract_functions(content)
  functions = []
  lines = content.lines
  i = 0
  while i < lines.length
    line = lines[i]
    # Match function declarations
    if line =~ /^func\s+(\w+)/
      name = $1
      signature = line.strip
      doc_lines = []
      sem_lines = []
      j = i - 1
      # Collect doc comments above
      while j >= 0 && lines[j] =~ /^\s*\/\/\s*(.*)$/
        doc_lines.unshift($1.strip)
        sem_lines.unshift(lines[j].strip) if lines[j] =~ /GO\.(SUBJECT|OBJECT|ACTION)/
        j -= 1
      end
      # Collect GO.ACTION etc. inside the function body
      body = ""
      depth = 0
      k = i
      while k < lines.length
        body += lines[k]
        depth += lines[k].count("{") - lines[k].count("}")
        break if depth <= 0 && k > i
        k += 1
      end
      body.scan(/GO\.(SUBJECT|OBJECT|ACTION)/).each { |m| sem_lines << "GO.#{m[0]}" }
      functions << {
        name: name,
        signature: signature,
        line: i + 1,
        doc: doc_lines,
        semantic: sem_lines.uniq
      }
    end
    i += 1
  end
  functions
end

GO_FILES.each do |file|
  next unless File.exist?(file)
  content = File.read(file)
  functions = extract_functions(content)
  next if functions.empty?

  out_file = File.join(OUT_DIR, file.gsub(/[\/.]/, "_").sub(/_go$/, ".md"))
  out = []
  out << "# #{file} — function metadata"
  out << ""
  out << "Functions: #{functions.size}"
  out << ""
  functions.each do |fn|
    out << "## #{fn[:name]} (line #{fn[:line]})"
    out << ""
    out << "```go"
    out << fn[:signature]
    out << "```"
    out << ""
    unless fn[:doc].empty?
      out << "Doc:"
      fn[:doc].each { |d| out << "- #{d}" }
      out << ""
    end
    unless fn[:semantic].empty?
      out << "Semantic annotations: #{fn[:semantic].join(', ')}"
      out << ""
    end
  end
  File.write(out_file, out.join("\n"))
  puts "#{file} → #{out_file} (#{functions.size} functions)"
end
