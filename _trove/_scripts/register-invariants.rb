#!/usr/bin/env ruby
# register-invariants.rb — register _trove/math/invariant-theory PDFs in findings.db
# Functional Ruby: pure lambdas, stdlib json, sqlite3 gem
# Metadata source: _trove/math/invariant-theory/meta.json (captured via MCP lookup)

$stdout.sync = true

require "sqlite3"
require "json"

Root = File.expand_path("..", __dir__)
DbPath = File.join(Root, "findings.db")
OutDir = File.join(Root, "math", "invariant-theory")
Domain = "math"
Subdomain = "invariant-theory"

Papers = [
  ["1512.06411", "hilbert-series-noncommutative-invariant-theory.pdf"],
  ["2511.07718", "homological-properties-invariant-rings-permutation-groups.pdf"],
  ["alg-geom/9402008", "variation-git-quotients.pdf"],
  ["2506.19431", "compgit-package.pdf"],
  ["math/0112026", "quandle-homology-cocycle-knot-invariants.pdf"],
  ["1910.11129", "instantons-concordance-invariants-knots.pdf"],
  ["1112.6290", "cohomological-invariants-weyl-groups-mod-2.pdf"],
  ["2302.03021", "kontsevich-characteristic-classes-topological-invariants.pdf"],
].freeze

MetaPath = File.join(OutDir, "meta.json")

Entries = lambda do
  JSON.parse(File.read(MetaPath))
end

ParseEntry = lambda do |xml, arxiv_id|
  doc = REXML::Document.new(xml)
  return nil unless doc.root

  entry = doc.root.get_elements("entry").find { |e| e.to_s.include?(arxiv_id) }
  return nil unless entry

  {
    title: entry.elements["title"]&.text&.strip.to_s,
    authors: entry.get_elements("author/name").map { |n| n.text.to_s.strip }.join(", "),
    published: entry.elements["published"]&.text.to_s[0, 10],
    category: entry.to_s[/term="([^"]+)"/, 1].to_s,
  }
end

InsertPaper = lambda do |db, meta|
  row_id = [Domain, Subdomain, meta["filename"]].join("/")
  size = File.size(File.join(OutDir, meta["filename"]))

  db.execute(<<~SQL, [row_id, Domain, Subdomain, meta["filename"], meta["title"], meta["authors"], meta["arxiv_id"], size, meta["published"]])
    INSERT INTO papers (id, domain, subdomain, filename, title, authors, arxiv_id, file_size, file_type, source, published_at, topic, tags)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pdf', 'arxiv', ?, 'invariant-theory', 'invariants,math')
    ON CONFLICT(id) DO UPDATE SET
      title=excluded.title, authors=excluded.authors, arxiv_id=excluded.arxiv_id,
      file_size=excluded.file_size, source='arxiv', published_at=excluded.published_at
  SQL

  db.execute(<<~SQL, [row_id, meta["category"]])
    INSERT INTO arxiv_metadata (paper_id, primary_category, doi)
    VALUES (?, ?, '')
    ON CONFLICT(paper_id) DO UPDATE SET primary_category=excluded.primary_category
  SQL

  row_id
end

db = SQLite3::Database.new(DbPath)
ok = 0

Entries.call.each do |arxiv_id, meta|
  filename = meta["filename"]
  unless File.file?(File.join(OutDir, filename))
    puts "skip    #{filename} (missing)"
    next
  end

  full = meta.merge("arxiv_id" => arxiv_id)
  InsertPaper.call(db, full)
  puts "ok      %-58s %-14s %s" % [filename, arxiv_id, meta["published"]]
  ok += 1
end

puts "result ok=#{ok} db=#{DbPath}"
