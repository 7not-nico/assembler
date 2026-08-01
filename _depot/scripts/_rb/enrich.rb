# exports: MetadataParse, MetadataFetch, ImageUpdate
# ring: 0 (PURE) — shells to sqlite3 CLI for updates

DB = "assets/assets.db"

# Parse metadata from page text
# Input: raw page text, looks like "LABEL\nvalue\n"
# Returns hash with string keys, nil for missing
MetadataParse = ->(text) {
  fields = {
    "identifier" => "LOCAL IDENTIFIER",
    "creator" => "CREATOR",
    "work_type" => "WORK TYPE",
    "description" => "DESCRIPTION",
    "medium" => "MEDIUM",
    "subjects" => "SUBJECTS",
    "date_text" => "DATE",
    "phys_dimensions" => "MEASUREMENTS",
  }
  result = {}
  fields.each do |key, label|
    idx = text.index(label)
    if idx
      val_start = idx + label.length
      rest = text[val_start..]
      val = rest.lines.map(&:strip).reject(&:empty?).first
      result[key] = val unless val.nil? || val.empty?
    end
  end
  # Extract Part of / collection info
  if text.include?("Open: Wellcome Collection")
    result["collection"] = "Open: Wellcome Collection"
  end
  # Extract wellcome_id from wellcomecollection.org URL in page
  wm = text.match(%r{wellcomecollection\.org/works/([a-z0-9]+)}i)
  result["wellcome_id"] = wm[1] if wm
  # Also set identifier if found
  if result["identifier"] && !result["wellcome_id"]
    # Map via wellcome API possible but not here
  end
  result
}

# Build UPDATE SQL for non-nil fields only
UpdateSql = ->(id, meta) {
  skip = %w[wellcome_id]
  sets = meta.select { |k, v| !skip.include?(k) && !v.nil? && !v.empty? }
             .map { |k, v| "#{k}='#{v.gsub("'", "''")}'" }
  return nil if sets.empty?
  "UPDATE images SET #{sets.join(",")} WHERE id='#{id.gsub("'", "''")}';"
}

# Insert wellcome URL into urls table
WellcomeUrlInsert = ->(id, wellcome_id) {
  return unless wellcome_id
  url = "https://wellcomecollection.org/works/#{wellcome_id.downcase}"
  url_id = "url-#{id}-wellcome"
  sql = "INSERT OR IGNORE INTO urls VALUES ('#{url_id.gsub("'","''")}','#{id.gsub("'","''")}','wellcome','#{url.gsub("'","''")}');"
  system("sqlite3", DB, sql)
}

# Execute update
ImageUpdate = ->(id, meta) {
  sql = UpdateSql.call(id, meta)
  system("sqlite3", DB, sql) if sql
  WellcomeUrlInsert.call(id, meta["wellcome_id"]) if meta["wellcome_id"]
}

# Batch update from array of {id:, meta:{}}
BatchUpdate = ->(entries) {
  count = 0
  entries.each do |entry|
    ImageUpdate.call(entry["id"], entry["meta"])
    count += 1
  end
  system("sqlite3", DB, "DELETE FROM images_fts; INSERT INTO images_fts (id, title, source, identifier, domain) SELECT id, title, source, identifier, domain FROM images;")
  count
}
