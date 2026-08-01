# verify: core-file.md + file-read.md + file-write.md + file-path.md + file-meta.md
require "tempfile"
require "pathname"
require "fileutils"
require_relative "_helper"

TMP = "/tmp/knowledge-test-file"
FileUtils.rm_rf(TMP)
Dir.mkdir(TMP)
File.write("#{TMP}/a.txt", "hello")

# --- file-read.md ---
assert(File.read("#{TMP}/a.txt"), "hello", "File.read")
assert(File.readlines("#{TMP}/a.txt"), ["hello"], "File.readlines")

lines = []
File.foreach("#{TMP}/a.txt") { |l| lines << l }
assert(lines, ["hello"], "File.foreach")

File.open("#{TMP}/a.txt") do |f|
  assert(f.read(3), "hel", "read N bytes")
  assert(f.eof?, false, "eof? false")
  assert(f.read, "lo", "read rest")
  assert(f.eof?, true, "eof? true")
end

# --- file-write.md ---
File.write("#{TMP}/b.txt", "content")
assert(File.read("#{TMP}/b.txt"), "content", "File.write")

File.open("#{TMP}/c.txt", "w") do |f|
  f.puts "line1"
  f.puts "line2"
end
assert(File.readlines("#{TMP}/c.txt"), ["line1\n", "line2\n"], "puts lines")

File.write("#{TMP}/d.txt", "appended", mode: "a")
File.write("#{TMP}/d.txt", " more", mode: "a")
assert(File.read("#{TMP}/d.txt"), "appended more", "append mode")

Tempfile.create do |f|
  f.puts "temp"
  assert(File.exist?(f.path), true, "Tempfile exists")
end

# --- file-path.md ---
pn = Pathname.new("/foo/bar/baz.txt")
assert(pn.basename.to_s, "baz.txt", "Pathname basename")
assert(pn.dirname.to_s, "/foo/bar", "Pathname dirname")
assert(pn.extname, ".txt", "Pathname extname")
assert(File.join("a", "b", "c"), "a/b/c", "File.join")

assert(Dir.exist?(TMP), true, "Dir.exist?")
assert(Dir["#{TMP}/*"].sort, ["#{TMP}/a.txt", "#{TMP}/b.txt", "#{TMP}/c.txt", "#{TMP}/d.txt"].sort, "Dir[]")

# --- file-meta.md ---
File.chmod(0o644, "#{TMP}/a.txt")
stat = File.stat("#{TMP}/a.txt")
assert(stat.size, 5, "stat.size")
assert(stat.mtime.is_a?(Time), true, "stat.mtime")
assert(stat.file?, true, "stat.file?")

FileUtils.rm_rf(TMP)

report "ruby-file"
