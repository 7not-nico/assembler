#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify no stale refs remain after archive
# survey: archive-stale-entities

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/frontmatter"
require_relative "../../_rb/report"

ARCHIVE_PATH = ROOT.join("_scripts", "archive")
EXCLUDE_DIRS = %w[archive archives _backups backups].freeze

STALE_IDS = [
  "PROT.META.ENTITY.DISTINCTION",
  "RUL.PATTERN.VS.TERM",
  "pattern-vs-term"
].freeze

violations = []

# Scan entity directories
EntityTypes.each do |type|
  next if EXCLUDE_DIRS.include?(type)
  Dir[EntityGlob.call(type)].each do |path|
    text = File.read(path)
    rel = Pathname.new(path).relative_path_from(ROOT).to_s
    STALE_IDS.each do |sid|
      if text.include?(sid)
        lines = text.lines.select { |l| l.include?(sid) }
        lines.each do |l|
          violations << [rel, sid, l.strip]
        end
      end
    end
  end
end

# Scan rules (non-archived)
Dir[RULES.join("*.md")].each do |path|
  next if EXCLUDE_DIRS.include?(File.basename(File.dirname(path)))
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  STALE_IDS.each do |sid|
    if text.include?(sid)
      lines = text.lines.select { |l| l.include?(sid) }
      lines.each { |l| violations << [rel, sid, l.strip] }
    end
  end
end

# Scan rules YAML
Dir[RULES.join("yamls", "*.yaml")].each do |path|
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  STALE_IDS.each do |sid|
    if text.include?(sid)
      lines = text.lines.select { |l| l.include?(sid) }
      lines.each { |l| violations << [rel, sid, l.strip] }
    end
  end
end

# Scan commands
Dir[COMMANDS.join("*.md")].each do |path|
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  STALE_IDS.each do |sid|
    if text.include?(sid)
      lines = text.lines.select { |l| l.include?(sid) }
      lines.each { |l| violations << [rel, sid, l.strip] }
    end
  end
end

# Scan skills
Dir[SKILLS.join("*", "SKILL.md")].each do |path|
  text = File.read(path)
  rel = Pathname.new(path).relative_path_from(ROOT).to_s
  STALE_IDS.each do |sid|
    if text.include?(sid)
      lines = text.lines.select { |l| l.include?(sid) }
      lines.each { |l| violations << [rel, sid, l.strip] }
    end
  end
end

# Verify archive destination
archived = Dir.glob(ARCHIVE_PATH.join("*.{md,yaml}")).map { |p| File.basename(p) }

puts "=== Archive Verification ==="
puts
puts "Archive directory: #{ARCHIVE_PATH}"
puts "Archived files: #{archived.size}"

CANDIDATE_FILES = %w[
  PROT.META.ENTITY.DISTINCTION.md
  pattern-vs-term.md
  pattern-vs-term.yaml
  PROT.CONTENT.GLOSSARY.md
  PROT.META.CATEGORY.VIEW.md
]

CANDIDATE_FILES.each do |f|
  present = archived.include?(f)
  status = present ? "ARCHIVED" : "MISSING"
  puts "  #{f.ljust(45)} #{status}"
end

puts
puts "=== Stale References Remaining ==="
puts

if violations.empty?
  puts "  CLEAN — 0 stale references found in active files"
else
  puts "  VIOLATIONS (#{violations.size}):"
  puts
  puts Table.call(
    violations.map { |v| [v[0], v[1], v[2]] },
    %w[File Stale-ID Line]
  )
  puts
  puts "  Action required: update these references to SPEC.META.ENTITY.DISTINCTION"
end

puts
puts "=== Archive entity check ==="
puts
old_archive_dir = ROOT.join(".opencode", "entities", "archives")
if old_archive_dir.exist?
  remaining = Dir.children(old_archive_dir.to_s)
  if remaining.empty?
    puts "  entities/archives/ — EMPTY (can remove)"
  else
    puts "  entities/archives/ — #{remaining.size} file(s) remain:"
    remaining.each { |f| puts "    #{f}" }
  end
else
  puts "  entities/archives/ — directory does not exist"
end
