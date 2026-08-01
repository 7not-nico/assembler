# verify: file-open-block.md + file-foreach-enumerator.md + file-io-functional.md
require_relative "_helper"
require "tempfile"
require "tmpdir"

tmp = Dir.mktmpdir("test-file-fp")

# --- file-open-block.md ---
path = "#{tmp}/hello.txt"
File.write(path, "line1\nline2\nline3\n")

result = File.open(path) { |f| f.read }
assert(result, "line1\nline2\nline3\n", "open block read")

lines = File.open(path) { |f| f.readlines.map(&:strip) }
assert(lines, ["line1", "line2", "line3"], "open block readlines map")

# open without block
f = File.open(path)
assert(f.read, "line1\nline2\nline3\n", "open without block")
f.close

# binary mode
binpath = "#{tmp}/data.bin"
File.write(binpath, "\x00\x01\x02")
data = File.open(binpath, 'rb') { |f| f.read }
assert(data.bytesize, 3, "binary read bytesize")

# --- file-foreach-enumerator.md ---
lines = []
File.foreach(path) { |l| lines << l.strip }
assert(lines, ["line1", "line2", "line3"], "foreach block")

selected = File.foreach(path).map(&:strip).reject { |l| l == "line2" }
assert(selected, ["line1", "line3"], "foreach enumerator chain")

lazy = File.foreach(path).lazy.select { |l| l.include?("line") }.first(2)
assert(lazy, ["line1\n", "line2\n"], "foreach lazy")

# chomp option
File.write("#{tmp}/chomp.txt", "a\nb\nc\n")
chopped = File.foreach("#{tmp}/chomp.txt", chomp: true).to_a
assert(chopped, ["a", "b", "c"], "foreach chomp: true")

# --- file-io-functional.md ---
src = "#{tmp}/src.txt"
dst = "#{tmp}/dst.txt"
File.write(src, "hello world\nsecond line\n")

# read transform write
content = File.read(src).upcase
File.write(dst, content)
assert(File.read(dst), "HELLO WORLD\nSECOND LINE\n", "read-transform-write")

# copy_stream
IO.copy_stream(src, "#{tmp}/copy.txt")
assert(File.read("#{tmp}/copy.txt"), "hello world\nsecond line\n", "copy_stream")

# Tempfile
content = nil
Tempfile.create('test') do |f|
  f.write("temp data")
  f.rewind
  content = f.read
end
assert(content, "temp data", "tempfile create block")

# readlines chain
uppercased = File.readlines(src).map(&:strip).map(&:upcase)
assert(uppercased, ["HELLO WORLD", "SECOND LINE"], "readlines chain")

# cleanup
FileUtils.rm_rf(tmp) rescue nil

report "ruby-file-functional"
