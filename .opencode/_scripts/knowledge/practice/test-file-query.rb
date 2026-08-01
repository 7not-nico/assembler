# verify: file-query.md
require "fileutils"
require_relative "_helper"

TMP = "/tmp/knowledge-test-file-query"
FileUtils.rm_rf(TMP)
Dir.mkdir(TMP)
File.write("#{TMP}/a.txt", "hello")

assert(File.exist?("#{TMP}/a.txt"), true, "exist?")
assert(File.file?("#{TMP}/a.txt"), true, "file?")
assert(File.directory?(TMP), true, "directory?")
assert(File.readable?("#{TMP}/a.txt"), true, "readable?")
assert(File.size("#{TMP}/a.txt"), 5, "size")
assert(File.zero?("#{TMP}/a.txt"), false, "zero?")
assert(File.fnmatch?("*.txt", "a.txt"), true, "fnmatch?")

FileUtils.rm_rf(TMP)

report "ruby-file-query"
