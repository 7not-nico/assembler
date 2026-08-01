#!/usr/bin/env ruby
# ring: 0 (PURE) — checks no directory is empty
# depends-on: _rb/report

require_relative "_rb/loader"
require_relative "_rb/report"

DIRS = %w[
  archive composition dataflow decision docs equivalence
  guides _rb report/conclusions report/errors report/walkthroughs
  spec template todo
]

empty = []

DIRS.each do |dir|
  path = File.join(__dir__, dir)
  unless Dir.exist?(path)
    empty << [dir, "missing", ""]
    next
  end
  entries = Dir.children(path).reject { |e| e.start_with?(".") }
  if entries.empty?
    empty << [dir, "empty", "no files"]
  end
end

if empty.empty?
  puts "ok — #{DIRS.size} directories, 0 empty"
else
  puts "empty or missing directories (#{empty.size}):"
  puts Table.call(empty, %w[Directory Status Note])
end
