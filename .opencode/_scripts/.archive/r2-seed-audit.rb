#!/usr/bin/env ruby
# ring: 2 (LOCAL-READ) — validates SQL seed files per PROT.SCHEMA.SEED.FORMAT
# depends-on: _rb/paths, _rb/report, _rb/rings

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/report"
require_relative "_rb/rings"

SQL_DIR = File.join(__dir__, "schema")
violations = []

Dir.glob(File.join(SQL_DIR, "*.sql")).sort.each do |path|
  basename = File.basename(path)
  text = File.read(path)
  lines = text.lines

  mode_line = lines.grep(/^-- mode:/).first
  mode = mode_line&.sub(/^-- mode:\s*/, "")&.strip

  m = basename.match(/\A(\d+)-/)
  prefix = m ? m[1] : nil
  is_seed = prefix && mode != "ddl"

  unless mode_line
    violations << [basename, "mode", "missing", "file must declare -- mode:"]
  end

  unless mode == "ddl" || mode == "append" || mode == "upsert"
    violations << [basename, "mode", mode || "(none)", "must be ddl, append, or upsert"]
  end

  has_insert = lines.any? { |l| l.match?(/\AINSERT\s/) }
  unless has_insert
    violations << [basename, "sql", "no INSERT", "seed file must have INSERT statement"] if is_seed
  end

  has_replace = lines.any? { |l| l.match?(/\AINSERT OR REPLACE/) }
  if is_seed && !has_replace
    violations << [basename, "sql", "INSERT without REPLACE", "seed file must use INSERT OR REPLACE"]
  end

  if mode == "ddl"
    if prefix
      violations << [basename, "prefix", basename, "DDL must not have numeric prefix"]
    end
    unless lines.any? { |l| l.match?(/\ACREATE\s/) }
      violations << [basename, "sql", "no CREATE", "DDL must contain CREATE TABLE"]
    end
  end

  if mode == "append" && prefix != "00"
    violations << [basename, "prefix", prefix, "append mode must use 00- prefix"]
  end

  if mode == "upsert" && prefix == "00"
    violations << [basename, "prefix", prefix, "upsert mode must use 01+ prefix"]
  end

  entity_ids = text.scan(/INSERT OR REPLACE INTO entity_types.*?VALUES\s*\((.*?)\)/m).flatten
  entity_ids.each do |vals|
    eid = vals.split(",").first&.strip&.gsub("'", "")
    ring_info = TypeToRing.call(eid)
    if ring_info && prefix
      expected_prefix = format("%02d", ring_info[:ring])
      if prefix != expected_prefix && prefix != "00"
        violations << [basename, "ring", "#{eid} R#{ring_info[:ring]} prefix=#{prefix}",
          "expected prefix #{expected_prefix} for R#{ring_info[:ring]}"]
      end
    end
  end
end

if violations.empty?
  puts "ok — #{Dir.glob(File.join(SQL_DIR, "*.sql")).size} seed files, 0 violations"
else
  puts "seed audit violations (#{violations.size}):"
  puts Table.call(violations, %w[File Field Value Problem])
end
