#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — flags stale cross-references in .md files
# depends-on: _rb/paths, _rb/report

require_relative "_rb/loader"
require_relative "_rb/report"

ROOT = Pathname.new(__dir__)

existing_rb = Dir.glob(ROOT.join("*.rb")).map { |p| File.basename(p) }.to_set
existing_lib = Dir.glob(ROOT.join("_rb", "*.rb")).map { |p| File.basename(p) }.to_set
existing_dirs = Dir.children(ROOT.to_s)
  .select { |e| File.directory?(ROOT.join(e)) && !e.start_with?(".") }
  .to_set

violations = []

Dir.glob(ROOT.join("**", "*.md")).each do |path|
  next if path.include?("/archive/")
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s

  text.scan(%r{`(_rb/[a-z]+\.rb)`}).each do |(lib_ref)|
    unless existing_lib.include?(File.basename(lib_ref))
      violations << [rel, "lib", lib_ref, "does not exist"]
    end
  end

  text.scan(%r{`(r[1-7]-[a-z][a-z0-9-]+\.rb)`}).each do |(script_ref)|
    unless existing_rb.include?(script_ref)
      violations << [rel, "script", script_ref, "does not exist"]
    end
  end

  text.scan(%r{`r[1-7]-[a-z][a-z0-9-]+`}).each do |m|
    script = "#{m}.rb"
    unless existing_rb.include?(script)
      violations << [rel, "script", m, "does not exist (no .rb file)"]
    end
  end

  text.scan(%r{`(?:scripts/)?([a-z][a-z0-9/_-]+)/`}).each do |(dir_ref)|
    dir_ref = dir_ref.sub(%r{^scripts/}, "")
    next if dir_ref.start_with?(".")
    next if dir_ref.include?("..")
    full_path = ROOT.join(dir_ref)
    unless full_path.exist? && full_path.directory?
      violations << [rel, "directory", "#{dir_ref}/", "referenced dir does not exist"]
    end
  end

  text.scan(%r{\]\s*\((\.\.?/[^)]+)\)}).each do |(link)|
    target = link.split("#").first
    abs = File.expand_path(File.join(File.dirname(File.join(ROOT, rel)), target))
    unless File.exist?(abs)
      violations << [rel, "link", link, "file not found"]
    end
  end
end

if violations.empty?
  puts "ok — #{existing_rb.size} scripts, #{existing_lib.size} libs, #{existing_dirs.size} dirs — 0 stale refs"
else
  puts "stale references (#{violations.size}):"
  puts Table.call(violations, %w[File Type Reference Problem])
end
