#!/usr/bin/env ruby
# Rename all snippet WAV/YAML files and DB entries to {DOMAIN}.{SUBDOMAIN}.{SEQ}.WAV
# No hyphens — all dots and uppercase

require "yaml"
require "sqlite3"
require "fileutils"

PROJECT_DIR = File.join(__dir__, "..", "..", "..")
DB_PATH = File.join(PROJECT_DIR, ".opencode", "voices.db")
VDB_PATH = File.join(PROJECT_DIR, ".opencode", "voices-vector.db")
TIERS = ["objects-crude", "objects-revised"]

def new_id(id, subject)
  has_seq = id.match(/^(.+?)-(\d{3})$/)
  video_part = has_seq ? has_seq[1] : id
  seq = has_seq ? has_seq[2] : nil

  subject_dots = subject.gsub("-", ".")
  video_dots = video_part.gsub("-", ".")

  if video_dots.start_with?(subject_dots)
    subdomain = video_dots[subject_dots.length..]
    subdomain = subdomain.sub(/^\./, "")
  else
    subdomain = video_dots
  end

  parts = [subject_dots, subdomain, seq].compact
  parts.join(".").upcase
end

def new_basename(id, subject, ext)
  "#{new_id(id, subject)}.#{ext}"
end

puts "=== Phase 1: Map all entries ==="
db = SQLite3::Database.new(DB_PATH)

all = db.execute("SELECT id, subject, filepath FROM snippets ORDER BY id")
puts "Total DB entries: #{all.length}"

mapping = all.map { |id, subject, filepath|
  new_name = new_id(id, subject)
  ext = filepath.end_with?(".mp3") ? "MP3" : "WAV"
  new_basename = "#{new_name}.#{ext}"
  [id, subject, filepath, new_name, new_basename]
}

# Print sample
mapping.first(10).each { |id, sub, fp, newn, newfn|
  puts "  #{id} → #{newfn}"
}
puts "  ..."

puts ""
puts "=== Phase 2: Rename files ==="
TIERS.each { |tier|
  dir = File.join(PROJECT_DIR, tier)
  next unless Dir.exist?(dir)

  Dir.entries(dir).each { |video|
    next if video == "." || video == ".." || video == "yaml"

    yaml_dir = File.join(dir, video, "yaml")
    next unless Dir.exist?(yaml_dir)

    Dir.entries(yaml_dir).each { |yaml_file|
      next unless yaml_file.end_with?(".yaml")
      next if yaml_file == "." || yaml_file == ".."

      yaml_path = File.join(yaml_dir, yaml_file)
      raw = File.read(yaml_path)
      meta = YAML.safe_load(raw)
      id = yaml_file.sub(/\.yaml$/, "")
      subject = meta["subject"] || id

      new_name = new_id(id, subject)
      old_ext = meta["file"]&.end_with?(".mp3") ? "mp3" : "wav"
      new_ext = "WAV"
      new_basename = "#{new_name}.#{new_ext}"

      # Rename WAV
      old_wav = File.join(dir, video, "#{id}.#{old_ext}")
      if File.exist?(old_wav)
        new_wav = File.join(PROJECT_DIR, tier, new_basename)
        FileUtils.mv(old_wav, new_wav)
        puts "  mv #{old_wav} → #{new_wav}"
      end

      # Rename YAML
      new_yaml = File.join(PROJECT_DIR, tier, "#{new_basename}.yaml")
      FileUtils.mv(yaml_path, new_yaml)
      puts "  mv #{yaml_path} → #{new_yaml}"

      # Also update the YAML file content
      meta["file"] = "#{new_basename}"
      File.write(new_yaml, YAML.dump(meta))
    }
  }
}

puts ""
puts "=== Phase 3: Update DB ==="
mapping.each { |id, subject, filepath, new_name, new_basename|
  new_fp = new_basename
  db.execute("UPDATE snippets SET id = ?, filepath = ? WHERE id = ?", [new_name, new_fp, id])
}

db.close

puts ""
puts "=== Phase 4: Update vector DB entity ids ==="
vdb = SQLite3::Database.new(VDB_PATH)
all2 = db.execute("SELECT id FROM snippets ORDER BY id")
# Re-read from updated DB
db2 = SQLite3::Database.new(DB_PATH)
updated = db2.execute("SELECT id, subject, filepath FROM snippets ORDER BY id")
updated.each { |new_id, subject, filepath|
  # Find old id from mapping
  old_entry = mapping.find { |m| m[3] == new_id }
  next unless old_entry
  old_id = old_entry[0]
  vdb.execute("UPDATE embeddings SET entity_id = ? WHERE entity_id = ?", [new_id, old_id])
  vdb.execute("UPDATE fts_entities SET entity_id = ? WHERE entity_id = ?", [new_id, old_id])
}
db2.close
vdb.close

puts ""
puts "=== Phase 5: Clean up empty video dirs ==="
TIERS.each { |tier|
  dir = File.join(PROJECT_DIR, tier)
  next unless Dir.exist?(dir)
  Dir.entries(dir).each { |entry|
    next if entry == "." || entry == ".." || entry == "yaml"
    path = File.join(dir, entry)
    if File.directory?(path) && Dir.empty?(path)
      Dir.rmdir(path)
      puts "  rmdir #{path}"
    end
  }
}

puts ""
puts "Done."
