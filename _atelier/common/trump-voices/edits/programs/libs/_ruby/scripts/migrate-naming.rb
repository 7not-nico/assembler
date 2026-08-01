#!/usr/bin/env ruby
# Migrate all snippet WAV/YAML files and DB to {DOMAIN}.{SUBDOMAIN}.{SEQ}.WAV

require "yaml"
require "sqlite3"
require "fileutils"

ROOT = File.join(__dir__, "..", "..", "..")
DB = File.join(ROOT, ".opencode", "voices.db")
VDB = File.join(ROOT, ".opencode", "voices-vector.db")
TIERS = ["objects-crude", "objects-revised"]

def new_id(id, subject)
  has_seq = id.match(/^(.+?)-(\d{3})$/)
  video_part = has_seq ? has_seq[1] : id
  seq = has_seq ? has_seq[2] : nil
  subj = subject.tr("-", ".")
  video = video_part.tr("-", ".")
  if video.start_with?(subj)
    sub = video[subj.length..].sub(/^\./, "")
  else
    last = subj.split(".").last
    if last && video.start_with?(last + ".")
      sub = video[(last.length + 1)..]
    else
      sub = video
    end
  end
  [subj, sub, seq].compact.join(".").upcase
end

puts "Renaming files..."
TIERS.each { |tier|
  dir = File.join(ROOT, tier)
  next unless Dir.exist?(dir)
  Dir.children(dir).each { |video|
    next if video == "yaml"
    ydir = File.join(dir, video, "yaml")
    next unless Dir.exist?(ydir)
    Dir.children(ydir).each { |yf|
      next unless yf.end_with?(".yaml")
      id = yf.sub(/\.yaml$/, "")
      meta = YAML.safe_load(File.read(File.join(ydir, yf)))
      subj = meta["subject"] || id
      nid = new_id(id, subj)
      fext = meta["file"]&.end_with?(".mp3") ? "mp3" : "WAV"
      old_wav = File.join(dir, video, "#{id}.#{fext.sub(/mp3/, "mp3")}")
      old_yaml = File.join(ydir, yf)
      new_name = "#{nid}.#{fext == "mp3" ? "MP3" : "WAV"}"
      new_wav = File.join(dir, new_name)
      new_yaml = File.join(dir, "#{nid}.#{fext == "mp3" ? "MP3" : "WAV"}.yaml")

      FileUtils.mv(old_wav, new_wav) if File.exist?(old_wav)
      FileUtils.mv(old_yaml, new_yaml)
      puts "  #{id} -> #{new_name}"
    }
  }
}

puts "\nUpdating DB..."
YAML_DIRS = TIERS.map { |t| File.join(ROOT, t) }
db = SQLite3::Database.new(DB)
vdb = SQLite3::Database.new(VDB)

# Read all existing entries with old IDs
old_rows = db.execute("SELECT id, subject, filepath FROM snippets")
id_map = old_rows.map { |id, subj, fp| [id, new_id(id, subj)] }
id_map.each { |old_id, new_id|
  db.execute("UPDATE snippets SET id = ?, filepath = ? WHERE id = ?", [new_id, "#{new_id}.WAV", old_id])
  vdb.execute("UPDATE embeddings SET entity_id = ? WHERE entity_id = ?", [new_id, old_id])
  vdb.execute("UPDATE fts_entities SET entity_id = ? WHERE entity_id = ?", [new_id, old_id])
}

db.close
vdb.close

puts "\nCleaning empty video dirs..."
TIERS.each { |tier|
  dir = File.join(ROOT, tier)
  Dir.children(dir).each { |e|
    p = File.join(dir, e)
    FileUtils.rm_rf(p) if File.directory?(p) && e != "yaml"
  }
}

puts "\nDone. #{id_map.length} entries migrated."
