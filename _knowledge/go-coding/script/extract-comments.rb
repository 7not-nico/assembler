#!/usr/bin/env ruby
# Extract ALL comments from Go source files into metadata/.
# Captures:
#   - file header comments (semantic maps)
#   - function doc comments
#   - inline GO.SUBJECT/GO.OBJECT/GO.ACTION annotations
#   - line numbers for each comment
# Run: ruby script/extract-comments.rb

require 'fileutils'

GO_FILES = Dir["calc_*.go"].sort + ["main.go", "calc/core.go", "lib/*.go"]
OUT_DIR = "metadata"
FileUtils.mkdir_p(OUT_DIR)

def extract_comments(content)
  comments = []
  lines = content.lines
  lines.each_with_index do |line, idx|
    # Line comment
    if line =~ /^\s*\/\/\s*(.*)$/
      comments << { line: idx + 1, text: $1.strip, kind: "line" }
    end
    # Block comment
    if line =~ /\/\*/
      block = line
      j = idx
      while j < lines.length && !lines[j].include?("*/")
        j += 1
        block += lines[j]
      end
      comments << { line: idx + 1, text: block.strip.gsub(/\n/, " "), kind: "block" }
    end
  end
  comments
end

GO_FILES.each do |file|
  next unless File.exist?(file)
  content = File.read(file)
  comments = extract_comments(content)
  next if comments.empty?

  # Split into header comments (before first func) and body comments
  first_func = content.index(/^func /) || content.length
  header = comments.select { |c| c[:line] * 1.0 < first_func / (content.lines.length / content.lines.length.to_f) && c[:line] < content[0...first_func].lines.length + 1 }
  body = comments.reject { |c| c[:line] < content[0...first_func].lines.length + 1 }

  out_file = File.join(OUT_DIR, file.gsub(/[\/.]/, "_").sub(/_go$/, ".md"))
  out = []
  out << "# #{file} — all comments"
  out << ""
  out << "Total comments: #{comments.size}"
  out << ""
  out << "## Header"
  out << ""
  header.each { |c| out << "- L#{c[:line]}: #{c[:text]}" }
  out << ""
  out << "## Body"
  out << ""
  body.each { |c| out << "- L#{c[:line]}: #{c[:text]}" }
  File.write(out_file, out.join("\n"))
  puts "#{file} → #{out_file} (#{comments.size} comments)"
end
