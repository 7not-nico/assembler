#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — compare .opencode/package.json declared deps vs actual TypeScript imports
# survey: dep-inventory-survey
# reads package.json, scans _lib/ and tools/ .ts files, classifies each dep as used/declared, unused, or missing

require "json"
require "pathname"

ROOT = Pathname.new(__dir__).join("..", "..", "..", ".opencode").expand_path
PACKAGE_JSON = ROOT.join("package.json")
LIB_DIR = ROOT.join("_lib")
TOOLS_DIR = ROOT.join("tools")
SKIP_DIRS = %w[node_modules .git backups _backups _disabled].freeze
SEPARATOR = "─" * 72

# Pure: extract import package names from .ts file content
ExtractImports = ->(text) {
  text.scan(/import\s+(?:\{[^}]*\}|\*\s+as\s+\w+|\w+)(?:\s*,\s*(?:\{[^}]*\}|\*\s+as\s+\w+|\w+))*\s+from\s+["']([^"']+)["']/).flatten +
  text.scan(/await\s+import\(["']([^"']+)["']\)/).flatten +
  text.scan(/(?:require|import)\s*\(\s*["']([^"']+)["']\s*\)/).flatten
}

# Pure: classify an import path as npm package, relative, or builtin
ClassifyImport = ->(path) {
  return :relative if path.start_with?(".") || path.start_with?("/")
  return :builtin if %w[fs path].include?(path)
  return :builtin_bun if path.start_with?("bun:")
  :npm
}

# Pure: extract top-level package name from a scoped or unscoped npm path
PackageName = ->(path) {
  parts = path.split("/")
  if path.start_with?("@")
    "#{parts[0]}/#{parts[1]}"
  else
    parts[0]
  end
}

# IO: read file, handle missing gracefully
ReadFileSafe = ->(path) {
  File.exist?(path) ? File.read(path) : ""
}

# IO: recursively glob .ts files, skipping SKIP_DIRS
GlobTsFiles = ->(dir) {
  Dir.glob("#{dir}/**/*.ts").reject { |f|
    skip = false
    SKIP_DIRS.each { |sd| skip = true if f.include?("/#{sd}/") }
    skip
  }
}

# --- Main ---

abort("FATAL: #{PACKAGE_JSON} not found") unless File.exist?(PACKAGE_JSON)

pkg = JSON.parse(File.read(PACKAGE_JSON))
declared = (pkg["dependencies"] || {}).merge(pkg["devDependencies"] || {})

puts "=== Dep Inventory: Declared vs Used ==="
puts "  Root: #{ROOT}"
puts "  Declared deps: #{declared.size}"
puts

# Scan all .ts files
all_files = GlobTsFiles.call(LIB_DIR) + GlobTsFiles.call(TOOLS_DIR)
per_file_imports = {}

all_files.each do |fpath|
  rel = Pathname.new(fpath).relative_path_from(ROOT).to_s
  text = ReadFileSafe.call(fpath)
  imports = ExtractImports.call(text)
  next if imports.empty?

  npm_imports = imports.select { |i| ClassifyImport.call(i) == :npm }
                           .map { |i| PackageName.call(i) }
                           .uniq
                           .sort
  per_file_imports[rel] = npm_imports unless npm_imports.empty?
end

# Aggregate used packages
used = Hash.new(0)
per_file_imports.each do |file, pkgs|
  pkgs.each { |p| used[p] += 1 }
end

# Classification
used_declared = declared.keys.select { |d| used.key?(d) }
declared_not_used = declared.keys.reject { |d| used.key?(d) }
used_not_declared = used.keys.reject { |d| declared.key?(d) }

# --- Output ---

puts "#{SEPARATOR}"
puts "1. Used and Declared (#{used_declared.size}):"
puts
used_declared.sort.each do |pkg|
  puts "  ✓ #{pkg.ljust(40)} #{used[pkg]} files"
end

puts
puts "#{SEPARATOR}"
puts "2. Declared but NOT Used (#{declared_not_used.size}):"
puts
if declared_not_used.empty?
  puts "  (none)"
else
  declared_not_used.sort.each do |pkg|
    ver = declared[pkg]
    puts "  ✗ #{pkg.ljust(40)} #{ver}"
  end
  puts
  puts "  Action: review for removal — or verify transitive/runtime need"
end

puts
puts "#{SEPARATOR}"
puts "3. Used but NOT Declared (#{used_not_declared.size}):"
puts
if used_not_declared.empty?
  puts "  (none)"
else
  used_not_declared.sort.each do |pkg|
    puts "  ! #{pkg.ljust(40)} #{used[pkg]} files"
  end
  puts
  puts "  Action: add to package.json dependencies"
end

puts
puts "#{SEPARATOR}"
puts "4. Per-File Import Summary (#{per_file_imports.size} files with npm imports):"
puts

per_file_imports.sort_by { |f, _| f }.each do |file, pkgs|
  puts "  #{file.ljust(50)} #{pkgs.join(", ")}"
end

puts
puts "#{SEPARATOR}"
puts "Summary:"
puts "  Declared deps:        #{declared.size}"
puts "  Used and declared:    #{used_declared.size}"
puts "  Declared not used:    #{declared_not_used.size}"
puts "  Used not declared:    #{used_not_declared.size}"
puts "  Files with npm deps:  #{per_file_imports.size}"
puts "  Total files scanned:  #{all_files.size}"
puts

if declared_not_used.any?
  puts "Candidates for removal: #{declared_not_used.join(", ")}"
end
