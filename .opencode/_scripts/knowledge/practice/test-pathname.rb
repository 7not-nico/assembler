# verify: pathname-patterns.md
require_relative "_helper"
require "pathname"
require "tmpdir"

tmp = Dir.mktmpdir("test-pathname")

# --- Pathname join ---
base = Pathname.new(tmp)
sub = base.join("sub", "dir")
assert(sub.to_s, "#{tmp}/sub/dir", "Pathname join")

# --- realpath ---
FileUtils.mkdir_p(sub.to_s) rescue nil
real = sub.realpath
assert(real.to_s.end_with?("sub/dir"), true, "realpath resolution")

# --- File.basename without extension ---
path = "/some/path/TERM.FOO.BAR.md"
assert(File.basename(path, ".md"), "TERM.FOO.BAR", "basename strip .md")
assert(File.basename(path), "TERM.FOO.BAR.md", "basename with extension")

# --- Dir glob ---
File.write("#{tmp}/a.md", "a")
File.write("#{tmp}/b.txt", "b")
Dir.mkdir("#{tmp}/nested") rescue nil
Dir.mkdir("#{tmp}/empty_dir") rescue nil
File.write("#{tmp}/nested/c.md", "c")

globbed = Dir["#{tmp}/**/*.md"].sort.map { |f| File.basename(f) }
assert(globbed, ["a.md", "c.md"], "Dir recursive glob **/*.md")

# --- Dir children ---
children = Dir.children(tmp).sort
assert(children.include?("a.md"), true, "Dir children includes a.md")
assert(children.include?("nested"), true, "Dir children includes nested")

# --- Dir exist? / empty? ---
assert(Dir.exist?(tmp), true, "Dir.exist? true")
assert(Dir.exist?("/nonexistent_path_xyz"), false, "Dir.exist? false")
assert(Dir.empty?("#{tmp}/empty_dir"), true, "Dir.empty? for empty dir")
assert(Dir.empty?(tmp), false, "Dir.empty? for non-empty dir")

# cleanup
FileUtils.rm_rf(tmp) rescue nil

report "ruby-pathname"
