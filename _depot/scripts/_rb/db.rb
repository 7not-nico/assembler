# exports: ImageInsert, UrlInsert, FtsRebuild, ImageExists, ImageCount, DomainCount
# ring: 0 (PURE) — shells to sqlite3 CLI
# depends-on: _rb/loader

DB = "assets/assets.db"

Quote = ->(v) {
  return "NULL" if v.nil?
  v = v.to_s
  return "NULL" if v.empty? || v == "null"
  "'#{v.gsub("'", "''")}'"
}

IntFields = %w[width height file_size]

ImageInsert = ->(img) {
  fields = %w[id domain filename original_url source_url title source identifier license
              width height file_size downloaded_at creator work_type description medium
              phys_dimensions subjects date_text collection iiif_base_url]
  vals = fields.map { |f|
    v = img[f] || img[f.to_sym]
    IntFields.include?(f) ? (v || 0).to_s : Quote.call(v)
  }
  sql = "INSERT INTO images (#{fields.join(",")}) VALUES (#{vals.join(",")});"
  system("sqlite3", DB, sql)
}

UrlInsert = ->(image_id, role, url) {
  id = "url-#{image_id}-#{role}"
  sql = "INSERT OR IGNORE INTO urls VALUES ('#{id.gsub("'","''")}','#{image_id.gsub("'","''")}','#{role}','#{url.gsub("'","''")}');"
  system("sqlite3", DB, sql)
}

FtsRebuild = -> {
  system("sqlite3", DB, "DELETE FROM images_fts; INSERT INTO images_fts (id, title, source, identifier, domain) SELECT id, title, source, identifier, domain FROM images;")
}

ImageExists = ->(id) {
  `sqlite3 #{DB} "SELECT 1 FROM images WHERE id='#{id.gsub("'","''")}' LIMIT 1"`.strip == "1"
}

ImageCount = -> {
  `sqlite3 #{DB} "SELECT count(*) FROM images"`.strip.to_i
}

DomainCount = -> {
  rows = `sqlite3 -separator '|' #{DB} "SELECT domain, count(*) FROM images GROUP BY domain ORDER BY count(*) DESC"`.strip.split("\n")
  rows.map { |r| r.split("|") }
}
