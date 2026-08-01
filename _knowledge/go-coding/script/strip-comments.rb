#!/usr/bin/env ruby
# Strip all comments from Go source files.
# Comments are preserved in metadata/ (see extract-comments.rb).
# Run: ruby script/strip-comments.rb

GO_FILES = Dir["calc_*.go"].sort + ["main.go", "calc/core.go", "lib/*.go"]

def strip_comments(content)
  lines = content.lines
  out = []
  in_block = false

  lines.each do |line|
    # Track block comment state
    stripped = line.dup

    if in_block
      # Inside a block comment — look for closing */
      if stripped =~ %r{\*/}
        stripped = stripped.sub(%r{.*?\*/}, "")
        in_block = false
      else
        stripped = ""
      end
    end

    unless in_block
      # Remove block comments that start and end on the same line
      stripped = stripped.gsub(%r{/\*.*?\*/}, "")
      # Check if a block comment starts on this line
      if stripped =~ %r{/\*}
        stripped = stripped.sub(%r{/\*.*\z}m, "")
        in_block = true
      end
      # Remove line comments (from // to end of line, keep newline)
      stripped = stripped.sub(%r{//.*(?=\n|\z)}, "")
    end

    # Preserve meaningful lines (code, blank lines)
    out << (stripped.empty? ? "" : stripped.rstrip)
  end

  out.join("\n")
end

GO_FILES.each do |file|
  next unless File.exist?(file)
  content = File.read(file)
  stripped = strip_comments(content)
  File.write(file, stripped)
  puts "#{file}: stripped (#{content.length - stripped.length} bytes removed)"
end
