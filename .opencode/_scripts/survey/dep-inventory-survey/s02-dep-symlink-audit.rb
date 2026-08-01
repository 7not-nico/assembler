#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — audit all node_modules symlinks against root canonical store
# survey: dep-inventory-survey
# scans project root for node_modules dirs, verifies each is symlink (except root), resolves target

require "pathname"
require "fileutils"

ROOT = Pathname.new(__dir__).join("..", "..", "..").expand_path
ROOT_NM = ROOT.join(".opencode", "node_modules")
EXPECTED_PACKAGES = %w[@opencode-ai/plugin js-yaml].freeze
MAX_DEPTH = 6
SKIP_DIRS = %w[.git backups _backups node_modules].freeze
SEPARATOR = "─" * 72

# Pure: compute relative target from a subproject node_modules back to root
ComputeTarget = ->(nm_path) {
  parent = nm_path.dirname
  depth = parent.relative_path_from(ROOT).to_s.split("/").size
  ups = Array.new(depth, "..").join("/")
  "#{ups}/.opencode/node_modules"
}

# IO: recursively find all node_modules directories, respecting MAX_DEPTH
FindNodeModules = ->(dir, depth = 0) {
  return [] if depth > MAX_DEPTH
  results = []
  Dir.children(dir).each do |entry|
    full = dir.join(entry)
    next unless full.directory?
    if entry == "node_modules" && (full.directory? || full.symlink?)
      results << full
    elsif !SKIP_DIRS.include?(entry)
      results.concat(FindNodeModules.call(full, depth + 1))
    end
  end
  results
}

# IO: check if a path is a symlink
SymlinkQ = ->(path) { File.symlink?(path.to_s) }

# IO: read symlink target
Readlink = ->(path) { File.readlink(path.to_s) }

# IO: resolve real path
Realpath = ->(path) { File.realpath(path.to_s) }

# --- Main ---

abort("FATAL: root node_modules not found at #{ROOT_NM}") unless ROOT_NM.directory?

root_target = ROOT_NM.realpath.to_s
all_nm = FindNodeModules.call(ROOT)
all_nm = all_nm.sort_by { |p| p.relative_path_from(ROOT).to_s }

puts "=== Node Modules Symlink Audit ==="
puts "  Root: #{ROOT}"
puts "  Canonical: #{ROOT_NM}"
puts "  Resolves to: #{root_target}"
puts "  Projects scanned: #{all_nm.size}"
puts

pass = 0
fail = 0
results = []

all_nm.each do |nm_path|
  rel = nm_path.relative_path_from(ROOT).to_s
  is_root = rel == ".opencode/node_modules"

  if is_root
    if SymlinkQ.call(nm_path)
      target = Readlink.call(nm_path)
      results << { rel: rel, status: "FAIL", detail: "Root node_modules is a symlink; expected real directory → #{target}" }
      fail += 1
    else
      pkg_status = EXPECTED_PACKAGES.map { |p|
        nm_path.join(p).directory? ? "ok" : "MISSING"
      }
      detail = "Real directory (not symlink). Packages: #{EXPECTED_PACKAGES.zip(pkg_status).map { |a, b| "#{a}=#{b}" }.join(", ")}"
      results << { rel: rel, status: "PASS", detail: detail }
      pass += 1
    end
  elsif !SymlinkQ.call(nm_path)
    target = ComputeTarget.call(nm_path)
    results << { rel: rel, status: "FAIL", detail: "Real directory; expected symlink to .opencode/node_modules. Suggested: #{target}" }
    fail += 1
  else
    link_text = Readlink.call(nm_path)
    begin
      resolved = Realpath.call(nm_path)
    rescue Errno::ENOENT
      target = ComputeTarget.call(nm_path)
      results << { rel: rel, status: "FAIL", detail: "Broken symlink: #{link_text}. Suggested: #{target}" }
      fail += 1
      next
    end
    if resolved == root_target
      results << { rel: rel, status: "PASS", detail: "symlink → #{link_text}" }
      pass += 1
    else
      target = ComputeTarget.call(nm_path)
      results << { rel: rel, status: "FAIL", detail: "symlink → #{link_text} resolves → #{resolved}. Expected → #{root_target}. Suggested: #{target}" }
      fail += 1
    end
  end
end

# Output
results.each do |r|
  status_char = r[:status] == "PASS" ? "✓" : "✗"
  puts "#{status_char} #{r[:rel]}"
  puts "     #{r[:detail]}"
  puts
end

puts SEPARATOR
puts "Total: #{all_nm.size} | PASS: #{pass} | FAIL: #{fail}"

if fail > 0
  puts
  puts "Repair command:"
  puts "  bun run .opencode/tools/verify-deps.ts --repair"
end
