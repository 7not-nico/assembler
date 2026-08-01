require 'sqlite3'

DB_PATH = File.join(__dir__, 'knowledge.db')

unless File.exist?(DB_PATH)
  puts "knowledge.db not found. Run sync-knowledge-db.rb first."
  exit 1
end

DB = SQLite3::Database.new(DB_PATH)

def show_help
  puts "Usage: ruby query-knowledge.rb [option]"
  puts
  puts "  domain=<name>    — filter by domain (e.g. ruby)"
  puts "  slug=<name>      — filter by slug (e.g. string-slice)"
  puts "  concept=<text>   — search concepts by keyword"
  puts "  keyword=<text>   — search titles and concerns"
  puts "  --all            — list all files"
  puts "  --stats          — summary statistics"
  puts "  --full=<slug>    — show file details with concepts and practice results"
end

def format_rows(rows)
  if rows.empty?
    puts "  (none)"
    return
  end
  fmt = "%-16s %-24s %-48s %s"
  puts fmt % ['Slug', 'Title', 'Concern', 'Practice']
  puts '-' * 100
  rows.each do |r|
    practice = r[5] ? "#{r[5]}p/#{r[6]}f" : '—'
    puts fmt % [r[0], r[1][0..23], r[2][0..47], practice]
  end
end

# handle --full slug (two args) by merging into single ARGV[0]
ARGV[0] = "--full=#{ARGV[1]}" if ARGV[0] == '--full' && ARGV[1]

case ARGV[0]
when '--help', '-h'
  show_help

when '--all'
  rows = DB.execute("SELECT f.slug, f.title, f.concern, f.domain, f.path, p.passed, p.failed
                     FROM files f LEFT JOIN practices p ON f.id = p.file_id
                     ORDER BY f.domain, f.slug")
  format_rows(rows)

when '--stats'
  files = DB.get_first_value("SELECT COUNT(*) FROM files")
  concepts = DB.get_first_value("SELECT COUNT(*) FROM concepts")
  domains = DB.get_first_value("SELECT COUNT(DISTINCT domain) FROM files")
  total_pass = DB.get_first_value("SELECT COALESCE(SUM(passed),0) FROM practices")
  total_fail = DB.get_first_value("SELECT COALESCE(SUM(failed),0) FROM practices")
  puts "knowledge.db statistics:"
  puts "  Domains:  #{domains}"
  puts "  Files:    #{files}"
  puts "  Concepts: #{concepts}"
  puts "  Practice: #{total_pass} passed, #{total_fail} failed"

when /\A--full=(.+)\z/  # --full=slug or --full slug
  slug = $1
  file = DB.get_first_row("SELECT f.*, p.passed, p.failed, p.last_run
                            FROM files f LEFT JOIN practices p ON f.id = p.file_id
                            WHERE f.slug=?", [slug])
  unless file
    puts "File not found: #{slug}"
    exit 1
  end
  puts "Slug:     #{file[2]}"
  puts "Domain:   #{file[1]}"
  puts "Title:    #{file[3]}"
  puts "Concern:  #{file[4]}"
  puts "Path:     #{file[5]}"
  puts "Created:  #{file[7]}"
  puts "Modified: #{file[8]}"
  passed = file[9]; failed = file[10]; last_run = file[11]
  puts "Practice: #{passed || '?'}p / #{failed || '?'}f  (last: #{last_run || 'never'})"
  concepts = DB.execute("SELECT concept, category FROM concepts WHERE file_id=? ORDER BY id", [file[0]])
  unless concepts.empty?
    puts "\nConcepts:"
    concepts.each { |c| puts "  [#{c[1]}] #{c[0]}" }
  end

when /\Adomain=(.+)\z/
  rows = DB.execute("SELECT f.slug, f.title, f.concern, f.domain, f.path, p.passed, p.failed
                     FROM files f LEFT JOIN practices p ON f.id = p.file_id
                     WHERE f.domain=? ORDER BY f.slug", [$1])
  format_rows(rows)

when /\Aslug=(.+)\z/
  rows = DB.execute("SELECT f.slug, f.title, f.concern, f.domain, f.path, p.passed, p.failed
                     FROM files f LEFT JOIN practices p ON f.id = p.file_id
                     WHERE f.slug LIKE ? ORDER BY f.slug", ["%#{$1}%"])
  format_rows(rows)

when /\Aconcept=(.+)\z/
  rows = DB.execute("SELECT DISTINCT f.slug, f.title, f.concern, f.domain, f.path, p.passed, p.failed
                     FROM files f
                     LEFT JOIN practices p ON f.id = p.file_id
                     JOIN concepts c ON c.file_id = f.id
                     WHERE c.concept LIKE ?
                     ORDER BY f.slug", ["%#{$1}%"])
  format_rows(rows)

when /\Akeyword=(.+)\z/
  kw = "%#{$1}%"
  rows = DB.execute("SELECT f.slug, f.title, f.concern, f.domain, f.path, p.passed, p.failed
                     FROM files f LEFT JOIN practices p ON f.id = p.file_id
                     WHERE f.title LIKE ? OR f.concern LIKE ?
                     ORDER BY f.slug", [kw, kw])
  format_rows(rows)

else
  show_help
end
